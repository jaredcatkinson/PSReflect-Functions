<#
.SYNOPSIS

The WINTRUST_CERT_INFO structure is used when calling WinVerifyTrust to verify a CERT_CONTEXT.

.PARAMETER cbStruct

Count of bytes in this structure.

.PARAMETER pcwszDisplayName

String with the name of the memory object pointed to by the pbMem member of the WINTRUST_BLOB_INFO structure.

.PARAMETER psCertContext

A pointer to the CERT_CONTEXT to be verified.

.PARAMETER chStores

The number of store handles in pahStores.

.PARAMETER pahStores

An array of open certificate stores to add to the list of stores that the policy provider looks in to find certificates while building a trust chain.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, CERT_CONTEXT (Structure), FILETIME (Structure)
Optional Dependencies: None

typedef struct WINTRUST_CERT_INFO_ {
  DWORD        cbStruct;
  LPCWSTR      pcwszDisplayName;
  CERT_CONTEXT *psCertContext;
  DWORD        chStores;
  HCERTSTORE   *pahStores;
} WINTRUST_CERT_INFO, *PWINTRUST_CERT_INFO;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa388204(v=vs.85).aspx
#>
$WINTRUST_CERT_INFO = struct $Module WINTRUST_CERT_INFO @{
    cbStruct         = field 0 UInt32
    pcwszDisplayName = field 1 IntPtr
    psCertContext    = field 2 IntPtr
    chStores         = field 3 UInt32
    pahStores        = field 4 IntPtr
    dwFlags          = field 5 UInt32
    psftVerifyASOf   = field 6 IntPtr
}