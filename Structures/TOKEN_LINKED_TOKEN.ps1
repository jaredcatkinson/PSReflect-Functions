<#
.SYNOPSIS

The TOKEN_LINKED_TOKEN structure contains a handle to a token. This token is linked to the token being queried by the GetTokenInformation function or set by the SetTokenInformation function.

.PARAMETER LinkedToken

A handle to the linked token.

When you have finished using the handle, close it by calling the CloseHandle function.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct _TOKEN_LINKED_TOKEN {
  HANDLE LinkedToken;
} TOKEN_LINKED_TOKEN, *PTOKEN_LINKED_TOKEN;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/bb530719(v=vs.85).aspx
#>

$TOKEN_LINKED_TOKEN = struct $Module TOKEN_LINKED_TOKEN @{
    LinkedToken = field 0 IntPtr
}