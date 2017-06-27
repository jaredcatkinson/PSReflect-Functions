<#
.SYNOPSIS

The WINTRUST_FILE_INFO structure is used when calling WinVerifyTrust to verify an individual file.

.PARAMETER cbStruct

Count of bytes in this structure.

.PARAMETER pcwszFilePath

Full path and file name of the file to be verified. This parameter cannot be NULL.

.PARAMETER hFile

Optional. File handle to the open file to be verified. This handle must be to a file that has at least read permission. This member can be set to NULL.

.PARAMETER pgKnownSubject

Optional. Pointer to a GUID structure that specifies the subject type. This member can be set to NULL.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct WINTRUST_FILE_INFO_ {
  DWORD   cbStruct;
  LPCWSTR pcwszFilePath;
  HANDLE  hFile;
  GUID    *pgKnownSubject;
} WINTRUST_FILE_INFO, *PWINTRUCT_FILE_INFO;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa388206(v=vs.85).aspx
#>
$WINTRUST_FILE_INFO = struct $Module WINTRUST_FILE_INFO @{
    cbStruct       = field 0 UInt32
    pcwszFilePath  = field 1 IntPtr
    hFile          = field 2 IntPtr
    pgKnownSubject = field 3 IntPtr
} -CharSet Unicode