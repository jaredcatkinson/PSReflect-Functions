function StartServiceW
{
    <#
    .SYNOPSIS

    Starts an existing service.

    .DESCRIPTION

    Starts a service using the StartServivceW Win32 API call

    .PARAMETER Handle

    A handle to the service. This handle is returned by the OpenService or CreateService function, 
    and it must have the SERVICE_START access right. It can be closed by calling the CloseServiceHandle function. 
    Required.

    To use StartServiceW, no privileges are required aside from SERVICE_START.

    .PARAMETER NumServiceArgs
 
    The number of strings in the lpServiceArgVectors array. If lpServiceArgVectors is NULL, this parameter can be zero.

    .PARAMETER ServiceArgVectors

    The null-terminated strings to be passed to the ServiceMain function for the service as arguments.
    If there are no arguments, this parameter can be NULL. Otherwise, the first argument (lpServiceArgVectors[0])
    is the name of the service, followed by any additional arguments (lpServiceArgVectors[1] through 
    lpServiceArgVectors[dwNumServiceArgs-1]).

    Driver services do not receive these arguments.

    .NOTES

    Author: Andrew Chiles (@andrewchiles)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect, SERVICE_ACCESS (Start)
    Optional Dependencies: None

    (func advapi32 StartServiceW ([bool]) @(
        [IntPtr], # SC_HANDLE  hService
        [UInt32], # DWORD      dwNumServiceArgs
        [String]  # LPCWSTR    lpServiceArgVectors
    ) -EntryPoint StartServiceW -SetLastError)

    .LINK

    https://docs.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-startservicew

    .EXAMPLE

    StartServiceW -Handle $hService
    True

    #>
    
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('hService')]
        [IntPtr]
        $Handle,

        [Parameter(Mandatory = $false)]
        [Alias('dwNumServiceArgs')]
        [UInt32]
        $NumServiceArgs = 0,

        [Parameter()]
        [Alias('lpServiceArgVectors')]
        [String]
        $ServiceArgs = ""
    )

    $Result = $Advapi32::StartServiceW($Handle, $NumServiceArgs, $ServiceArgs);$LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    # if we get "0" back, everything was successful
    if ($Result) {
        $Result
    }
    else {
        throw "[StartServiceW] StartServiceW() Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
        $null
    }
}