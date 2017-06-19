function NetFileEnum {
    <#
    .SYNOPSIS

    Returns information about some or all open files on the local (or a remote) machine.
    Note: this requires admin rights on the remote system.

    .DESCRIPTION

    This function will execute the NetFileEnum Win32API call to query
    a given host for open files.

    .PARAMETER ComputerName

    Specifies the hostname to query for files (also accepts IP addresses).
    Defaults to 'localhost'.

    .PARAMETER Level

    Specifies the level of information to query from NetFileEnum.
    Default of 3. Affects the result structure returned.

    .NOTES
    
    Author: Will Schroeder (@harmj0y)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect, NetApiBufferFree (Function)
    Optional Dependencies: None

    (func netapi32 NetFileEnum ([Int32]) @(
        [string],                   # _In_    LMSTR      servername
        [string],                   # _In_    LMSTR      basepath
        [string],                   # _In_    LMSTR      username
        [Int32],                    # _In_    DWORD      level
        [IntPtr].MakeByRefType(),   # _Out_   LPBYTE     *bufptr
        [Int32],                    # _In_    DWORD      prefmaxlen
        [Int32].MakeByRefType(),    # _Out_   LPDWORD    entriesread
        [Int32].MakeByRefType(),    # _Out_   LPDWORD    totalentries
        [Int32].MakeByRefType()     # _Inout_ PDWORD_PTR resume_handle
    ) -EntryPoint NetFileEnum)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/bb525378(v=vs.85).aspx

    .EXAMPLE
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = 'localhost',

        [ValidateSet(2, 3)]
        [Int]
        $Level = 3
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {
            $PtrInfo = [IntPtr]::Zero
            $EntriesRead = 0
            $TotalRead = 0
            $ResumeHandle = 0

            $Result = $Netapi32::NetFileEnum($Computer, '', '', $Level, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle);

            # locate the offset of the initial intPtr
            $Offset = $PtrInfo.ToInt64()

            # work out how much to increment the pointer by finding out the size of the structure
            $Increment = Switch ($Level) {
                2   { $FILE_INFO_2::GetSize() }
                3   { $FILE_INFO_3::GetSize() }
            }

            # 0 = success
            if (($Result -eq 0) -and ($Offset -gt 0)) {

                # parse all the result structures
                for ($i = 0; ($i -lt $EntriesRead); $i++) {
                    # create a new int ptr at the given offset and cast the pointer as our result structure
                    $NewIntPtr = New-Object System.Intptr -ArgumentList $Offset

                    # grab the appropriate result structure
                    $Info = Switch ($Level) {
                        2   { $NewIntPtr -as $FILE_INFO_2 }
                        3   { $NewIntPtr -as $FILE_INFO_3 }
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
                Write-Verbose "[NetFileEnum] Error: $(([ComponentModel.Win32Exception] $Result).Message)"
            }
        }
    }
}