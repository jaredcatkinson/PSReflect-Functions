function DuplicateToken
{
    <#
    .SYNOPSIS

    The DuplicateToken function creates a new access token that duplicates one already in existence.

    .DESCRIPTION

    The DuplicateToken function creates an impersonation token, which you can use in functions such as SetThreadToken and ImpersonateLoggedOnUser. The token created by DuplicateToken cannot be used in the CreateProcessAsUser function, which requires a primary token. To create a token that you can pass to CreateProcessAsUser, use the DuplicateTokenEx function.

    .PARAMETER TokenHandle

    A handle to an access token opened with TOKEN_DUPLICATE access.

    .PARAMETER ImpersonationLevel

    Specifies a SECURITY_IMPERSONATION_LEVEL enumerated type that supplies the impersonation level of the new token. The Default is SecurityImpersonation.

    .NOTES
    
    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, SECURITY_IMPERSONATION_LEVEL (Enumeration)
    Optional Dependencies: None

    (func advapi32 DuplicateToken ([bool]) @(
        [IntPtr]                 #_In_  HANDLE                       ExistingTokenHandle,
        [UInt32]                 #_In_  SECURITY_IMPERSONATION_LEVEL ImpersonationLevel,
        [IntPtr].MakeByRefType() #_Out_ PHANDLE                      DuplicateTokenHandle
    ) -EntryPoint DuplicateToken -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa446616(v=vs.85).aspx

    .EXAMPLE

    #>

    [OutputType([IntPtr])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle,

        [Parameter()]
        [ValidateSet('None','SecurityAnonymous','SecurityIdentification','SecurityImpersonation','SecurityDelegation')]
        [string]
        $ImpersonationLevel = 'SecurityImpersonation'
    )

    $DuplicateTokenHandle = [IntPtr]::Zero

    $success = $Advapi32::DuplicateToken($TokenHandle, $SECURITY_IMPERSONATION_LEVEL::$ImpersonationLevel, [ref]$DuplicateTokenHandle); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    
    if(-not $success)
    {
        Write-Debug "DuplicateToken Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $DuplicateTokenHandle
}