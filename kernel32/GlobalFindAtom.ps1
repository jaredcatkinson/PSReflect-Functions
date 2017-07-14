function GlobalFindAtom
{
    <#
    .SYNOPSIS

    Searches the global atom table for the specified character string and retrieves the global atom associated with that string.

    .DESCRIPTION

    Even though the system preserves the case of a string in an atom table as it was originally entered, the search performed by GlobalFindAtom is not case sensitive.

    .PARAMETER AtomString
    
    The Atom string for which to search.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 GlobalFindAtom ([UInt16]) @(
        [IntPtr] #_In_ LPCTSTR lpString
    ) -EntryPoint GlobalFindAtom -SetLastError)
    
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms649062(v=vs.85).aspx

    .EXAMPLE
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $AtomString
    )
    
    $lpString = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni($AtomString)

    $SUCCESS = $kernel32::GlobalFindAtom($lpString); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($SUCCESS -eq 0)
    {
        throw "[GlobalFindAtom]: Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $SUCCESS
}