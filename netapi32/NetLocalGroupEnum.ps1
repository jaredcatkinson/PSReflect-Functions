function NetLocalGroupEnum {
<#
.SYNOPSIS

Enumerates the local groups on the local (or remote) machine.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the NetLocalGroupEnum Win32API call to query
a given host for local groups.

.PARAMETER ComputerName

Specifies the hostname to query for local groups (also accepts IP addresses).
Defaults to 'localhost'.

.PARAMETER Level

Specifies the level of information to query from NetLocalGroupEnum.
Default of 1. Affects the result structure returned.

.NOTES

    (func netapi32 NetLocalGroupEnum ([Int]) @(
        [String],                   # _In_    LPCWSTR    servername
        [Int],                      # _In_    DWORD      level
        [IntPtr].MakeByRefType(),   # _Out_   LPBYTE     *bufptr
        [Int],                      # _In_    DWORD      prefmaxlen
        [Int32].MakeByRefType(),    # _Out_   LPDWORD    entriesread
        [Int32].MakeByRefType(),    # _Out_   LPDWORD    totalentries
        [Int32].MakeByRefType())    # _Inout_ PDWORD_PTR resumehandle
    )

    (func netapi32 NetApiBufferFree ([Int]) @(
        [IntPtr]    # _In_ LPVOID Buffer
    )

.EXAMPLE


.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/bb525382(v=vs.85).aspx
#>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = 'localhost',

        [ValidateSet(0, 1)]
        [String]
        $Level = 1
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {
            $PtrInfo = [IntPtr]::Zero
            $EntriesRead = 0
            $TotalRead = 0
            $ResumeHandle = 0

            $Result = $Netapi32::NetLocalGroupEnum($Computer, $Level, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle)

            # locate the offset of the initial intPtr
            $Offset = $PtrInfo.ToInt64()

            # work out how much to increment the pointer by finding out the size of the structure
            $Increment = Switch ($Level) {
                0   { $LOCALGROUP_INFO_0::GetSize() }
                1   { $LOCALGROUP_INFO_1::GetSize() }
            }

            # 0 = success
            if (($Result -eq 0) -and ($Offset -gt 0)) {

                # parse all the result structures
                for ($i = 0; ($i -lt $EntriesRead); $i++) {
                    # create a new int ptr at the given offset and cast the pointer as our result structure
                    $NewIntPtr = New-Object System.Intptr -ArgumentList $Offset

                    # grab the appropriate result structure
                    $Info = Switch ($Level) {
                        0   { $NewIntPtr -as $LOCALGROUP_INFO_0 }
                        1   { $NewIntPtr -as $LOCALGROUP_INFO_1 }
                    }

                    # return all the sections of the structure - have to do it this way for V2
                    $Object = $Info | Select-Object *
                    $Offset = $NewIntPtr.ToInt64()
                    $Offset += $Increment
                    $Object
                }

                # free up the result buffer
                $Null = $Netapi32::NetApiBufferFree($PtrInfo)
            }
            else {
                Write-Verbose "[NetLocalGroupEnum] Error: $(([ComponentModel.Win32Exception] $Result).Message)"
            }
        }
    }
}


$FunctionDefinitions = @(
    (func netapi32 NetLocalGroupEnum ([Int]) @([String], [Int], [IntPtr].MakeByRefType(), [Int], [Int32].MakeByRefType(), [Int32].MakeByRefType(), [Int32].MakeByRefType())),
    (func netapi32 NetApiBufferFree ([Int]) @([IntPtr]))
)

$Module = New-InMemoryModule -ModuleName Win32
$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Netapi32 = $Types['netapi32']


$LOCALGROUP_INFO_0  = struct $Module LOCALGROUP_INFO_0 @{
    lgrpi0_name     = field 0 String -MarshalAs @('LPWStr')
}

$LOCALGROUP_INFO_1  = struct $Module LOCALGROUP_INFO_1 @{
    lgrpi1_name     = field 0 String -MarshalAs @('LPWStr')
    lgrpi1_comment  = field 1 String -MarshalAs @('LPWStr')
}
