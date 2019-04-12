function QueryCredentialsAttributes
{
    <#
    .SYNOPSIS

    Retrieves the attributes of a credential, such as the name associated with the credential. The information is valid for any security context created with the specified credential.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func secur32 QueryCredentialsAttributes ([UInt32]) @(
        $SECURITY_HANDLE.MakeByRefType(), #PCredHandle phCredential
        [UInt32],         #unsigned long ulAttribute
        [IntPtr].MakeByRefType()          #void          *pBuffer
    ) -EntryPoint QueryCredentialsAttributes)

    .LINK
    
    https://docs.microsoft.com/en-us/windows/desktop/api/sspi/nf-sspi-freecredentialshandle
    #>

    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.Object]
        $CredentialHandle
    )

    $buffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(512)

    $SUCCESS = $Secur32::QueryCredentialsAttributes($CredentialHandle, 1, [ref]$buffer)

    if($SUCCESS -ne 0)
    {
        $WinErrorCode = LsaNtStatusToWinError -NtStatus $SUCCESS
        $LastError = [ComponentModel.Win32Exception]$WinErrorCode
        $LastError
        throw "QueryCredentialsAttributes Error: $($LastError)"
    }

    $ntlmUser = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($buffer)
    $ntlmUser
}