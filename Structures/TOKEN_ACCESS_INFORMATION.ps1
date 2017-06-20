<#
.SYNOPSIS

The TOKEN_ACCESS_INFORMATION structure specifies all the information in a token that is necessary to perform an access check.

.PARAMETER SidHash

A pointer to a SID_AND_ATTRIBUTES_HASH structure that specifies a hash of the token's security identifier (SID).

.PARAMETER RestrictedSidHash

A pointer to a SID_AND_ATTRIBUTES_HASH structure that specifies a hash of the token's restricted SID.

.PARAMETER Privileges

A pointer to a TOKEN_PRIVILEGES structure that specifies information about the token's privileges.

.PARAMETER AuthenticationId

A LUID structure that specifies the token's identity.

.PARAMETER TokenType

A value of the TOKEN_TYPE enumeration that specifies the token's type.

.PARAMETER ImpersonationLevel

A value of the SECURITY_IMPERSONATION_LEVEL enumeration that specifies the token's impersonation level.

.PARAMETER MandatoryPolicy

A TOKEN_MANDATORY_POLICY structure that specifies the token's mandatory integrity policy.

.PARAMETER Flags

Reserved. Must be set to zero.

.PARAMETER AppContainerNumber

The app container number for the token or zero if this is not an app container token.

Windows Server 2008 R2, Windows 7, Windows Server 2008 and Windows Vista:  This member is not available.

.PARAMETER PackageSid

The app container SID or NULL if this is not an app container token.

Windows Server 2008 R2, Windows 7, Windows Server 2008 and Windows Vista:  This member is not available.

.PARAMETER CapabilitiesHash

Pointer to a SID_AND_ATTRIBUTES_HASH structure that specifies a hash of the token's capability SIDs.

Windows Server 2008 R2, Windows 7, Windows Server 2008 and Windows Vista:  This member is not available.

.PARAMETER TrustLevelSid

The protected process trust level of the token.

.PARAMETER SecurityAttributes

Reserved. Must be set to NULL.

Prior to Windows 10:  This member is not available.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, SID_AND_ATTRIBUTES_HASH (Structure), TOKEN_PRIVILEGES (Structure), LUID (Structure), TOKEN_TYPE (Enumeration), SECURITY_IMPERSONATION_LEVEL (Enumeration), TOKEN_MANDATORY_POLICY (Structure), SID (Structure)
Optional Dependencies: None

typedef struct _TOKEN_ACCESS_INFORMATION {
  PSID_AND_ATTRIBUTES_HASH     SidHash;
  PSID_AND_ATTRIBUTES_HASH     RestrictedSidHash;
  PTOKEN_PRIVILEGES            Privileges;
  LUID                         AuthenticationId;
  TOKEN_TYPE                   TokenType;
  SECURITY_IMPERSONATION_LEVEL ImpersonationLevel;
  TOKEN_MANDATORY_POLICY       MandatoryPolicy;
  DWORD                        Flags;
  DWORD                        AppContainerNumber;
  PSID                         PackageSid;
  PSID_AND_ATTRIBUTES_HASH     CapabilitiesHash;
  PSID                         TrustLevelSid;
  PSECURITY_ATTRIBUTES_OPAQUE  SecurityAttributes;
} TOKEN_ACCESS_INFORMATION, *PTOKEN_ACCESS_INFORMATION;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/bb394726(v=vs.85).aspx
#>

$TOKEN_ACCESS_INFORMATION = struct $Module TOKEN_ACCESS_INFORMATION @{
    SidHash            = field 0 $SID_AND_ATTRIBUTES_HASH
    RestrictedSidHash  = field 1 $SID_AND_ATTRIBUTES_HASH
    Privileges         = field 2 $TOKEN_PRIVILEGES
    AuthenticationId   = field 3 $LUID
    TokenType          = field 4 $TOKEN_TYPE
    ImpersonationLevel = field 5 $SECURITY_IMPERSONATION_LEVEL
    MandatoryPolicy    = field 6 $TOKEN_MANDATORY_POLICY
    Flags              = field 7 UInt32
    AppContainerNumber = field 8 UInt32
    PackageSid         = field 9 IntPtr
    CapabilitiesHash   = field 10 $SID_AND_ATTRIBUTES_HASH
    TrustLevelSid      = field 11 IntPtr
    SecurityAttributes = field 12 IntPtr
}