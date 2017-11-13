<#
.SYNOPSIS

The CRYPTCATSTORE structure represents a catalog file. The CryptCATStoreFromHandle function populates this structure by using the handle returned by CryptCATOpen.

.PARAMETER cbStruct

The size, in bytes, of this structure.

.PARAMETER dwPublicVersion

A value that specifies the "PublicVersion" of the catalog file.

.PARAMETER pwszP7File

A pointer to a null-terminated string that contains the name of the catalog file. This member must be initialized before a call to the CryptCATPersistStore function.

.PARAMETER hProv

A handle to the cryptographic service provider (CSP).

.PARAMETER dwEncodingType

A value that specifies the encoding type used for the file. Currently, only X509_ASN_ENCODING and PKCS_7_ASN_ENCODING are being used; however, additional encoding types may be added in the future. For either current encoding type, use: X509_ASN_ENCODING | PKCS_7_ASN_ENCODING.

.PARAMETER fdwStoreFlags

A bitwise combination of the following values.

.PARAMETER hReserved

This member is reserved and must be NULL.

.PARAMETER hAttrs

This member is reserved and must be NULL.

.PARAMETER hCryptMsg

A handle to the decoded bytes. This member is only set if the file was opened with the CRYPTCAT_OPEN_NO_CONTENT_HCRYPTMSG flag set.

.PARAMETER hSorted

This member is reserved and must be NULL.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct CRYPTCATSTORE_ {
  DWORD      cbStruct;
  DWORD      dwPublicVersion;
  LPWSTR     pwszP7File;
  HCRYPTPROV hProv;
  DWORD      dwEncodingType;
  DWORD      fdwStoreFlags;
  HANDLE     hReserved;
  HANDLE     hAttrs;
  HCRYPTMSG  hCryptMsg;
  HANDLE     hSorted;
} CRYPTCATSTORE;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/bb736353(v=vs.85).aspx
#>

$CRYPTCATSTORE = struct $Module CRYPTCATSTORE @{
    cbStruct = field 0 UInt32
    dwPublicVersion = field 1 UInt32
    pwszP7File = field 2 IntPtr
    hProv = field 3 IntPtr
    dwEncodingType = field 4 UInt32
    fdwStoreFlags = field 5 UInt32
    hReserved = field 6 IntPtr
    hAttrs = field 7 IntPtr
    hCryptMsg = field 8 IntPtr
    hSorted = field 9 IntPtr
}