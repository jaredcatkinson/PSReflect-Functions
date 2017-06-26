<#
.SYNOPSIS

The CATALOG_INFO structure contains the name of a catalog file. This structure is used by the CryptCATCatalogInfoFromContext function.

.PARAMETER cbStruct

Specifies the size, in bytes, of this structure.

.PARAMETER wszCatalogFile

Name of the catalog file.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct CATALOG_INFO_ {
  DWORD cbStruct;
  WCHAR wszCatalogFile[MAX_PATH];
} CATALOG_INFO;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa376006(v=vs.85).aspx
#>

$CATALOG_INFO = struct $Module CATALOG_INFO @{
    cbStruct       = field 0 UInt32
    wszCatalogFile = field 1 string -MarshalAs @('ByValTStr', 260)
} -Charset Unicode