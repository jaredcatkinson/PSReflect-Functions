<#
.SYNOPSIS

The WINTRUST_CATALOG_INFO structure is used when calling WinVerifyTrust to verify a member of a Microsoft catalog.

.PARAMETER cbStruct

Size, in bytes, of this structure.

.PARAMETER dwCatalogVersion

Optional. Catalog version number.

.PARAMETER pcwszCatalogFilePath

The full path and file name of the catalog file that contains the member to be verified.

.PARAMETER pcwszMemberTag

Tag of a member file to be verified.

.PARAMETER pcwszMemberFilePath

The full path and file name of the catalog member file to be verified.

.PARAMETER hMemberFile

Optional. Handle of the open catalog member file to be verified. The handle must be to a file with at least read permissions.

.PARAMETER pbCalculatedFileHash

Optional. The calculated hash of the file that contains the file to be verified.

.PARAMETER cbCalculatedFileHash

The size, in bytes, of the value passed in the pbCalculatedFileHash member. cbCalculatedFileHash is used only if the calculated hash is being passed.

.PARAMETER pcCatalogContext

A pointer to a CTL_CONTEXT structure that represents a catalog context to be used instead of a catalog file.

.PARAMETER hCatAdmin

Handle to the catalog administrator context that was used when calculating the hash of the file. This value can be zero only for a SHA1 file hash.

Windows 8 and Windows Server 2012:  Support for this member begins.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, CTL_CONTEXT (Structure)
Optional Dependencies: None

typedef struct WINTRUST_CATALOG_INFO_ {
  DWORD                                 cbStruct;
  DWORD                                 dwCatalogVersion;
  LPCWSTR                               pcwszCatalogFilePath;
  LPCWSTR                               pcwszMemberTag;
  LPCWSTR                               pcwszMemberFilePath;
  HANDLE                                hMemberFile;
  _Field_size(cbCalculatedFileHash)BYTE *pbCalculatedFileHash;
  DWORD                                 cbCalculatedFileHash;
  PCCTL_CONTEXT                         pcCatalogContext;
  HCATADMIN                             hCatAdmin;
} WINTRUST_CATALOG_INFO, *PWINTRUST_CATALOG_INFO;

.LINK

The WINTRUST_CATALOG_INFO structure is used when calling WinVerifyTrust to verify a member of a Microsoft catalog.
#>
$WINTRUST_CATALOG_INFO = struct $Module WINTRUST_CATALOG_INFO @{
    cbStruct             = field 0 UInt32
    dwCatalogVersion     = field 1 UInt32
    pcwszCatalogFilePath = field 2 IntPtr
    pcwszMemberTag       = field 3 IntPtr
    pcwszMemberFilePath  = field 4 IntPtr
    hMemberFile          = field 5 IntPtr
    pbCalculatedFileHash = field 6 IntPtr
    cbCalculatedFileHash = field 7 UInt32
    pcCatalogContext     = field 8 IntPtr
    hCatAdmin            = field 9 IntPtr
} -CharSet Unicode