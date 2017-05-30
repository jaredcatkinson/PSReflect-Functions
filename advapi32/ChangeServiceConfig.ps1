function ChangeServiceConfig {
<#
.SYNOPSIS

Modifies a specified service's configuration.

Author: Will Schroeder (@harmj0y), Matthew Graeber (@mattifestation)  
License: BSD 3-Clause  
Required Dependencies: PSReflect  

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

(func advapi32 ChangeServiceConfig ([Bool]) @(
    [IntPtr],       # _In_      SC_HANDLE hService
    [UInt32],       # _In_      DWORD     dwServiceType
    [UInt32],       # _In_      DWORD     dwStartType
    [UInt32],       # _In_      DWORD     dwErrorControl
    [String],       # _In_opt_  LPCTSTR   lpBinaryPathName
    [String],       # _In_opt_  LPCTSTR   lpLoadOrderGroup
    [IntPtr],       # _Out_opt_ LPDWORD   lpdwTagId
    [String],       # _In_opt_  LPCTSTR   lpDependencies
    [String],       # _In_opt_  LPCTSTR   lpServiceStartName
    [String],       # _In_opt_  LPCTSTR   lpPassword
    [String]        # _In_opt_  LPCTSTR   lpDisplayName
) -SetLastError -Charset Unicode)

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/ms681987(v=vs.85).aspx

.EXAMPLE

#>
    
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [OutputType('System.Boolean')]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('ServiceName', 'Service')]
        [String[]]
        [ValidateNotNullOrEmpty()]
        $Name,

        [ValidateSet('FILE_SYSTEM_DRIVER', 'KERNEL_DRIVER', 'WIN32_OWN_PROCESS', 'WIN32_SHARE_PROCESS', 'INTERACTIVE_PROCESS', 'NO_CHANGE')]
        [String]
        $ServiceType = 'NO_CHANGE',

        [ValidateSet('AUTO_START', 'BOOT_START', 'DEMAND_START', 'DISABLED', 'SYSTEM_START', 'NO_CHANGE')]
        [String]
        $StartType = 'NO_CHANGE',

        [ValidateSet('ERROR_CRITICAL', 'ERROR_IGNORE', 'ERROR_NORMAL', 'ERROR_SEVERE', 'NO_CHANGE')]
        [String]
        $ErrorControl = 'NO_CHANGE',

        [Alias('BinaryPath', 'binPath', 'path')]
        [String]
        $BinaryPathName,

        # $LoadOrderGroup,

        # $TagId,

        # $Dependencies,

        [Alias('StartName')]
        [String]
        $ServiceStartName = '',

        [String]
        $Password = '',

        [String]
        $DisplayName = ''
    )

    BEGIN {
        filter Local:Get-ServiceConfigControlHandle {
            [OutputType([IntPtr])]
            Param(
                [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
                [ServiceProcess.ServiceController]
                [ValidateNotNullOrEmpty()]
                $TargetService
            )
            $GetServiceHandle = [ServiceProcess.ServiceController].GetMethod('GetServiceHandle', [Reflection.BindingFlags] 'Instance, NonPublic')
            $ConfigControl = 0x00000002
            $RawHandle = $GetServiceHandle.Invoke($TargetService, @($ConfigControl))
            $RawHandle
        }

        $ServiceTypeVal = Switch ($ServiceType) {
            'FILE_SYSTEM_DRIVER'    { 0x00000002 }
            'KERNEL_DRIVER'         { 0x00000001 }
            'WIN32_OWN_PROCESS'     { 0x00000010 }
            'WIN32_SHARE_PROCESS'   { 0x00000020 }
            'INTERACTIVE_PROCESS'   { 0x00000100 }
            'NO_CHANGE'             { [UInt32]::MaxValue }
        }

        $StartTypeVal = Switch ($StartType) {
            'AUTO_START'    { 0x00000002 }
            'BOOT_START'    { 0x00000000 }
            'DEMAND_START'  { 0x00000003 }
            'DISABLED'      { 0x00000004 }
            'SYSTEM_START'  { 0x00000001 }
            'NO_CHANGE'     { [UInt32]::MaxValue }
        }

        # [ValidateSet('ERROR_CRITICAL', 'ERROR_IGNORE', 'ERROR_NORMAL', 'ERROR_SEVERE', 'NO_CHANGE')]
        $ErrorControlVal = Switch ($ErrorControl) {
            'ERROR_CRITICAL'    { 0x00000003 }
            'ERROR_IGNORE'      { 0x00000000 }
            'ERROR_NORMAL'      { 0x00000001 }
            'ERROR_SEVERE'      { 0x00000002 }
            'NO_CHANGE'         { [UInt32]::MaxValue }
        }
    }

    PROCESS {

        ForEach($IndividualService in $Name) {

            $TargetService = Get-Service -Name $IndividualService -ErrorAction Stop
            try {
                $ServiceHandle = Get-ServiceConfigControlHandle -TargetService $TargetService
            }
            catch {
                $ServiceHandle = $Null
                Write-Warning "[ChangeServiceConfig] Error opening up the service handle with read control for $IndividualService : $_"
            }

            if ($ServiceHandle -and ($ServiceHandle -ne [IntPtr]::Zero)) {

                $Result = $Advapi32::ChangeServiceConfig($ServiceHandle, $ServiceTypeVal, $StartTypeVal, $ErrorControlVal, $BinaryPathName, '', [IntPtr]::Zero, '', $lpServiceStartName, $lpPassword, $lpDisplayName);$LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

                if ($Result -ne 0) {
                    Write-Verbose "Successfully modified '$IndividualService'"
                    $True
                }
                else {
                    Write-Error ([ComponentModel.Win32Exception] $LastError)
                    $Null
                }

                $Null = $Advapi32::CloseServiceHandle($ServiceHandle)
            }
        }
    }
}


$FunctionDefinitions = @(
    (func advapi32 ChangeServiceConfig ([Bool]) @([IntPtr], [UInt32], [UInt32], [UInt32], [String], [String], [IntPtr], [String], [String], [String], [String]) -SetLastError -Charset Unicode),
    (func advapi32 CloseServiceHandle ([Bool]) @([IntPtr]) -SetLastError)
)

$Module = New-InMemoryModule -ModuleName Win32
$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Advapi32 = $Types['advapi32']
