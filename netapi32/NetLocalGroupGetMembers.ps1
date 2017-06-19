function NetLocalGroupGetMembers {
    <#
    .SYNOPSIS

    Enumerates members of a specific local group on the local (or remote) machine.

    .DESCRIPTION

    This function will execute the NetLocalGroupGetMembers Win32API call to query
    a given host for local group members.

    .PARAMETER ComputerName

    Specifies the hostname to query for local group members (also accepts IP addresses).
    Defaults to 'localhost'.

    .PARAMETER GroupName

    The local group name to query for users. If not given, it defaults to "Administrators".

    .PARAMETER Level

    Specifies the level of information to query from NetLocalGroupGetMembers.
    Default of 1. Affects the result structure returned.

    .NOTES

    Author: Will Schroeder (@harmj0y)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect, ConvertSidToStringSid (Function), NetApiBufferFree (Function)
    Optional Dependencies: None

    (func netapi32 NetLocalGroupGetMembers ([Int32]) @(
        [string],                 # _In_    LPCWSTR    servername
        [string],                 # _In_    LPCWSTR    localgroupname
        [Int32],                  # _In_    DWORD      level
        [IntPtr].MakeByRefType(), # _Out_   LPBYTE     *bufptr
        [Int32],                  # _In_    DWORD      prefmaxlen
        [Int32].MakeByRefType(),  # _Out_   LPDWORD    entriesread
        [Int32].MakeByRefType(),  # _Out_   LPDWORD    totalentries
        [Int32].MakeByRefType()   # _Inout_ PDWORD_PTR resumehandle
    ) -EntryPoint NetLocalGroupGetMembers)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa370601(v=vs.85).aspx

    .EXAMPLE
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = 'localhost',

        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupName = 'Administrators',

        [ValidateSet(0, 1, 2, 3)]
        [String]
        $Level = 1
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {
            $PtrInfo = [IntPtr]::Zero
            $EntriesRead = 0
            $TotalRead = 0
            $ResumeHandle = 0

            $Result = $Netapi32::NetLocalGroupGetMembers($Computer, $GroupName, $Level, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle)

            # locate the offset of the initial intPtr
            $Offset = $PtrInfo.ToInt64()

            # work out how much to increment the pointer by finding out the size of the structure
            $Increment = Switch ($Level) {
                0   { $LOCALGROUP_MEMBERS_INFO_0::GetSize() }
                1   { $LOCALGROUP_MEMBERS_INFO_1::GetSize() }
                2   { $LOCALGROUP_MEMBERS_INFO_2::GetSize() }
                3   { $LOCALGROUP_MEMBERS_INFO_3::GetSize() }
            }

            # 0 = success
            if (($Result -eq 0) -and ($Offset -gt 0)) {

                # parse all the result structures
                for ($i = 0; ($i -lt $EntriesRead); $i++) {
                    # create a new int ptr at the given offset and cast the pointer as our result structure
                    $NewIntPtr = New-Object System.Intptr -ArgumentList $Offset

                    # grab the appropriate result structure
                    $Info = Switch ($Level) {
                        0   { $NewIntPtr -as $LOCALGROUP_MEMBERS_INFO_0 }
                        1   { $NewIntPtr -as $LOCALGROUP_MEMBERS_INFO_1 }
                        2   { $NewIntPtr -as $LOCALGROUP_MEMBERS_INFO_2 }
                        3   { $NewIntPtr -as $LOCALGROUP_MEMBERS_INFO_3 }
                    }

                    # return all the sections of the structure - have to do it this way for V2
                    $Object = $Info | Select-Object *

                    # translate the SID ptr if we can
                    try
                    {
                        $Object.$($SIDPTR.Name) = ConvertSidToStringSid -SidPointer $SIDPTR.Value
                    }
                    catch
                    {
                        $Object.$($SIDPTR.Name) = ''
                    }

                    $Offset = $NewIntPtr.ToInt64()
                    $Offset += $Increment
                    $Object
                }

                # free up the result buffer
                NetApiBufferFree -Buffer $PtrInfo
            }
            else {
                Write-Verbose "[NetLocalGroupGetMembers] Error: $(([ComponentModel.Win32Exception] $Result).Message)"
            }
        }
    }
}