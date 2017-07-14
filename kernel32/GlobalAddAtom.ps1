function GlobalAddAtom
{
    <#
    .SYNOPSIS

    Adds a character string to the global atom table and returns a unique value (an atom) identifying the string.

    .DESCRIPTION

    If the string already exists in the global atom table, the atom for the existing string is returned and the atom's reference count is incremented.

    The string associated with the atom is not deleted from memory until its reference count is zero. For more information, see the GlobalDeleteAtom function.

    Global atoms are not deleted automatically when the application terminates. For every call to the GlobalAddAtom function, there must be a corresponding call to the GlobalDeleteAtom function.

    If the lpString parameter has the form "#1234", GlobalAddAtom returns an integer atom whose value is the 16-bit representation of the decimal number specified in the string (0x04D2, in this example). If the decimal value specified is 0x0000 or is greater than or equal to 0xC000, the return value is zero, indicating an error. If lpString was created by the MAKEINTATOM macro, the low-order word must be in the range 0x0001 through 0xBFFF. If the low-order word is not in this range, the function fails.

    If lpString has any other form, GlobalAddAtom returns a string atom.

    .PARAMETER AtomName

    The string to be added. The string can have a maximum size of 255 bytes. Strings that differ only in case are considered identical. The case of the first string of this name added to the table is preserved and returned by the GlobalGetAtomName function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 GlobalAddAtom ([UInt32]) @(
        [IntPtr] #_In_ LPCTSTR lpString
    ) -EntryPoint GlobalAddAtom -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms649060(v=vs.85).aspx

    .EXAMPLE
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $AtomName
    )

    $lpString = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni($AtomName)

    $SUCCESS = $kernel32::GlobalAddAtom($lpString); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($SUCCESS -eq 0)
    {
        throw "[GlobalAddAtom]: Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $SUCCESS
}