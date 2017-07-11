function Get-LogonSession
{
    <#

    .SYNOPSIS

    .DESCRIPTION

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: 
    Required Dependencies: None
    Optional Dependencies: None

    .LINK

    .EXAMPLE

    Get-LogonSession

    FailedAttemptCountSinceLastSuccessfulLogon : 0
    DnsDomainName                              : HUNT.LOCAL
    KickOffTime                                : 1/1/1601 1:00:00 AM
    PasswordCanChange                          : 5/20/2017 9:51:20 PM
    Upn                                        : Administrator@HUNT.LOCAL
    UserName                                   : Administrator
    Session                                    : 1
    LogoffTime                                 : 1/1/1601 1:00:00 AM
    LastFailedLogon                            : 1/1/1601 1:00:00 AM
    LogonServer                                : DC
    Sid                                        : S-1-5-21-3250051078-751264820-3215766868-500
    LogonScript                                : 
    UserFlags                                  : 49444
    ProfilePath                                : 
    PasswordMustChange                         : 6/30/2017 9:51:20 PM
    LogonId                                    : 325349
    LogonTime                                  : 5/20/2017 9:47:34 AM
    PasswordLastSet                            : 5/19/2017 9:51:20 PM
    LogonDomain                                : 
    HomeDirectory                              : 
    LogonType                                  : Interactive
    AuthenticationPackage                      : Kerberos
    LastSuccessfulLogon                        : 1/1/1601 1:00:00 AM
    HomeDirectoryDrive                         : 

    #>

    [CmdletBinding()]
    param
    (

    )

    $LogonSessions = LsaEnumerateLogonSessions
    $Sessions = LsaGetLogonSessionData -LuidPtr $LogonSessions.SessionListPointer -SessionCount $LogonSessions.SessionCount

    Write-Output $Sessions
}