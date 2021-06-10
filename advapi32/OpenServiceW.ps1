function OpenServiceW
{
    <#
    .SYNOPSIS

    Opens an existing service.

    .DESCRIPTION

    The returned handle is only valid for the process that called OpenService. It can be closed by calling the CloseServiceHandle function.

    To use OpenService, no privileges are required aside from SC_MANAGER_CONNECT.

    .PARAMETER Handle

    A handle to the service control manager database. The OpenSCManager function returns this handle. For more information, see Service Security and Access Rights.

    .PARAMETER lpServiceName

    The name of the service to be opened. This is the name specified by the lpServiceName parameter of the CreateService function when the service object was created, not the service display name that is shown by user interface applications to identify the service.

    The maximum string length is 256 characters. The service control manager database preserves the case of the characters, but service name comparisons are always case insensitive. Forward-slash (/) and backslash (\) are invalid service name characters.

    .PARAMETER DesiredAccess

    The access to the service. For a list of access rights, see Service Security and Access Rights.

    Before granting the requested access, the system checks the access token of the calling process against the discretionary access-control list of the security descriptor associated with the service object.

    Default of 'ALL_ACCESS'.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect, SERVICE_ACCESS (Enumeration)
    Optional Dependencies: None

    (func advapi32 OpenServiceW ([IntPtr]) @(
        [IntPtr], # SC_HANDLE hSCManager
        [String], # LPCWSTR   lpServiceName
        [UInt32]    # DWORD     dwDesiredAccess
    ) -EntryPoint OpenServiceW -SetLastError)

    .LINK

    https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-openservicew

    .EXAMPLE

    #>
    
    [OutputType([IntPtr])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('hScManager')]
        [IntPtr]
        $Handle,

        [Parameter(Mandatory = $true)]
        [Alias('lpServiceName')]
        [String]
        $Name,

        [Parameter()]
        [ValidateSet('SERVICE_QUERY_CONFIG', 'SERVICE_CHANGE_CONFIG', 'SERVICE_QUERY_STATUS', 'SERVICE_ENUMERATE_DEPENDENTS', 'SERVICE_START', 'SERVICE_STOP', 'SERVICE_PAUSE_CONTINUE', 'SERVICE_INTERROGATE', 'SERVICE_USER_DEFINED_CONTROL', 'DELETE', 'READ_CONTROL', 'WRITE_DAC', 'WRITE_OWNER', 'SERVICE_ALL_ACCESS', 'ACCESS_SYSTEM_SECURITY')]
        [Alias('dwDesiredAccess')]
        [string[]]
        $DesiredAccess = 'SERVICE_ALL_ACCESS'
    )

    # Calculate Desired Access Value
    $dwDesiredAccess = 0
    
    foreach($val in $DesiredAccess)
    {
        $dwDesiredAccess = $dwDesiredAccess -bor $SERVICE_ACCESS::$val
    }

    $Handle = $Advapi32::OpenServiceW($Handle, $Name, $dwDesiredAccess);$LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    # if we get a non-zero handle back, everything was successful
    if ($Handle -ne 0) {
        $Handle
    }
    else {
        throw "[OpenServiceW] OpenServiceW() Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}