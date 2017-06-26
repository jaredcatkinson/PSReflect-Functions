<#
.SYNOPSIS

The CLAIM_SECURITY_ATTRIBUTE_OCTET_STRING_VALUE structure specifies the OCTET_STRING value type of the claim security attribute.

.PARAMETER pValue

A pointer buffer that contains the OCTET_STRING value. The value is a series of bytes of the length indicated in the ValueLength member.

.PARAMETER ValueLength

The length, in bytes, of the OCTET_STRING value.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct _CLAIM_SECURITY_ATTRIBUTE_OCTET_STRING_VALUE {
  PVOID pValue;
  DWORD ValueLength;
} CLAIM_SECURITY_ATTRIBUTE_OCTET_STRING_VALUE, *PCLAIM_SECURITY_ATTRIBUTE_OCTET_STRING_VALUE;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/hh448485(v=vs.85).aspx
#>

$CLAIM_SECURITY_ATTRIBUTE_OCTET_STRING_VALUE = struct $Module CLAIM_SECURITY_ATTRIBUTE_OCTET_STRING_VALUE @{
    pValue      = field 0 IntPtr
    ValueLength = field 1 UInt32
}