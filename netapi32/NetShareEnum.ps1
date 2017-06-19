function NetShareEnum {
    <#
    .SYNOPSIS

    Returns open shares on the local (or a remote) machine.
    Note: anything above level 2 requires admin rights on a remote system.

    .DESCRIPTION

    This function will execute the NetShareEnum Win32API call to query
    a given host for open shares. This is a replacement for "net share \\hostname".

    .PARAMETER ComputerName

    Specifies the hostname to query for shares (also accepts IP addresses).
    Defaults to 'localhost'.

    .PARAMETER Level

    Specifies the level of information to query from NetShareEnum.
    Default of 1. Affects the result structure returned.

    .NOTES

    Author: Will Schroeder (@harmj0y)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect, NetApiBufferFree (Function)
    Optional Dependencies: None

    (func netapi32 NetShareEnum ([Int]) @(
        [String],                                   # _In_    LPWSTR  servername
        [Int32],                                    # _In_    DWORD   level
        [IntPtr].MakeByRefType(),                   # _Out_   LPBYTE  *bufptr
        [Int32],                                    # _In_    DWORD   prefmaxlen
        [Int32].MakeByRefType(),                    # _Out_   LPDWORD entriesread
        [Int32].MakeByRefType(),                    # _Out_   LPDWORD totalentries
        [Int32].MakeByRefType()                     # _Inout_ LPDWORD resume_handle
    ) -EntryPoint NetShareEnum)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/bb525387(v=vs.85).aspx

    .EXAMPLE
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = 'localhost',

        [ValidateSet(0, 1, 2, 502, 503)]
        [String]
        $Level = 1
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {
            $PtrInfo = [IntPtr]::Zero
            $EntriesRead = 0
            $TotalRead = 0
            $ResumeHandle = 0

            # get the raw share information
            $Result = $Netapi32::NetShareEnum($Computer, $Level, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle)

            # locate the offset of the initial intPtr
            $Offset = $PtrInfo.ToInt64()

            # work out how much to increment the pointer by finding out the size of the structure
            $Increment = Switch ($Level) {
                0   { $SHARE_INFO_0::GetSize() }
                1   { $SHARE_INFO_1::GetSize() }
                2   { $SHARE_INFO_2::GetSize() }
                502 { $SHARE_INFO_502::GetSize() }
                503 { $SHARE_INFO_503::GetSize() }
            }

            # 0 = success
            if (($Result -eq 0) -and ($Offset -gt 0)) {

                # parse all the result structures
                for ($i = 0; ($i -lt $EntriesRead); $i++) {
                    # create a new int ptr at the given offset and cast the pointer as our result structure
                    $NewIntPtr = New-Object System.Intptr -ArgumentList $Offset

                    # grab the appropriate result structure
                    $Info = Switch ($Level) {
                        0   { $NewIntPtr -as $SHARE_INFO_0 }
                        1   { $NewIntPtr -as $SHARE_INFO_1 }
                        2   { $NewIntPtr -as $SHARE_INFO_2 }
                        502 { $NewIntPtr -as $SHARE_INFO_502 }
                        503 { $NewIntPtr -as $SHARE_INFO_503 }
                    }

                    # return all the sections of the structure - have to do it this way for V2
                    $Object = $Info | Select-Object *
                    $Offset = $NewIntPtr.ToInt64()
                    $Offset += $Increment
                    $Object
                }

                # free up the result buffer
                NetApiBufferFree -Buffer $PtrInfo
            }
            else {
                Write-Verbose "[NetShareEnum] Error: $(([ComponentModel.Win32Exception] $Result).Message)"
            }
        }
    }
}