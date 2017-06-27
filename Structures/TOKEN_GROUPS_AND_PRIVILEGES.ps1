<#
.SYNOPSIS

The TOKEN_GROUPS_AND_PRIVILEGES structure contains information about the group security identifiers (SIDs) and privileges in an access token.

.PARAMETER SidCount

Number of SIDs in the access token.

.PARAMETER SidLength

Length, in bytes, required to hold all of the user SIDs and the account SID for the group.

.PARAMETER Sids

A pointer to an array of SID_AND_ATTRIBUTES structures that contain a set of SIDs and corresponding attributes.

.PARAMETER RestrictedSidCount

Number of restricted SIDs.

.PARAMETER RestrictedSidLength

Length, in bytes, required to hold all of the restricted SIDs.

.PARAMETER RestrictedSids

A pointer to an array of SID_AND_ATTRIBUTES structures that contain a set of restricted SIDs and corresponding attributes.

.PARAMETER PrivilegeCount

Number of privileges.

.PARAMETER PrivilegeLength

Length, in bytes, needed to hold the privilege array.

.PARAMETER Privileges

Array of privileges.

.PARAMETER AuthenticationId

Locally unique identifier (LUID) of the authenticator of the token.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, SID_AND_ATTRIBUTES (Structure)
Optional Dependencies: None

typedef struct _TOKEN_GROUPS_AND_PRIVILEGES {
  DWORD                SidCount;
  DWORD                SidLength;
  PSID_AND_ATTRIBUTES  Sids;
  DWORD                RestrictedSidCount;
  DWORD                RestrictedSidLength;
  PSID_AND_ATTRIBUTES  RestrictedSids;
  DWORD                PrivilegeCount;
  DWORD                PrivilegeLength;
  PLUID_AND_ATTRIBUTES Privileges;
  LUID                 AuthenticationId;
} TOKEN_GROUPS_AND_PRIVILEGES, *PTOKEN_GROUPS_AND_PRIVILEGES;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa379625(v=vs.85).aspx
#>

$TOKEN_GROUPS_AND_PRIVILEGES = struct $Module TOKEN_GROUPS_AND_PRIVILEGES @{
    SidCount            = field 0 UInt32
    SidLength           = field 1 UInt32
    Sids                = field 2 IntPtr
    RestrictedSidCount  = field 3 UInt32
    RestrictedSidLength = field 4 UInt32
    RestrictedSids      = field 5 IntPtr
    PrivilegeCount      = field 6 UInt32
    PrivilegeLength     = field 7 UInt32
    Privileges          = field 8 IntPtr
    AuthenticationId    = field 9 $LUID
}