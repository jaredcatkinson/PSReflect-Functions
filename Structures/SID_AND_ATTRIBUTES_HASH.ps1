<#
.SYNOPSIS

The SID_AND_ATTRIBUTES_HASH structure specifies a hash values for the specified array of security identifiers (SIDs).

.PARAMETER SidCount

The number of SIDs pointed to by the SidAttr parameter.

.PARAMETER SidAttr

A pointer to an array of SID_AND_ATTRIBUTES structures that represent SIDs and their attributes.

.PARAMETER Hash

An array of pointers to hash values. These values correspond to the SID_AND_ATTRIBUTES structures pointed to by the SidAttr parameter.

The SID_HASH_ENTRY data type is defined in Winnt.h as a ULONG_PTR.

The SID_HASH_SIZE array dimension is defined in Winnt.h as 32.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, SID_AND_ATTRIBUTES (Structure)
Optional Dependencies: None

typedef struct _SID_AND_ATTRIBUTES_HASH {
  DWORD               SidCount;
  PSID_AND_ATTRIBUTES SidAttr;
  SID_HASH_ENTRY      Hash[SID_HASH_SIZE];
} SID_AND_ATTRIBUTES_HASH, *PSID_AND_ATTRIBUTES_HASH;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/bb394725(v=vs.85).aspx
#>

$SID_AND_ATTRIBUTES_HASH = struct $Module SID_AND_ATTRIBUTES_HASH @{
    SidCount = field 0 UInt32
    SidAttr  = field 1 IntPtr
    Hash     = field 2 UIntPtr[] -MarshalAs @('ByValArray', 32)
}