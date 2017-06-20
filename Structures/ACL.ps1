<#
.SYNOPSIS

The ACL structure is the header of an access control list (ACL). A complete ACL consists of an ACL structure followed by an ordered list of zero or more access control entries (ACEs).

.PARAMETER AclRevision

Specifies the revision level of the ACL. This value should be ACL_REVISION, unless the ACL contains an object-specific ACE, in which case this value must be ACL_REVISION_DS. All ACEs in an ACL must be at the same revision level.

.PARAMETER Sbz1

Specifies a zero byte of padding that aligns the AclRevision member on a 16-bit boundary.

.PARAMETER AclSize

Specifies the size, in bytes, of the ACL. This value includes both the ACL structure and all the ACEs.

.PARAMETER AceCount

Specifies the number of ACEs stored in the ACL.

.PARAMETER Sbz2

Specifies two zero-bytes of padding that align the ACL structure on a 32-bit boundary.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct _ACL {
  BYTE AclRevision;
  BYTE Sbz1;
  WORD AclSize;
  WORD AceCount;
  WORD Sbz2;
} ACL, *PACL;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa374931(v=vs.85).aspx
#>

$ACL = struct $Module ACL @{
    AclRevision = field 0 Byte
    Sbz1        = field 1 Byte
    AclSize     = field 2 UInt16
    AceCount    = field 3 UInt16
    Sbz2        = field 4 UInt16
}