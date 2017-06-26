<#
.SYNOPSIS

The CLAIM_SECURITY_ATTRIBUTES_INFORMATION structure defines the security attributes for the claim.

.PARAMETER Version

The version of the security attribute. This must be CLAIM_SECURITY_ATTRIBUTES_INFORMATION_VERSION_V1.

.PARAMETER Reserved

This member is currently reserved and must be zero when setting an attribute and is ignored when getting an attribute.

.PARAMETER AttributeCount

The number of values.

.PARAMETER Attribute

The actual attribute.

.PARAMETER pAttributeV1

Pointer to an array that contains the AttributeCount member of the CLAIM_SECURITY_ATTRIBUTE_V1 structure.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, CLAIM_SECURITY_ATTRIBUTE_V1 (Structure), CLAIM_SECURITY_ATTRIBUTE_FQBN_VALUE (Structure), CLAIM_SECURITY_ATTRIBUTE_OCTET_STRING_VALUE (Structure)
Optional Dependencies: None

typedef struct _CLAIM_SECURITY_ATTRIBUTES_INFORMATION {
  WORD  Version;
  WORD  Reserved;
  DWORD AttributeCount;
  union {
    PCLAIM_SECURITY_ATTRIBUTE_V1 pAttributeV1;
  } Attribute;
} CLAIM_SECURITY_ATTRIBUTES_INFORMATION, *PCLAIM_SECURITY_ATTRIBUTES_INFORMATION;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/hh448481(v=vs.85).aspx
#>

$CLAIM_SECURITY_ATTRIBUTES_INFORMATION = struct $Module CLAIM_SECURITY_ATTRIBUTES_INFORMATION @{
      Version        = field 0 UInt16
      Reserved       = field 1 UInt16
      AttributeCount = field 2 UInt32
      Attribute      = field 3 $CLAIM_SECURITY_ATTRIBUTE_V1
}