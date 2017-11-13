<#
struct _ATOM_TABLE_INFORMATION, 2 elements, 0x8 bytes
   +0x000 NumberOfAtoms    : Uint4B
   +0x004 Atoms            : [1] Uint2B
#>

$ATOM_TABLE_INFORMATION = struct $Module ATOM_TABLE_INFORMATION @{
    NumberOfAtoms = field 0 UInt32
    Atoms         = field 1 IntPtr
}