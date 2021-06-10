function OpenSCManagerW
{
    <#
    .SYNOPSIS

    Tests if the current user has administrative access to the local (or a remote) machine. 

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

    Author: Will Schroeder (@harmj0y)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect, SC_MANAGER_ACCESS (Enumeration)
    Optional Dependencies: None

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
        [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('HostName', 'dnshostname', 'name', 'lpMachineName')]
        [String]
        $ComputerName = $ENV:ComputerName,

        [Parameter()]
        [ValidateSet('SC_MANAGER_ALL_ACCESS', 'SC_MANAGER_CREATE_SERVICE', 'SC_MANAGER_CONNECT', 'SC_MANAGER_ENUMERATE_SERVICE', 'SC_MANAGER_LOCK', 'SC_MANAGER_MODIFY_BOOT_CONFIG', 'SC_MANAGER_QUERY_LOCK_STATUS')]
        [Alias('dwDesiredAccess')]
        [String[]]
        $DesiredAccess  = 'SC_MANAGER_ALL_ACCESS'
    )

    # Calculate Desired Access Value
    $dwDesiredAccess = 0
    
    foreach($val in $DesiredAccess)
    {
        $dwDesiredAccess = $dwDesiredAccess -bor $SC_MANAGER_ACCESS::$val
    }

    #   http://msdn.microsoft.com/en-us/library/windows/desktop/ms685981(v=vs.85).aspx
    $Handle = $Advapi32::OpenSCManagerW("\\$ComputerName", 'ServicesActive', $dwDesiredAccess);$LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    # if we get a non-zero handle back, everything was successful
    if ($Handle -ne 0) {
        $Handle
    }
    else {
        throw "[OpenSCManagerW] OpenSCManagerW() Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}