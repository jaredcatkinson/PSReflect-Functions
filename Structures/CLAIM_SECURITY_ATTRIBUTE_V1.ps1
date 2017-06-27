<#
.SYNOPSIS

The CLAIM_SECURITY_ATTRIBUTE_V1 structure defines a security attribute that can be associated with a token or authorization context.

.PARAMETER Name

A pointer to a string of Unicode characters that contains the name of the security attribute. This string must be at least 4 bytes in length.

.PARAMETER ValueType

A union tag value that indicates the type of information contained in the Values member. 

.PARAMETER Reserved

This member is reserved and must be set to zero when sent and must be ignored when received.

.PARAMETER Flags

The attribute flags that are a 32-bitmask. Bits 16 through 31 may be set to any value. Bits 0 through 15 must be zero or a combination of one or more of the following mask values.

.PARAMETER ValueCount

The number of values specified in the Values member.

.PARAMETER Values

An array of security attribute values of the type specified in the ValueType member.

.PARAMETER pInt64

Pointer to an array of ValueCount members where each member is a LONG64 of type CLAIM_SECURITY_ATTRIBUTE_TYPE_INT64.

.PARAMETER pUint64

Pointer to an array of ValueCount members where each member is a ULONG64 of type CLAIM_SECURITY_ATTRIBUTE_TYPE_UINT64.

.PARAMETER ppString

Pointer to an array of ValueCount members where each member is a PWSTR of type CLAIM_SECURITY_ATTRIBUTE_TYPE_STRING.

.PARAMETER pFqbn

Pointer to an array of ValueCount members where each member is a fully qualified binary name value of type CLAIM_SECURITY_ATTRIBUTE_FQBN_VALUE.

.PARAMETER pOctetString

Pointer to an array of ValueCount members where each member is an octet string of type CLAIM_SECURITY_ATTRIBUTE_OCTET_STRING_VALUE.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, CLAIM_SECURITY_ATTRIBUTE_FQBN_VALUE (Structure), CLAIM_SECURITY_ATTRIBUTE_OCTET_STRING_VALUE (Structure)
Optional Dependencies: None

typedef struct _CLAIM_SECURITY_ATTRIBUTE_V1 {
  PWSTR Name;
  WORD  ValueType;
  WORD  Reserved;
  DWORD Flags;
  DWORD ValueCount;
  union {
    PLONG64                                      pInt64;
    PDWORD64                                     pUint64;
    PWSTR                                        *ppString;
    PCLAIM_SECURITY_ATTRIBUTE_FQBN_VALUE         pFqbn;
    PCLAIM_SECURITY_ATTRIBUTE_OCTET_STRING_VALUE pOctetString;
  } Values;
} CLAIM_SECURITY_ATTRIBUTE_V1, *PCLAIM_SECURITY_ATTRIBUTE_V1;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/hh448489(v=vs.85).aspx
#>

$CLAIM_SECURITY_ATTRIBUTE_V1 = struct $Module CLAIM_SECURITY_ATTRIBUTE_V1 @{
    Name         = field 0 IntPtr
    ValueType    = field 1 UInt16
    Reserved     = field 2 UInt16
    Flags        = field 3 UInt32
    ValueCount   = field 4 UInt32
    pInt64       = field 5 IntPtr
    pUint64      = field 6 IntPtr
    ppString     = field 7 IntPtr
    pFqbn        = field 8 $CLAIM_SECURITY_ATTRIBUTE_FQBN_VALUE
    pOctetString = field 9 $CLAIM_SECURITY_ATTRIBUTE_OCTET_STRING_VALUE
}