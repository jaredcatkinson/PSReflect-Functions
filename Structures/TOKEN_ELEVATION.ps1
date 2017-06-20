<#
.SYNOPSIS

The TOKEN_ELEVATION structure indicates whether a token has elevated privileges.

.PARAMETER TokenIsElevated

A nonzero value if the token has elevated privileges; otherwise, a zero value.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct _TOKEN_ELEVATION {
  DWORD TokenIsElevated;
} TOKEN_ELEVATION, *PTOKEN_ELEVATION;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/bb530717(v=vs.85).aspx
#>

$TOKEN_ELEVATION = struct $Module TOKEN_ELEVATION @{
    TokenIsElevated = field 0 UInt32
}