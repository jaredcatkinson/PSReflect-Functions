function LsaLookupAuthenticationPackage
{
    <#
    .SYNOPSIS

    The LsaLookupAuthenticationPackage function obtains the unique identifier of an authentication package.

    .DESCRIPTION

    The authentication package identifier is used in calls to authentication functions such as LsaLogonUser and LsaCallAuthenticationPackage.

    .PARAMETER LsaHandle

    Handle obtained from a previous call to LsaRegisterLogonProcess or LsaConnectUntrusted.

    .PARAMETER PackageName

    Specifies the name of the authentication package. Supported packages are 'MSV1_0_PACKAGE_NAME', 'MICROSOFT_KERBEROS_NAME_A', 'NEGOSSP_NAME_A', and 'NTLMSP_NAME_A'.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Function Dependencies: LsaNtStatusToWinError, LSA_STRING (Struct)
    Optional Dependencies: None

    (func secur32 LsaLookupAuthenticationPackage ([UInt32]) @(
        [IntPtr],                           #_In_  HANDLE      LsaHandle,
        $LSA_UNICODE_STRING.MakeByRefType() #_In_  PLSA_STRING PackageName,
        [UInt64].MakeByRefType()            #_Out_ PULONG      AuthenticationPackage
    ) -EntryPoint LsaLookupAuthenticationPackage)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa378297(v=vs.85).aspx

    .EXAMPLE

    $hLsa = LsaConnectUntrusted

    LsaLookupAuthenticationPackage -LsaHandle $hLsa -PackageName MICROSOFT_KERBEROS_NAME_A
    2
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $LsaHandle,

        [Parameter(Mandatory = $true)]
        [ValidateSet('MSV1_0_PACKAGE_NAME', 'MICROSOFT_KERBEROS_NAME_A', 'NEGOSSP_NAME_A', 'NTLMSP_NAME_A')]
        [string]
        $PackageName
    )

    switch($PackageName)
    {
        MSV1_0_PACKAGE_NAME {$authPackageName = 'NTLM'; break}
        MICROSOFT_KERBEROS_NAME_A {$authPackageName = 'Kerberos'; break}
        NEGOSSP_NAME_A {$authPackageName = 'Negotiate'; break}
        NTLMSP_NAME_A {$authPackageName = 'NTLM'; break}
    }

    $authPackageArray = [System.Text.Encoding]::ASCII.GetBytes($authPackageName)
    [int]$size = $authPackageArray.Length
    [IntPtr]$pnt = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($size) 
    [System.Runtime.InteropServices.Marshal]::Copy($authPackageArray, 0, $pnt, $authPackageArray.Length)
    
    $lsaString = [Activator]::CreateInstance($LSA_STRING)
    $lsaString.Length = [UInt16]$authPackageArray.Length
    $lsaString.MaximumLength = [UInt16]$authPackageArray.Length
    $lsaString.Buffer = $pnt
    
    $AuthenticationPackage = [UInt64]0

    $SUCCESS = $Secur32::LsaLookupAuthenticationPackage($LsaHandle, [ref]$lsaString, [ref]$AuthenticationPackage)
    
    if($SUCCESS -ne 0)
    {
        $WinErrorCode = LsaNtStatusToWinError -NtStatus $success
        $LastError = [ComponentModel.Win32Exception]$WinErrorCode
        throw "LsaLookupAuthenticationPackage Error: $($LastError.Message)"
    }

    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($pnt)

    Write-Output $AuthenticationPackage
}