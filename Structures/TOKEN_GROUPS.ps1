<#
.SYNOPSIS

The TOKEN_GROUPS structure contains information about the group security identifiers (SIDs) in an access token.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: SID_AND_ATTRIBUTES (Struct)
Optional Dependencies: None

typedef struct _TOKEN_GROUPS {
  DWORD              GroupCount;
  SID_AND_ATTRIBUTES Groups[ANYSIZE_ARRAY];
} TOKEN_GROUPS, *PTOKEN_GROUPS;
#>

$TOKEN_GROUPS = struct $Mod TOKEN_GROUPS @{
    GroupCount = field 0 UInt32
    Groups = field 1 $SID_AND_ATTRIBUTES.MakeArrayType() -MarshalAs 
}