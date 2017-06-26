<#
.SYNOPSIS

.PARAMETER cbStruct

.PARAMETER pPolicyCallbackData

.PARAMETER pSIPClientData

.PARAMETER dwUIChoice

.PARAMETER fdwRevocationChecks

.PARAMETER dwUnionChoice

.PARAMETER pFile

.PARAMETER pCatalog

.PARAMETER pBlob

.PARAMETER pSgnr

.PARAMETER pCert

.PARAMETER dwStateAction

.PARAMETER hWVTStateData

.PARAMETER pwszURLReference

.PARAMETER dwProvFlags

.PARAMETER dwUIContext

.PARAMETER pSignatureSettings

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, WINTRUST_FILE_INFO (Structure), WINTRUST_CATALOG_INFO (Structure), WINTRUST_BLOB_INFO (Structure), WINTRUST_SGNR_INFO (Structure), WINTRUST_CERT_INFO (Structure), WINTRUST_SIGNATURE_SETTINGS (Structure)
Optional Dependencies: None

typedef struct _WINTRUST_DATA {
  DWORD                       cbStruct;
  LPVOID                      pPolicyCallbackData;
  LPVOID                      pSIPClientData;
  DWORD                       dwUIChoice;
  DWORD                       fdwRevocationChecks;
  DWORD                       dwUnionChoice;
  union {
    struct WINTRUST_FILE_INFO_  *pFile;
    struct WINTRUST_CATALOG_INFO_  *pCatalog;
    struct WINTRUST_BLOB_INFO_  *pBlob;
    struct WINTRUST_SGNR_INFO_  *pSgnr;
    struct WINTRUST_CERT_INFO_  *pCert;
  };
  DWORD                       dwStateAction;
  HANDLE                      hWVTStateData;
  WCHAR                       *pwszURLReference;
  DWORD                       dwProvFlags;
  DWORD                       dwUIContext;
  WINTRUST_SIGNATURE_SETTINGS *pSignatureSettings;
} WINTRUST_DATA, *PWINTRUST_DATA;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa388205(v=vs.85).aspx
#>

$WINTRUST_DATA = struct $Module WINTRUST_DATA @{
    cbStruct            = field 0 UInt32
    pPolicyCallbackData = field 1 IntPtr
    pSIPClientData      = field 2 IntPtr
    dwUIChoice          = field 3 UInt32
    fdwRevocationChecks = field 4 UInt32
    dwUnionChoice       = field 5 UInt32
    pData               = field 6 IntPtr
    dwStateAction       = field 7 UInt32
    hWVTStateData       = field 8 IntPtr
    pwszURLReference    = field 9 IntPtr
    dwProvFlags         = field 10 UInt32
    dwUIContext         = field 11 UInt32
    pSignatureSettings  = field 12 IntPtr
} -CharSet Unicode