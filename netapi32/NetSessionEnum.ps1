function NetSessionEnum {
<#
.SYNOPSIS

Returns session information for the local (or a remote) machine.
Note: administrative rights needed for newer Windows OSes for
query levels above 10.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the NetSessionEnum Win32API call to query
a given host for active sessions.

.PARAMETER ComputerName

Specifies the hostname to query for sessions (also accepts IP addresses).
Defaults to 'localhost'.

.PARAMETER Level

Specifies the level of information to query from NetSessionEnum.
Default of 10. Affects the result structure returned.

.NOTES

    (func netapi32 NetSessionEnum ([Int]) @(
        [String],                   # _In_    LPWSTR  servername
        [String],                   # _In_    LPWSTR  UncClientName
        [String],                   # _In_    LPWSTR  username
        [Int],                      # _In_    DWORD   level
        [IntPtr].MakeByRefType(),   # _Out_   LPBYTE  *bufptr
        [Int],                      # _In_    DWORD   prefmaxlen
        [Int32].MakeByRefType(),    # _Out_   LPDWORD entriesread
        [Int32].MakeByRefType(),    # _Out_   LPDWORD totalentries
        [Int32].MakeByRefType()     # _Inout_ LPDWORD resume_handle
    ) -EntryPoint NetSessionEnum)

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

        [ValidateSet(0, 1, 2, 10, 502)]
        [String]
        $Level = 10
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {
            $PtrInfo = [IntPtr]::Zero
            $EntriesRead = 0
            $TotalRead = 0
            $ResumeHandle = 0

            $Result = $Netapi32::NetSessionEnum($Computer, '', $UserName, $Level, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle)

            # locate the offset of the initial intPtr
            $Offset = $PtrInfo.ToInt64()

            # work out how much to increment the pointer by finding out the size of the structure
            $Increment = Switch ($Level) {
                0   { $SESSION_INFO_0::GetSize() }
                1   { $SESSION_INFO_1::GetSize() }
                2   { $SESSION_INFO_2::GetSize() }
                10  { $SESSION_INFO_10::GetSize() }
                502 { $SESSION_INFO_502::GetSize() }
            }

            # 0 = success
            if (($Result -eq 0) -and ($Offset -gt 0)) {

                # parse all the result structures
                for ($i = 0; ($i -lt $EntriesRead); $i++) {
                    # create a new int ptr at the given offset and cast the pointer as our result structure
                    $NewIntPtr = New-Object System.Intptr -ArgumentList $Offset

                    # grab the appropriate result structure
                    $Info = Switch ($Level) {
                        0   { $NewIntPtr -as $SESSION_INFO_0 }
                        1   { $NewIntPtr -as $SESSION_INFO_1 }
                        2   { $NewIntPtr -as $SESSION_INFO_2 }
                        10  { $NewIntPtr -as $SESSION_INFO_10 }
                        502 { $NewIntPtr -as $SESSION_INFO_502 }
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
                Write-Verbose "[NetSessionEnum] Error: $(([ComponentModel.Win32Exception] $Result).Message)"
            }
        }
    }
}