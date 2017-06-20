<#
.SYNOPSIS

The TOKEN_PRIVILEGES structure contains information about a set of privileges for an access token.

.PARAMETER PrivilegeCount

This must be set to the number of entries in the Privileges array.

.PARAMETER Privileges

Specifies an array of LUID_AND_ATTRIBUTES structures. Each structure contains the LUID and attributes of a privilege. To get the name of the privilege associated with a LUID, call the LookupPrivilegeName function, passing the address of the LUID as the value of the lpLuid parameter.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: LUID_AND_ATTRIBUTES (Struct)
Optional Dependencies: None

typedef struct _TOKEN_PRIVILEGES {
  DWORD               PrivilegeCount;
  LUID_AND_ATTRIBUTES Privileges[ANYSIZE_ARRAY];
} TOKEN_PRIVILEGES, *PTOKEN_PRIVILEGES;
#>

$TOKEN_PRIVILEGES = struct $Module TOKEN_PRIVILEGES @{
    PrivilegeCount = field 0 UInt32
    Privileges      = field 1  $LUID_AND_ATTRIBUTES.MakeArrayType() -MarshalAs @('ByValArray', 50)
}