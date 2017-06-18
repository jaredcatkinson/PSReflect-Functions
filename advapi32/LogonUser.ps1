function LogonUser
{
<#
.SYNOPSIS

This function will create a new user logon session on the local computer
using the passed -Credential object. The returned value is  a handle to
a token that represents the specified user

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect  

.DESCRIPTION

The LogonUser function attempts to log a user on to the local computer. The local computer
is the computer from which LogonUser was called. You cannot use LogonUser to log on to a
remote computer. You specify the user with a user name and domain and authenticate the user
with a plaintext password. If the function succeeds, you receive a handle to a token that
represents the logged-on user. You can then use this token handle to impersonate the
specified user or, in most cases, to create a process that runs in the context of the
specified user.

Note: the resulting handle will only work for user impersonation if PowerShell is set to a
single thread apartment state. Version 2 launches with multi-thread apartment state by default
(changeable with -sta), while Version 3+ launches in a single-thread apartment.

.PARAMETER Credential

A [Management.Automation.PSCredential] object with alternate credentials
to impersonate in the current thread space.

.PARAMETER LogonType

Specifies the type of logon operation to perform. One of 'BATCH', 'INTERACTIVE',
'NETWORK', 'NETWORK_CLEARTEXT', 'NEW_CREDENTIALS', or 'SERVICE'.

Default of 'NEW_CREDENTIALS', simulating a "runas /netonly" logon.

.PARAMETER LogonProvider

Specifies the logon provider. One of 'DEFAULT' (the default provider),
'WINNT50' (the negotiate logon provider, or 'WINNT40' (the NTLM logon provider).

Default of 'WINNT50', for user with "-LogonType 'NEW_CREDENTIALS'"

.NOTES

(func advapi32 LogonUser ([Bool]) @(
    [String],                   # _In_     LPTSTR  lpszUsername
    [String],                   # _In_opt_ LPTSTR  lpszDomain
    [String],                   # _In_opt_ LPTSTR  lpszPassword
    [UInt32],                   # _In_     DWORD   dwLogonType
    [UInt32],                   # _In_     DWORD   dwLogonProvider
    [IntPtr].MakeByRefType()    # _Out_    PHANDLE phToken
) -EntryPoint LogonUser -SetLastError)

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa378184(v=vs.85).aspx

.EXAMPLE

$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('TESTLAB\dfm.a', $SecPassword)
$Handle = LogonUser -Credential $Cred
#>

    [OutputType([IntPtr])]
    Param(
        [Parameter(Mandatory = $True)]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential,

        [ValidateSet('BATCH', 'INTERACTIVE', 'NETWORK', 'NETWORK_CLEARTEXT', 'NEW_CREDENTIALS', 'SERVICE')]
        [String]
        $LogonType  = 'NEW_CREDENTIALS',

        [ValidateSet('DEFAULT', 'WINNT50', 'WINNT40')]
        [String]
        $LogonProvider  = 'WINNT50'
    )

    $LogonTokenHandle = [IntPtr]::Zero
    $NetworkCredential = $Credential.GetNetworkCredential()
    $UserDomain = $NetworkCredential.Domain
    $UserName = $NetworkCredential.UserName
    Write-Warning "[LogonUser] Executing LogonUser() with user: $($UserDomain)\$($UserName)"

    $LogonTypeID = Switch ($LogonType) {
        'BATCH' { 4 }
        'INTERACTIVE' { 2 }
        'NETWORK' { 3 }
        'NETWORK_CLEARTEXT' { 8 }
        'NEW_CREDENTIALS' { 9 }
        'SERVICE' { 5 }
    }

    $LogonProviderID = Switch ($LogonType) {
        'DEFAULT' { 0 }
        'WINNT40' { 2 }
        'WINNT50' { 3 }
    }

    # LOGON32_LOGON_NEW_CREDENTIALS = 9, LOGON32_PROVIDER_WINNT50 = 3
    #   this is to simulate "runas.exe /netonly" functionality
    $Result = $Advapi32::LogonUser($UserName, $UserDomain, $NetworkCredential.Password, $LogonTypeID, $LogonProviderID, [ref]$LogonTokenHandle);$LastError = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error();

    if (-not $Result) {
        throw "[LogonUser] LogonUser() Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
    else {
        $LogonTokenHandle
    }
}