function EnumerateSecurityPackages
{
    <#
    .SYNOPSIS

    The EnumerateSecurityPackages function returns an array of SecPkgInfo structures that provide information about the security packages available to the client.

    .DESCRIPTION

    The caller can use the Name member of a SecPkgInfo structure to specify a security package in a call to the AcquireCredentialsHandle (General) function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: FreeContextBuffer (function), SecPkgInfo (Structure), SECPKG_FLAG (Enumeration)
    Optional Dependencies: None

    (func secur32 EnumerateSecurityPackages ([UInt32]) @(
        [UInt32].MakeByRefType(), #_In_ PULONG      pcPackages
        [IntPtr].MakeByRefType()  #_In_ PSecPkgInfo *ppPackageInfo
    ) -EntryPoint EnumerateSecurityPackages)

    .LINK
    
    https://msdn.microsoft.com/en-us/library/windows/desktop/aa375397(v=vs.85).aspx

    .EXAMPLE

    PS > EnumerateSecurityPackages

    Name         : Negotiate
    Comment      : Microsoft Package Negotiator
    Capabilities : INTEGRITY, PRIVACY, CONNECTION, MULTI_REQUIRED, EXTENDED_ERROR, 
                   IMPERSONATION, ACCEPT_WIN32_NAME, NEGOTIABLE, GSS_COMPATIBLE, LOGON, 
                   RESTRICTED_TOKENS, APPCONTAINER_CHECKS
    Version      : 1
    RpcId        : 9
    MaxToken     : 65791

    Name         : NegoExtender
    Comment      : NegoExtender Security Package
    Capabilities : INTEGRITY, PRIVACY, CONNECTION, IMPERSONATION, NEGOTIABLE, GSS_COMPATIBLE, 
                   LOGON, MUTUAL_AUTH, NEGO_EXTENDER, APPCONTAINER_CHECKS
    Version      : 1
    RpcId        : 30
    MaxToken     : 12000

    Name         : Kerberos
    Comment      : Microsoft Kerberos V1.0
    Capabilities : INTEGRITY, PRIVACY, TOKEN_ONLY, DATAGRAM, CONNECTION, MULTI_REQUIRED, 
                   EXTENDED_ERROR, IMPERSONATION, ACCEPT_WIN32_NAME, NEGOTIABLE, 
                   GSS_COMPATIBLE, LOGON, MUTUAL_AUTH, DELEGATION, READONLY_WITH_CHECKSUM, 
                   RESTRICTED_TOKENS, APPCONTAINER_CHECKS
    Version      : 1
    RpcId        : 16
    MaxToken     : 65535

    Name         : NTLM
    Comment      : NTLM Security Package
    Capabilities : INTEGRITY, PRIVACY, TOKEN_ONLY, CONNECTION, MULTI_REQUIRED, IMPERSONATION, 
                   ACCEPT_WIN32_NAME, NEGOTIABLE, LOGON, RESTRICTED_TOKENS, APPCONTAINER_CHECKS
    Version      : 1
    RpcId        : 10
    MaxToken     : 2888

    Name         : TSSSP
    Comment      : TS Service Security Package
    Capabilities : CONNECTION, MULTI_REQUIRED, ACCEPT_WIN32_NAME, MUTUAL_AUTH, 
                   APPCONTAINER_CHECKS
    Version      : 1
    RpcId        : 22
    MaxToken     : 13000

    Name         : pku2u
    Comment      : PKU2U Security Package
    Capabilities : INTEGRITY, PRIVACY, CONNECTION, IMPERSONATION, GSS_COMPATIBLE, MUTUAL_AUTH, 
                   NEGOTIABLE2, APPCONTAINER_CHECKS
    Version      : 1
    RpcId        : 31
    MaxToken     : 12000

    Name         : CloudAP
    Comment      : Cloud AP Security Package
    Capabilities : LOGON, NEGOTIABLE2
    Version      : 1
    RpcId        : 36
    MaxToken     : 0

    Name         : WDigest
    Comment      : Digest Authentication for Windows
    Capabilities : TOKEN_ONLY, IMPERSONATION, ACCEPT_WIN32_NAME, APPCONTAINER_CHECKS
    Version      : 1
    RpcId        : 21
    MaxToken     : 4096

    Name         : Schannel
    Comment      : Schannel Security Package
    Capabilities : INTEGRITY, PRIVACY, CONNECTION, MULTI_REQUIRED, EXTENDED_ERROR, 
                   IMPERSONATION, ACCEPT_WIN32_NAME, STREAM, MUTUAL_AUTH, 
                   APPCONTAINER_PASSTHROUGH
    Version      : 1
    RpcId        : 14
    MaxToken     : 24576

    Name         : Microsoft Unified Security Protocol Provider
    Comment      : Schannel Security Package
    Capabilities : INTEGRITY, PRIVACY, CONNECTION, MULTI_REQUIRED, EXTENDED_ERROR, 
                   IMPERSONATION, ACCEPT_WIN32_NAME, STREAM, MUTUAL_AUTH, 
                   APPCONTAINER_PASSTHROUGH
    Version      : 1
    RpcId        : 14
    MaxToken     : 24576

    Name         : CREDSSP
    Comment      : Microsoft CredSSP Security Provider
    Capabilities : INTEGRITY, PRIVACY, CONNECTION, MULTI_REQUIRED, IMPERSONATION, 
                   ACCEPT_WIN32_NAME, STREAM, MUTUAL_AUTH, APPCONTAINER_CHECKS
    Version      : 1
    RpcId        : 65535
    MaxToken     : 90567
    #>

    $PackageCount = 0
    $PackageInfo = [IntPtr]::Zero

    $SUCCESS = $Secur32::EnumerateSecurityPackages([ref]$PackageCount, [ref]$PackageInfo)

    if($SUCCESS -ne 0)
    {
        throw "EnumerateSecurityPackages Error: $($SUCCESS)"
    }

    for($i = 0; $i -lt $PackageCount; $i++)
    {
        $PackagePtr = [IntPtr]($PackageInfo.ToInt64() + ($SecPkgInfo::GetSize() * $i))

        $Package = $PackagePtr -as $SecPkgInfo
        
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name Name -Value ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Package.Name))
        $obj | Add-Member -MemberType NoteProperty -Name Comment -Value ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Package.Comment))
        $obj | Add-Member -MemberType NoteProperty -Name Capabilities -Value $Package.Capabilities
        $obj | Add-Member -MemberType NoteProperty -Name Version -Value $Package.Version
        $obj | Add-Member -MemberType NoteProperty -Name RpcId -Value $Package.RPCID
        $obj | Add-Member -MemberType NoteProperty -Name MaxToken -Value $Package.MaxToken

        Write-Output $obj
    }

    FreeContextBuffer -Buffer $PackageInfo
}