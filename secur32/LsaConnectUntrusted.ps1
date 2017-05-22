function LsaConnectUntrusted
{
    <#
    .SYNOPSIS

    The LsaConnectUntrusted function establishes an untrusted connection to the LSA server.

    .DESCRIPTION

    LsaConnectUntrusted returns a handle to an untrusted connection; it does not verify any information about the caller. The handle should be closed using the LsaDeregisterLogonProcess function.
    
    If your application simply needs to query information from authentication packages, you can use the handle returned by this function in calls to LsaCallAuthenticationPackage and LsaLookupAuthenticationPackage.
    
    Applications with the SeTcbPrivilege privilege may create a trusted connection by calling LsaRegisterLogonProcess.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: LsaNtStatusToWinError
    Optional Dependencies: None

    (func secur32 LsaConnectUntrusted ([UInt32]) @(
        [IntPtr].MakeByRefType() #_Out_ PHANDLE LsaHandle
    ))

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa378265(v=vs.85).aspx

    .EXAMPLE

    $hLsa = LsaConnectUntrusted
    #>

    param
    (

    )
    
    $LsaHandle = [IntPtr]::Zero

    $SUCCESS = $Secur32::LsaConnectUntrusted([ref]$LsaHandle)

    if($SUCCESS -ne 0)
    {
        $WinErrorCode = LsaNtStatusToWinError -NtStatus $success
        $LastError = [ComponentModel.Win32Exception]$WinErrorCode
        throw "LsaConnectUntrusted Error: $($LastError.Message)"
    }

    Write-Output $LsaHandle
}