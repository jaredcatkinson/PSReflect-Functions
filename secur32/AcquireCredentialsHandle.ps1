function AcquireCredentialsHandle
{
    <#
    .SYNOPSIS

    The AcquireCredentialsHandle (General) function acquires a handle to preexisting credentials of a security principal. This handle is required by the InitializeSecurityContext (General) and AcceptSecurityContext (General) functions. These can be either preexisting credentials, which are established through a system logon that is not described here, or the caller can provide alternative credentials.

    .DESCRIPTION

    The AcquireCredentialsHandle (General) function returns a handle to the credentials of a principal, such as a user or client, as used by a specific security package. This can be the handle to preexisting credentials, or the function can create a new set of credentials and return it. This handle can be used in subsequent calls to the AcceptSecurityContext (General) and InitializeSecurityContext (General) functions.

    In general, AcquireCredentialsHandle (General) does not allow a process to obtain a handle to the credentials of other users logged on to the same computer. However, a caller with SE_TCB_NAME privilege has the option of specifying the logon identifier (LUID) of any existing logon session token to get a handle to that session's credentials. Typically, this is used by kernel-mode modules that must act on behalf of a logged-on user.

    A package might call the function in pGetKeyFn provided by the RPC run-time transport. If the transport does not support the notion of callback to retrieve credentials, this parameter must be NULL.

    For kernel mode callers, the following differences must be noted:

    The two string parameters must be Unicode strings.
    The buffer values must be allocated in process virtual memory, not from the pool.
    When you have finished using the returned credentials, free the memory used by the credentials by calling the FreeCredentialsHandle function.

    .PARAMETER Package

    Specifies the name of the security package with which these credentials will be used. This is a security package name returned in the Name member of a SecPkgInfo structure returned by the EnumerateSecurityPackages function. After a context is established, QueryContextAttributes (General) can be called with ulAttribute set to SECPKG_ATTR_PACKAGE_INFO to return information on the security package in use.

    When using the Digest SSP, set this parameter to WDIGEST_SP_NAME.

    When using the Schannel SSP, set this parameter to UNISP_NAME.

    .PARAMETER CredentialUse

    A flag that indicates how these credentials will be used. This parameter can be one of the following values.

    .PARAMETER LogonId

    The Id of the Logon Session to query information from.
    
    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: LUID (Structure), SECURITY_HANDLE (Structure), SECURITY_INTEGER (Structure), SECPKG_CRED (Enumeration)
    Optional Dependencies: None

    (func secur32 AcquireCredentialsHandle ([UInt32]) @(
        [string],                          #_In_  SEC_CHAR       *pszPrincipal
        [string],                          #_In_  SEC_CHAR       *pszPackage
        [UInt32],                          #_In_  ULONG          fCredentialUse
        [IntPtr],                          #_In_  PLUID          pvLogonID
        [IntPtr],                          #_In_  PVOID          pAuthData
        [UInt32],                          #_In_  SEC_GET_KEY_FN pGetKeyFn
        [IntPtr],                          #_In_  PVOID          pvGetKeyArgument
        $SECURITY_HANDLE.MakeByRefType(),  #_Out_ PCredHandle    phCredential
        $SECURITY_INTEGER.MakeByRefType()  #_Out_ PTimeStamp     ptsExpiry
    ) -EntryPoint AcquireCredentialsHandle)

    .LINK
    
    https://msdn.microsoft.com/en-us/library/windows/desktop/aa374712(v=vs.85).aspx
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Package,

        [Parameter(Mandatory = $true)]
        [ValidateSet("AUTOLOGON_RESTRICTED","BOTH","INBOUND", "OUTBOUND", "PROCESS_POLICY_ONLY")]
        [string]
        $CredentialUse,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $LogonId
    )

    $LogonLuid = [Activator]::CreateInstance($LUID1)
    $LogonLuid.HighPart = 0
    $LogonLuid.LowPart = $LogonId
    $LuidPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($LUID1::GetSize())
    [System.Runtime.InteropServices.Marshal]::StructureToPtr($LogonLuid, $LuidPtr, $true)

    $CredentialHandle = [Activator]::CreateInstance($SECURITY_HANDLE)
    $Expiry = [Activator]::CreateInstance($SECURITY_INTEGER)

    $SUCCESS = $Secur32::AcquireCredentialsHandle($null, $Package, $SECPKG_CRED::$CredentialUse, $LuidPtr, [IntPtr]::Zero, 0, [IntPtr]::Zero, [ref]$CredentialHandle, [ref]$Expiry)

    if($SUCCESS -ne 0)
    {
        $WinErrorCode = LsaNtStatusToWinError -NtStatus $SUCCESS
        $LastError = [ComponentModel.Win32Exception]$WinErrorCode
        throw "AcquireCredentialsHandle Error: $($LastError)"
    }

    $CredentialHandle
}