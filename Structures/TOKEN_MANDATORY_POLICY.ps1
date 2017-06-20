<#
.SYNOPSIS

The TOKEN_MANDATORY_POLICY structure specifies the mandatory integrity policy for a token.

.PARAMETER Policy

The mandatory integrity access policy for the associated token.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct _TOKEN_MANDATORY_POLICY {
  DWORD Policy;
} TOKEN_MANDATORY_POLICY, *PTOKEN_MANDATORY_POLICY;

.LINK

The mandatory integrity access policy for the associated token.
#>

$TOKEN_MANDATORY_POLICY = struct $Module TOKEN_MANDATORY_POLICY @{
    Policy = field 0 $TOKENMANDATORYPOLICY
}