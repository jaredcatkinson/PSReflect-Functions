function GlobalGetAtomName
{
    <#
    .SYNOPSIS

    Retrieves a copy of the character string associated with the specified global atom.

    .DESCRIPTION

    The string returned for an integer atom (an atom whose value is in the range 0x0001 to 0xBFFF) is a null-terminated string in which the first character is a pound sign (#) and the remaining characters represent the unsigned integer atom value.

    .PARAMETER AtomIndex

    The global atom (index) associated with the character string to be retrieved.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 GlobalGetAtomName ([UInt32]) @(
        [UInt16],  #_In_  ATOM   nAtom
        [string].MakeByRefType(), #_Out_ LPTSTR lpBuffer
        [UInt16]   #_In_  int    nSize
    ) -EntryPoint GlobalGetAtomName -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms649063(v=vs.85).aspx

    .EXAMPLE

    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [UInt16]
        $AtomIndex
    )

    $AtomName = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(1024)

    $SUCCESS = $kernel32::GlobalGetAtomName($AtomIndex, $AtomName, 1024); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($SUCCESS -eq 0)
    {
        throw "[GlobalGetAtomName]: Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringUni($AtomName))
}