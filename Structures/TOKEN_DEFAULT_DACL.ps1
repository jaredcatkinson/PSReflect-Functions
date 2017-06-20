<#
.SYNOPSIS

The TOKEN_DEFAULT_DACL structure specifies a discretionary access control list (DACL).

.PARAMETER DefaultDacl

A pointer to an ACL structure assigned by default to any objects created by the user. The user is represented by the access token.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, ACL (Structure) 
Optional Dependencies: None

typedef struct _TOKEN_DEFAULT_DACL {
  PACL DefaultDacl;
} TOKEN_DEFAULT_DACL, *PTOKEN_DEFAULT_DACL;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa379623(v=vs.85).aspx
#>

$TOKEN_DEFAULT_DACL = struct $Module TOKEN_DEFAULT_DACL @{
    DefaultDacl = field 0 $ACL
}