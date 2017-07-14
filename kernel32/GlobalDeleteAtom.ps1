function GlobalDeleteAtom
{
    <#
    .SYNOPSIS

    Decrements the reference count of a global string atom. If the atom's reference count reaches zero, GlobalDeleteAtom removes the string associated with the atom from the global atom table.

    .DESCRIPTION

    A string atom's reference count specifies the number of times the string has been added to the atom table. The GlobalAddAtom function increments the reference count of a string that already exists in the global atom table each time it is called.
    
    Each call to GlobalAddAtom should have a corresponding call to GlobalDeleteAtom. Do not call GlobalDeleteAtom more times than you call GlobalAddAtom, or you may delete the atom while other clients are using it. Applications using Dynamic Data Exchange (DDE) should follow the rules on global atom management to prevent leaks and premature deletion.
    
    GlobalDeleteAtom has no effect on an integer atom (an atom whose value is in the range 0x0001 to 0xBFFF). The function always returns zero for an integer atom.

    .PARAMETER AtomIndex

    The atom index to be deleted.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 GlobalDeleteAtom ([UInt32]) @(
        [UInt16] #_In_ ATOM nAtom
    ) -EntryPoint GlobalDeleteAtom -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms649061(v=vs.85).aspx

    .EXAMPLE
    #>
    
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName = 'ByIndex')]
        [UInt16]
        $AtomIndex,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [string]
        $AtomName
    )

    if($PSCmdlet.ParameterSetName -eq 'ByName')
    {
        $AtomIndex = GlobalFindAtom -AtomString $AtomName
    }

    $SUCCESS = $kernel32::GlobalDeleteAtom($AtomIndex)
}