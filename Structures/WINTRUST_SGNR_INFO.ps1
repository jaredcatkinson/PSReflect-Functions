<#
.SYNOPSIS

The WINTRUST_SGNR_INFO structure is used when calling WinVerifyTrust to verify a CMSG_SIGNER_INFO structure.

.PARAMETER cbStruct

Count of bytes in this structure.

.PARAMETER pcwszDisplayName

String with the name representing the signer to be checked.

.PARAMETER psSignerInfo

A pointer to a CMSG_SIGNER_INFO structure that includes the signature to be verified.

.PARAMETER chStores

Number of store handles in pahStores.

.PARAMETER pahStores

An array of open certificate stores to be added to the list of stores that the policy provider uses to find certificates while building a trust chain.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, CMSG_SIGNER_INFO (Structure)
Optional Dependencies: None

typedef struct WINTRUST_SGNR_INFO {
  DWORD            cbStruct;
  LPCWSTR          pcwszDisplayName;
  CMSG_SIGNER_INFO *psSignerInfo;
  DWORD            chStores;
  HCERTSTORE       *pahStores;
} WINTRUST_SGNR_INFO, *PWINTRUST_SGNR_INFO;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa388207(v=vs.85).aspx
#>
$WINTRUST_SGNR_INFO = struct $Module WINTRUST_SGNR_INFO @{
    cbStruct         = field 0 UInt32
    pcwszDisplayName = field 1 IntPtr
    psDignerInfo     = field 2 IntPtr
    chStores         = field 3 UInt32
    pahStores        = field 4 IntPtr
}