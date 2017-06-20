<#
.SYNOPSIS

The TOKEN_STATISTICS structure contains information about an access token. An application can retrieve this information by calling the GetTokenInformation function.

.PARAMETER TokenId

Specifies a locally unique identifier (LUID) that identifies this instance of the token object.

.PARAMETER AuthenticationId

Specifies an LUID assigned to the session this token represents. There can be many tokens representing a single logon session.

.PARAMETER ExpirationTime

Specifies the time at which this token expires. Expiration times for access tokens are not currently supported.

.PARAMETER TokenType

Specifies a TOKEN_TYPE enumeration type indicating whether the token is a primary or impersonation token.

.PARAMETER ImpersonationLevel

Specifies a SECURITY_IMPERSONATION_LEVEL enumeration type indicating the impersonation level of the token. This member is valid only if the TokenType is TokenImpersonation.

.PARAMETER DynamicCharged

Specifies the amount, in bytes, of memory allocated for storing default protection and a primary group identifier.

.PARAMETER DynamicAvailable

Specifies the portion of memory allocated for storing default protection and a primary group identifier not already in use. This value is returned as a count of free bytes.

.PARAMETER GroupCount

Specifies the number of supplemental group security identifiers (SIDs) included in the token.

.PARAMETER PrivilegeCount

Specifies the number of privileges included in the token.

.PARAMETER ModifiedId

Specifies an LUID that changes each time the token is modified. An application can use this value as a test of whether a security context has changed since it was last used.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, LUID (Structure), TOKEN_TYPE (Enumeration), SECURITY_IMPERSONATION_LEVEL (Enumeration)
Optional Dependencies: None

typedef struct _TOKEN_STATISTICS {
  LUID                         TokenId;
  LUID                         AuthenticationId;
  LARGE_INTEGER                ExpirationTime;
  TOKEN_TYPE                   TokenType;
  SECURITY_IMPERSONATION_LEVEL ImpersonationLevel;
  DWORD                        DynamicCharged;
  DWORD                        DynamicAvailable;
  DWORD                        GroupCount;
  DWORD                        PrivilegeCount;
  LUID                         ModifiedId;
} TOKEN_STATISTICS, *PTOKEN_STATISTICS;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa379632(v=vs.85).aspx
#>

$TOKEN_STATISTICS = struct $Module TOKEN_STATISTICS @{
    TokenId            = field 0 $LUID
    AuthenticationId   = field 1 $LUID
    ExpirationTime     = field 2 UInt64
    TokenType          = field 3 $TOKEN_TYPE
    ImpersonationLevel = field 4 $SECURITY_IMPERSONATION_LEVEL
    DynamicCharged     = field 5 UInt32
    DynamicAvailable   = field 6 UInt32
    GroupCount         = field 7 UInt32
    PrivilegeCount     = field 8 UInt32
    ModifiedId         = field 9 $LUID
}