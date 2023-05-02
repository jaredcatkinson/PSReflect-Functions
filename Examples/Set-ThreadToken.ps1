 function Set-ThreadToken
{
    <#
    .SYNOPSIS

    Impersonate the access token associated with the specified process identifier.

    .DESCRIPTION

    .PARAMETER ProcessId
    
    The identifier of the local process to be impersonated.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: 
    Required Dependencies: OpenProcess, OpenProcessToken, DuplicateToken, SetThreadToken, CloseHandle
    Optional Dependencies: None

    .EXAMPLE

    Get-System
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [UInt32]
        $ProcessId
    )

    $hProcess = OpenProcess -ProcessId $ProcessId -DesiredAccess PROCESS_QUERY_LIMITED_INFORMATION
    $hToken = OpenProcessToken -ProcessHandle $hProcess -DesiredAccess TOKEN_DUPLICATE
    $hDupToken = DuplicateToken -TokenHandle $hToken
    SetThreadToken -Token $hDupToken
    
    CloseHandle -Handle $hDupToken
    CloseHandle -Handle $hToken
    CloseHandle -Handle $hProcess

    if(-not [System.Security.Principal.WindowsIdentity]::GetCurrent().IsSystem)
    {
        throw "Unable to Impersonate System Token"
    }
}
