function OpenSCManagerW
{
<#
.SYNOPSIS

Tests if the current user has administrative access to the local (or a remote) machine.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect  

.DESCRIPTION

This function will use the OpenSCManagerW Win32API call to establish
a handle to the remote host. If this succeeds, the current user context
has local administrator acess to the target. The retunred value is
a handle to the specified service control manager database.

.PARAMETER ComputerName

Specifies the hostname to check for local admin access (also accepts IP addresses).
If null, then the local machine is used.

.PARAMETER DesiredAccess

The access to the service control manager. One of 'ALL_ACCESS', 'CREATE_SERVICE',
'CONNECT', 'ENUMERATE_SERVICE', 'LOCK', 'MODIFY_BOOT_CONFIG', ir 'QUERY_LOCK_STATUS'.

Default of 'ALL_ACCESS'.

.NOTES

(func advapi32 OpenSCManagerW ([IntPtr]) @(
    [String],       # _In_opt_ LPCTSTR lpMachineName
    [String],       # _In_opt_ LPCTSTR lpDatabaseName
    [Int]           # _In_     DWORD   dwDesiredAccess
) -EntryPoint OpenSCManagerW -SetLastError)

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/ms684323(v=vs.85).aspx

.EXAMPLE

#>
    
    [OutputType([IntPtr])]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [String]
        $ComputerName = $ENV:ComputerName,

        [ValidateSet('ALL_ACCESS', 'CREATE_SERVICE', 'CONNECT', 'ENUMERATE_SERVICE', 'LOCK', 'MODIFY_BOOT_CONFIG', 'QUERY_LOCK_STATUS')]
        [String]
        $DesiredAccess  = 'ALL_ACCESS'
    )

    # from https://msdn.microsoft.com/en-us/library/windows/desktop/ms685981(v=vs.85).aspx
    $Access = Switch ($DesiredAccess) {
        'ALL_ACCESS' { 0xF003F }
        'CREATE_SERVICE' { 0x0002 }
        'CONNECT' { 0x0001 }
        'ENUMERATE_SERVICE' { 0x0004 }
        'LOCK' { 0x0008 }
        'MODIFY_BOOT_CONFIG' { 0x0020 }
        'QUERY_LOCK_STATUS' { 0x0010 }
    }

    # 0xF003F - SC_MANAGER_ALL_ACCESS
    #   http://msdn.microsoft.com/en-us/library/windows/desktop/ms685981(v=vs.85).aspx
    $Handle = $Advapi32::OpenSCManagerW("\\$ComputerName", 'ServicesActive', $Access);$LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    # if we get a non-zero handle back, everything was successful
    if ($Handle -ne 0) {
        $Handle
    }
    else {
        throw "[OpenSCManagerW] OpenSCManagerW() Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}