<#
.SYNOPSIS

The TOKEN_PRIMARY_GROUP structure specifies a group security identifier (SID) for an access token.

.PARAMETER PrimaryGroup

A pointer to a SID structure representing a group that will become the primary group of any objects created by a process using this access token. The SID must be one of the group SIDs already in the token.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct _TOKEN_PRIMARY_GROUP {
  PSID PrimaryGroup;
} TOKEN_PRIMARY_GROUP, *PTOKEN_PRIMARY_GROUP;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa379629(v=vs.85).aspx
#>

$TOKEN_PRIMARY_GROUP = struct $Module TOKEN_PRIMARY_GROUP @{
    PrimaryGroup = field 0 IntPtr
}