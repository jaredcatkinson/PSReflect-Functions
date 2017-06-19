function NetLocalGroupAddMembers {
    <#
    .SYNOPSIS

    Adds a member to a specific local group on the local (or remote) machine.

    .DESCRIPTION

    This function will execute the NetLocalGroupAddMembers Win32API call to add
    a member to the specified local group on a specified host.

    .PARAMETER ComputerName

    Specifies the hostname to add the local group member to (also accepts IP addresses).
    Defaults to 'localhost'.

    .PARAMETER MemberName

    The member to add to the local group, in COMPUTER\member or DOMAIN\member syntax.

    .PARAMETER GroupName

    The local group name to add the member to. If not given, it defaults to "Administrators".

    .NOTES

    Author: Will Schroeder (@harmj0y)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func netapi32 NetLocalGroupAddMembers ([Int32]) @(
        [string],                   # _In_ LPCWSTR servername
        [string],                   # _In_ LPCWSTR groupname
        [Int32],                    # _In_ DWORD   level
        [IntPtr].MakeByRefType(),   # _In_ LPBYTE  buf
        [Int32]                     # _In_ DWORD   totalentries
    ) -EntryPoint NetLocalGroupAddMembers)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa370436(v=vs.85).aspx

    .EXAMPLE
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = 'localhost',

        [Parameter(Position = 1, Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [ValidatePattern('.*\\.*')]
        [String]
        $MemberName,

        [Parameter(Position = 2, ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupName = 'Administrators'
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {

            $MemberStruct = [Activator]::CreateInstance($LOCALGROUP_MEMBERS_INFO_3)
            $MemberStruct.lgrmi3_domainandname = $MemberName

            [IntPtr]$MemberStructPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($LOCALGROUP_MEMBERS_INFO_3::GetSize())
            [Runtime.InteropServices.Marshal]::StructureToPtr($MemberStruct, $MemberStructPtr, $False)

            $Result = $Netapi32::NetLocalGroupAddMembers($Computer, $GroupName, 3, $MemberStructPtr, 1)

            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($MemberStructPtr)

            if ($Result -eq 0) {
                Write-Verbose "Member '$MemberName' successfully added to local group '$GroupName' on server '$Computer'"
            }
            else {
                Throw "[NetLocalGroupAddMembers] Error adding member '$MemberName' to local group '$GroupName' on server '$Computer' : $(([ComponentModel.Win32Exception]$Result).Message)"
            }
        }
    }
}