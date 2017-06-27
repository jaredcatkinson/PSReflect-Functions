<#
.SYNOPSIS

The WINTRUST_BLOB_INFO structure is used when calling WinVerifyTrust to verify a memory BLOB.

.PARAMETER cbStruct

The number of bytes in this structure.

.PARAMETER gSubject

The GUID of the SIP to load.

.PARAMETER pcwszDisplayName

A string that contains the name of the memory object pointed to by pbMem.

.PARAMETER cbMemObject

The length, in bytes, of the memory BLOB to be verified.

.PARAMETER pbMemObject

A pointer to a memory BLOB to be verified.

.PARAMETER cbMemSignedMsg

This member is reserved. Do not use it.

.PARAMETER pbMemSignedMsg

This member is reserved. Do not use it.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct WINTRUST_BLOB_INFO {
  DWORD    cbStruct;
  GUID     gSubject;
  LPCWSTR  pcwszDisplayName;
  DWORD    cbMemObject;
  BYTE     *pbMemObject;
  DWORD    cbMemSignedMsg;
  BYTE     *pbMemSignedMsg;
} WINTRUST_BLOB_INFO, *PWINTRUST_BLOB_INFO;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa388202(v=vs.85).aspx
#>
$WINTRUST_BLOB_INFO = struct $Module WINTRUST_BLOB_INFO @{
    cbStruct         = field 0 UInt32
    gSubject         = field 1 Guid
    pcwszDisplayName = field 2 IntPtr
    cbMemObject      = field 3 UInt32
    pbMemObject      = field 4 IntPtr
    cbMemSignedMsg   = field 5 UInt32
    pbMemSignedMsg   = field 6 IntPtr
}