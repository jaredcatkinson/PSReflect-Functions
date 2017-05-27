function NetLocalGroupDelMembers {
<#
.SYNOPSIS

Deletes a specified member from a specific local group on the local (or remote) machine.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the NetLocalGroupDelMembers Win32API call to delete
a specified member from the specified local group on a specified host.

.PARAMETER ComputerName

Specifies the hostname to delete the local group member from (also accepts IP addresses).
Defaults to 'localhost'.

.PARAMETER MemberName

The member to delete from the local group, in COMPUTER\member or DOMAIN\member syntax.

.PARAMETER GroupName

The local group name to delete the member from. If not given, it defaults to "Administrators".

.NOTES

    (func netapi32 NetLocalGroupDelMembers ([Int]) @(
        [String],                   # _In_ LPCWSTR servername
        [String],                   # _In_ LPCWSTR groupname
        [Int],                      # _In_ DWORD   level
        [IntPtr],                   # _In_ LPBYTE  buf
        [Int]                       # _In_ DWORD   totalentries
    )

.EXAMPLE


.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa370439(v=vs.85).aspx
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
            [Runtime.InteropServices.Marshal]::StructureToPtr($MemberStruct, $MemberStructPtr, $false)

            $Result = $Netapi32::NetLocalGroupDelMembers($Computer, $GroupName, 3, $MemberStructPtr, 1)

            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($MemberStructPtr)

            if ($Result -eq 0) {
                Write-Verbose "Member '$MemberName' successfully delete from local group '$GroupName' on server '$Computer'"
            }
            else {
                Throw "[NetLocalGroupDelMembers] Error deleting member '$MemberName' from local group '$GroupName' on server '$Computer' : $(([ComponentModel.Win32Exception]$Result).Message)"
            }
        }
    }
}


$Module = New-InMemoryModule -ModuleName Win32

$LOCALGROUP_MEMBERS_INFO_3  = struct $Module LOCALGROUP_MEMBERS_INFO_3 @{
    lgrmi3_domainandname    = field 0 String -MarshalAs @('LPWStr')
}


$FunctionDefinitions = @(
    (func netapi32 NetLocalGroupDelMembers ([Int]) @([String], [String], [Int], [IntPtr], [Int]))
)

$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Netapi32 = $Types['netapi32']
