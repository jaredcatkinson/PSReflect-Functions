<#
0:018> dt -v urlmon!FILE_ALL_INFORMATION
struct _FILE_ALL_INFORMATION, 9 elements, 0x68 bytes
   +0x000 BasicInformation : struct _FILE_BASIC_INFORMATION, 5 elements, 0x28 bytes
   +0x028 StandardInformation : struct _FILE_STANDARD_INFORMATION, 5 elements, 0x18 bytes
   +0x040 InternalInformation : struct _FILE_INTERNAL_INFORMATION, 1 elements, 0x8 bytes
   +0x048 EaInformation    : struct _FILE_EA_INFORMATION, 1 elements, 0x4 bytes
   +0x04c AccessInformation : struct _FILE_ACCESS_INFORMATION, 1 elements, 0x4 bytes
   +0x050 PositionInformation : struct _FILE_POSITION_INFORMATION, 1 elements, 0x8 bytes
   +0x058 ModeInformation  : struct _FILE_MODE_INFORMATION, 1 elements, 0x4 bytes
   +0x05c AlignmentInformation : struct _FILE_ALIGNMENT_INFORMATION, 1 elements, 0x4 bytes
   +0x060 NameInformation  : struct _FILE_NAME_INFORMATION, 2 elements, 0x8 bytes
#>

$FILE_ALL_INFORMATION = struct $Module FILE_ALL_INFORMATION @{
    BasicInformation     = field 0 IntPtr
    StandardInformation  = field 1 IntPtr
    InternalInformation  = field 2 IntPtr
    EaInformation        = field 3 IntPtr
    AccessInformation    = field 4 IntPtr
    PositionInformation  = field 5 IntPtr
    ModeInformation      = field 6 IntPtr
    AlignmentInformation = field 7 IntPtr
    NameInformation      = field 8 IntPtr
}