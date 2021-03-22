function CreateServiceW
{
    <#
    .SYNOPSIS

    Creates a service object and adds it to the specified service control manager database.

    .DESCRIPTION

    The CreateService function creates a service object and installs it in the service control manager database by creating a key with the same name as the service under the following registry key:HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services

    Information specified by CreateService, ChangeServiceConfig, and ChangeServiceConfig2 is saved as values under this key.

    .PARAMETER Handle

    A handle to the service control manager database. This handle is returned by the OpenSCManager function and must have the SC_MANAGER_CREATE_SERVICE access right.

    .PARAMETER ServiceName

    The name of the service to install. The maximum string length is 256 characters. The service control manager database preserves the case of the characters, but service name comparisons are always case insensitive. Forward-slash (/) and backslash (\) are not valid service name characters.

    .PARAMETER DisplayName

    The display name to be used by user interface programs to identify the service. This string has a maximum length of 256 characters. The name is case-preserved in the service control manager. Display name comparisons are always case-insensitive.

    .PARAMETER DesiredAccess

    The access to the service. Before granting the requested access, the system checks the access token of the calling process.

    .PARAMETER ServiceType

    The service type.

    .PARAMETER StartType

    The service start options.

    .PARAMETER ErrorControl

    The severity of the error, and action taken, if this service fails to start.

    .PARAMETER UserName

    The name of the account under which the service should run. If the service type is SERVICE_WIN32_OWN_PROCESS, use an account name in the form DomainName\UserName. The service process will be logged on as this user. If the account belongs to the built-in domain, you can specify .\UserName.

    If this parameter is NULL, CreateService uses the LocalSystem account. If the service type specifies SERVICE_INTERACTIVE_PROCESS, the service must run in the LocalSystem account.

    If this parameter is NT AUTHORITY\LocalService, CreateService uses the LocalService account. If the parameter is NT AUTHORITY\NetworkService, CreateService uses the NetworkService account.

    A shared process can run as any user.

    If the service type is SERVICE_KERNEL_DRIVER or SERVICE_FILE_SYSTEM_DRIVER, the name is the driver object name that the system uses to load the device driver. Specify NULL if the driver is to use a default object name created by the I/O system.

    A service can be configured to use a managed account or a virtual account. If the service is configured to use a managed service account, the name is the managed service account name. If the service is configured to use a virtual account, specify the name as NT SERVICE\ServiceName.

    Windows Server 2008, Windows Vista, Windows Server 2003 and Windows XP:  Managed service accounts and virtual accounts are not supported until Windows 7 and Windows Server 2008 R2.

    .PARAMETER Password

    The password to the account name specified by the lpServiceStartName parameter. Specify an empty string if the account has no password or if the service runs in the LocalService, NetworkService, or LocalSystem account.

    If the account name specified by the lpServiceStartName parameter is the name of a managed service account or virtual account name, the lpPassword parameter must be NULL.

    Passwords are ignored for driver services.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect, SERVICE_ACCESS (Enumeration), SERVICE_TYPE (Enumeration), SERVICE_START_TYPE (Enumeration), SERVICE_ERROR (Enumeration)
    Optional Dependencies: None

    (func advapi32 CreateServiceW ([IntPtr]) @(
        [IntPtr], # SC_HANDLE hSCManager
        [string], # LPCWSTR   lpServiceName
        [string], # LPCWSTR   lpDisplayName
        [UInt32], # DWORD     dwDesiredAccess
        [UInt32], # DWORD     dwServiceType
        [UInt32], # DWORD     dwStartType
        [UInt32], # DWORD     dwErrorControl
        [string], # LPCWSTR   lpBinaryPathName
        [string], # LPCWSTR   lpLoadOrderGroup
        [IntPtr], # LPDWORD   lpdwTagId
        [string], # LPCWSTR   lpDependencies
        [string], # LPCWSTR   lpServiceStartName
        [string]  # LPCWSTR   lpPassword
    ) -EntryPoint CreateServiceW -SetLastError)

    .LINK

    https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-createservicew

    .EXAMPLE

    #>
    
    [OutputType([IntPtr])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $Handle,

        [Parameter(Mandatory = $true)]
        [string]
        $ServiceName,

        [Parameter(Mandatory = $true)]
        [string]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateSet('SERVICE_QUERY_CONFIG', 'SERVICE_CHANGE_CONFIG', 'SERVICE_QUERY_STATUS', 'SERVICE_ENUMERATE_DEPENDENTS', 'SERVICE_START', 'SERVICE_STOP', 'SERVICE_PAUSE_CONTINUE', 'SERVICE_INTERROGATE', 'SERVICE_USER_DEFINED_CONTROL', 'DELETE', 'READ_CONTROL', 'WRITE_DAC', 'WRITE_OWNER', 'SERVICE_ALL_ACCESS', 'ACCESS_SYSTEM_SECURITY')]
        [string]
        $DesiredAccess,

        [Parameter(Mandatory = $true)]
        [ValidateSet('SERVICE_ADAPTER', 'SERVICE_FILE_SYSTEM_DRIVER', 'SERVICE_KERNEL_DRIVER', 'SERVICE_RECOGNIZER_DRIVER', 'SERVICE_WIN32_OWN_PROCESS', 'SERVICE_WIN32_SHARE_PROCESS', 'SERVICE_USER_OWN_PROCESS', 'SERVICE_USER_SHARE_PROCESS', 'SERVICE_INTERACTIVE_PROCESS')]
        [string[]]
        $ServiceType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('SERVICE_BOOT_START', 'SERVICE_SYSTEM_START', 'SERVICE_AUTO_START', 'SERVICE_DEMAND_START', 'SERVICE_DISABLED')]
        [string]
        $StartType,

        [Parameter()]
        [ValidateSet('SERVICE_ERROR_IGNORE', 'SERVICE_ERROR_NORMAL', 'SERVICE_ERROR_SEVERE', 'SERVICE_ERROR_CRITICAL')]
        [string]
        $ErrorControl = 'SERVICE_ERROR_IGNORE',

        [Parameter(Mandatory = $true)]
        [string]
        $BinaryPathName,

        [Parameter()]
        [string]
        $UserName = '',

        [Parameter()]
        [string]
        $Password = ''
    )

    # Calculate Desired Access Value
    $dwDesiredAccess = 0
    
    foreach($val in $DesiredAccess)
    {
        $dwDesiredAccess = $dwDesiredAccess -bor $SERVICE_ACCESS::$val
    }
    
    # Calculate Service Type Value
    $dwServiceType = 0

    foreach($val in $ServiceType)
    {
        $dwServiceType = $dwServiceType -bor $SERVICE_TYPE::$val
    }

    $handle = $Advapi32::CreateServiceW($Handle, $ServiceName, $DisplayName, $dwDesiredAccess, $dwServiceType, $SERVICE_START_TYPE::$StartType, $SERVICE_ERROR::$ErrorControl, $BinaryPathName, '', [IntPtr]::Zero, '', $UserName, $Password);$LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    # if we get a non-zero handle back, everything was successful
    if ($handle -ne 0) {
        $handle
    }
    else {
        throw "[CreateServiceW] CreateServiceW() Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}