function Get-SecurityPackage
{
    <#
    .SYNOPSIS

    Enumerates list of loaded Security Support Providers (SSP) 

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    .LINK

    https://technet.microsoft.com/en-us/library/dn169026(v=ws.10).aspx

    .EXAMPLE

    PS > Get-SecurityPackage

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

    $obj = EnumerateSecurityPackages

    Write-Output $obj
}