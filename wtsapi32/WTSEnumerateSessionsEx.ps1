function WTSEnumerateSessionsEx {
<#
.SYNOPSIS

Retrieves a list of sessions on a specified Remote Desktop Session Host (RD Session Host)
server or Remote Desktop Virtualization Host (RD Virtualization Host) server.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the WTSEnumerateSessionsEx Win32API call to 
enumerate a given RD session host for sessions.

.PARAMETER Handle

Handle to the RD session host to query session information for.

.NOTES

(func wtsapi32 WTSEnumerateSessionsEx ([Int]) @(
    [IntPtr],                   # _In_    HANDLE              hServer
    [Int32].MakeByRefType(),    # _Inout_ DWORD               *pLevel
    [Int],                      # _In_    DWORD               Filter
    [IntPtr].MakeByRefType(),   # _Out_   PWTS_SESSION_INFO_1 *ppSessionInfo
    [Int32].MakeByRefType()     # _Out_   DWORD               *pCount
) -SetLastError)

.EXAMPLE

.LINK

https://msdn.microsoft.com/en-us/library/ee621014(v=vs.85).aspx
#>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('hServer')]
        [ValidateNotNullOrEmpty()]
        [IntPtr]
        $Handle
    )

    PROCESS {
        # arguments for WTSEnumerateSessionsEx
        $ppSessionInfo = [IntPtr]::Zero
        $pCount = 0

        # get information on all current sessions
        $Result = $Wtsapi32::WTSEnumerateSessionsEx($Handle, [ref]1, 0, [ref]$ppSessionInfo, [ref]$pCount);$LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

        # locate the offset of the initial intPtr
        $Offset = $ppSessionInfo.ToInt64()

        # work out how much to increment the pointer by finding out the size of the structure
        $Increment = $WTS_SESSION_INFO_1::GetSize()

        if (($Result -ne 0) -and ($Offset -gt 0)) {
            # parse all the result structures
            for ($i = 0; ($i -lt $pCount); $i++) {

                # create a new int ptr at the given offset and cast the pointer as our result structure
                $NewIntPtr = New-Object System.Intptr -ArgumentList $Offset
                $Info = $NewIntPtr -as $WTS_SESSION_INFO_1

                # return all the sections of the structure - have to do it this way for V2
                $Object = $Info | Select-Object *
                $Offset = $NewIntPtr.ToInt64()
                $Offset += $Increment
                $Object
            }
            # free up the memory result buffer
            $Null = $Wtsapi32::WTSFreeMemoryEx(2, $ppSessionInfo, $pCount)
        }
        else {
            Write-Verbose "[WTSEnumerateSessionsEx] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
        }
    }
}

$FunctionDefinitions = @(
    (func wtsapi32 WTSOpenServerEx ([IntPtr]) @([String])),
    (func wtsapi32 WTSEnumerateSessionsEx ([Int]) @([IntPtr], [Int32].MakeByRefType(), [Int], [IntPtr].MakeByRefType(), [Int32].MakeByRefType()) -SetLastError),
    (func wtsapi32 WTSFreeMemoryEx ([Int]) @([Int32], [IntPtr], [Int32])),
    (func wtsapi32 WTSCloseServer ([Int]) @([IntPtr]))
)

$Module = New-InMemoryModule -ModuleName Win32
$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Wtsapi32 = $Types['wtsapi32']


# enum used by $WTS_SESSION_INFO_1 below
$WTS_CONNECTSTATE_CLASS = psenum $Module WTS_CONNECTSTATE_CLASS UInt16 @{
    WTSActive              =    0
    WTSConnected           =    1
    WTSConnectQuery        =    2
    WTSShadow              =    3
    WTSDisconnected        =    4
    WTSIdle                =    5
    WTSListen              =    6
    WTSReset               =    7
    WTSDown                =    8
    WTSInit                =    9
}

# the WTSEnumerateSessionsEx result structure
$WTS_SESSION_INFO_1     = struct $Module WTS_SESSION_INFO_1 @{
    ExecEnvId           = field 0 UInt32
    State               = field 1 $WTS_CONNECTSTATE_CLASS
    SessionId           = field 2 UInt32
    pSessionName        = field 3 String -MarshalAs @('LPWStr')
    pHostName           = field 4 String -MarshalAs @('LPWStr')
    pUserName           = field 5 String -MarshalAs @('LPWStr')
    pDomainName         = field 6 String -MarshalAs @('LPWStr')
    pFarmName           = field 7 String -MarshalAs @('LPWStr')
}
