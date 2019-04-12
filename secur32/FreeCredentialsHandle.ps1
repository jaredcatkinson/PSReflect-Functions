function FreeCredentialsHandle
{
    <#
    .SYNOPSIS

    The FreeCredentialsHandle function notifies the security system that the credentials are no longer needed. An application calls this function to free the credential handle acquired in the call to the AcquireCredentialsHandle (General) function after calling the DeleteSecurityContext function to free any context handles associated with the credential. When all references to this credential set have been removed, the credentials themselves can be removed.

    Failure to free credentials handles will result in memory leaks.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func secur32 FreeCredentialsHandle ([UInt32]) @(
        $SECURITY_HANDLE #PCredHandle phCredential
    ) -EntryPoint FreeCredentialsHandle)

    .LINK
    
    https://docs.microsoft.com/en-us/windows/desktop/api/sspi/nf-sspi-freecredentialshandle
    #>

    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.Object]
        $CredentialHandle
    )

    $SUCCESS = $Secur32::FreeCredentialsHandle($CredentialHandle)

    if($SUCCESS -ne 0)
    {
        $WinErrorCode = LsaNtStatusToWinError -NtStatus $SUCCESS
        $LastError = [ComponentModel.Win32Exception]$WinErrorCode
        throw "FreeCredentialsHandle Error: $($LastError)"
    }
}