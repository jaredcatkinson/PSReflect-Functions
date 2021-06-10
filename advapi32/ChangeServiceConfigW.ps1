function ChangeServiceConfigW
{
    <#
    .SYNOPSIS

    Modifies a specified service's configuration.

    .DESCRIPTION

    Changes the configuration parameters of a service using the ChangeServiceConfig
    Win32 API call. Reflection is first used to retrieve the handle to the specified
    service (Get-ServiceConfigControlHandle), the specified modifications are made,
    and then CloseServiceHandle() is used to close the handle

    .PARAMETER Name

    An array of one or more service names to set the binary path for. Required.

    .PARAMETER Path

    The new binary path (lpBinaryPathName) to set for the specified service. Required.

    .NOTES

    Author: Will Schroeder (@harmj0y), Matthew Graeber (@mattifestation)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func advapi32 ChangeServiceConfigW ([Bool]) @(
        [IntPtr],       # _In_      SC_HANDLE hService
        [UInt32],       # _In_      DWORD     dwServiceType
        [UInt32],       # _In_      DWORD     dwStartType
        [UInt32],       # _In_      DWORD     dwErrorControl
        [String],       # _In_opt_  LPCTSTR   lpBinaryPathName
        [String],       # _In_opt_  LPCTSTR   lpLoadOrderGroup
        [IntPtr],       # _Out_opt_ LPDWORD   lpdwTagId
        [String],       # _In_opt_  LPCTSTR   lpDependencies
        [IntPtr],       # _In_opt_  LPCTSTR   lpServiceStartName
        [IntPtr],       # _In_opt_  LPCTSTR   lpPassword
        [String]        # _In_opt_  LPCTSTR   lpDisplayName
    ) -EntryPoint ChangeServiceConfigW -SetLastError -Charset Unicode)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms681987(v=vs.85).aspx

    .EXAMPLE

    #>
    
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [OutputType('System.Boolean')]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [Alias('hService')]
        [IntPtr]
        $Handle,

        [Parameter()]
        [ValidateSet('SERVICE_KERNEL_DRIVER', 'SERVICE_FILE_SYSTEM_DRIVER', 'SERVICE_ADAPTER', 'SERVICE_RECOGNIZER_DRIVER', 'SERVICE_WIN32_OWN_PROCESS', 'SERVICE_WIN32_SHARE_PROCESS', 'SERVICE_USER_OWN_PROCESS', 'SERVICE_USER_SHARE_PROCESS', 'SERVICE_INTERACTIVE_PROCESS', 'SERVICE_NO_CHANGE')]
        [Alias('dwServiceType')]
        [String]
        $ServiceType = 'SERVICE_NO_CHANGE',

        [Parameter()]
        [ValidateSet('SERVICE_BOOT_START', 'SERVICE_SYSTEM_START', 'SERVICE_AUTO_START', 'SERVICE_DEMAND_START', 'SERVICE_DISABLED', 'SERVICE_NO_CHANGE')]
        [Alias('dwStartType')]
        [String]
        $StartType = 'SERVICE_NO_CHANGE',

        [Parameter()]
        [ValidateSet('SERVICE_ERROR_IGNORE', 'SERVICE_ERROR_NORMAL', 'SERVICE_ERROR_SEVERE', 'SERVICE_ERROR_CRITICAL', 'SERVICE_NO_CHANGE')]
        [Alias('dwErrorControl')]
        [String]
        $ErrorControl = 'SERVICE_NO_CHANGE',

        [Parameter()]
        [Alias('lpBinaryPathName')]
        [String]
        $BinaryPathName = '',

        [Parameter()]
        [Alias('lpDisplayName')]
        [String]
        $DisplayName = ''
    )

    # Calculate Service Type Value
    $dwServiceType = 0

    foreach($val in $ServiceType)
    {
        $dwServiceType = $dwServiceType -bor $SERVICE_TYPE::$val
    }

    if($PSBoundParameters.ContainsKey('BinaryPathName'))
    {
        $lpBinaryPathName = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($BinaryPathName)
    }
    else
    {
        $lpBinaryPathName = [IntPtr]::Zero
    }

    if($PSBoundParameters.ContainsKey('DisplayName'))
    {
        $lpDisplayName = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($DisplayName)
    }
    else
    {
        $lpDisplayName = [IntPtr]::Zero
    }

    $Result = $Advapi32::ChangeServiceConfigW($Handle, $dwServiceType, $SERVICE_START_TYPE::$StartType, $SERVICE_ERROR::$ErrorControl, $lpBinaryPathName, [IntPtr]::Zero, [IntPtr]::Zero, [IntPtr]::Zero, [IntPtr]::Zero, [IntPtr]::Zero, $lpDisplayName);$LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if ($Result -ne 0) 
    {
        $Result
    }
    else 
    {
        Write-Error ([ComponentModel.Win32Exception] $LastError)
        $Null
    }
}