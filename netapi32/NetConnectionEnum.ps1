function NetConnectionEnum {
<#
.SYNOPSIS

Lists all connections made to a shared resource on the server or all connections
established from a particular computer.
Note: this requires admin rights on the remote system.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the NetConnectionEnum Win32API call to query
a given host for open connections.

.PARAMETER ComputerName

Specifies the hostname to query for connections (also accepts IP addresses).
Defaults to 'localhost'.

.PARAMETER ShareName

Specifies the share name to query connections for. Defaults to 'C$'.

.PARAMETER Level

Specifies the level of information to query from NetConnectionEnum.
Default of 1. Affects the result structure returned.

.NOTES
    
    (func netapi32 NetConnectionEnum ([Int]) @(
        [String],                   # _In_    LMSTR   servername
        [String],                   # _In_    LMSTR   qualifier
        [Int],                      # _In_    LMSTR   qualifier
        [IntPtr].MakeByRefType(),   # _Out_   LPBYTE  *bufptr
        [Int],                      # _In_    DWORD   prefmaxlen
        [Int32].MakeByRefType(),    # _Out_   LPDWORD entriesread
        [Int32].MakeByRefType(),    # _Out_   LPDWORD totalentries
        [Int32].MakeByRefType())    # _Inout_ LPDWORD resume_handle
    )

    (func netapi32 NetApiBufferFree ([Int]) @(
        [IntPtr]    # _In_ LPVOID Buffer
    )

.EXAMPLE


.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/bb525376(v=vs.85).aspx
#>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = 'localhost',

        [ValidateNotNullOrEmpty()]
        [String]
        $ShareName = 'C$',

        [ValidateSet(0, 1)]
        [Int]
        $Level = 1
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {
            $PtrInfo = [IntPtr]::Zero
            $EntriesRead = 0
            $TotalRead = 0
            $ResumeHandle = 0

            $Result = $Netapi32::NetConnectionEnum($Computer, $ShareName, $Level, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle);
            
            # locate the offset of the initial intPtr
            $Offset = $PtrInfo.ToInt64()

            # work out how much to increment the pointer by finding out the size of the structure
            $Increment = Switch ($Level) {
                0   { $CONNECTION_INFO_0::GetSize() }
                1   { $CONNECTION_INFO_1::GetSize() }
            }

            # 0 = success
            if (($Result -eq 0) -and ($Offset -gt 0)) {

                # parse all the result structures
                for ($i = 0; ($i -lt $EntriesRead); $i++) {
                    # create a new int ptr at the given offset and cast the pointer as our result structure
                    $NewIntPtr = New-Object System.Intptr -ArgumentList $Offset

                    # grab the appropriate result structure
                    $Info = Switch ($Level) {
                        0   { $NewIntPtr -as $CONNECTION_INFO_0 }
                        1   { $NewIntPtr -as $CONNECTION_INFO_1 }
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
                Write-Verbose "[NetConnectionEnum] Error: $(([ComponentModel.Win32Exception] $Result).Message)"
            }
        }
    }
}