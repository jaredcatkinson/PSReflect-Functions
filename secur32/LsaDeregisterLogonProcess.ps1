function LsaDeregisterLogonProcess
{
    <#
    .SYNOPSIS

    The LsaDeregisterLogonProcess function deletes the caller's logon application context and closes the connection to the LSA server.

    .DESCRIPTION

    If your logon application references the connection handle after calling the LsaDeregisterLogonProcess function, unexpected behavior can result.
    
    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: LsaNtStatusToWinError
    Optional Dependencies: None

    (func secur32 LsaDeregisterLogonProcess ([UInt32]) @(
        [IntPtr] #_In_ HANDLE LsaHandle
    ) -EntryPoint LsaDeregisterLogonProcess)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa378269(v=vs.85).aspx

    .EXAMPLE

    $hLsa = LsaConnectUntrusted

    #
    # Do Somthing with the LSA Handle
    #
    
    LsaDeregisterLogonProcess -LsaHandle $hLsa
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $LsaHandle
    )

    $SUCCESS = $Secur32::LsaDeregisterLogonProcess($LsaHandle)

    if($SUCCESS -ne 0)
    {
        $WinErrorCode = LsaNtStatusToWinError -NtStatus $success
        $LastError = [ComponentModel.Win32Exception]$WinErrorCode
        throw "LsaDeregisterLogonProcess Error: $($LastError.Message)"
    }
}