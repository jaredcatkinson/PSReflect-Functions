<#
.SYNOPSIS

The TOKEN_APPCONTAINER_INFORMATION structure specifies all the information in a token that is necessary for an app container.

.PARAMETER TokenAppContainer

The security identifier (SID) of the app container.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: SID (Structure)
Optional Dependencies: None

typedef struct _TOKEN_APPCONTAINER_INFORMATION {
  	PSID TokenAppContainer;
} TOKEN_APPCONTAINER_INFORMATION, *PTOKEN_APPCONTAINER_INFORMATION;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/hh448536(v=vs.85).aspx
#>

$TOKEN_APPCONTAINER_INFORMATION = struct $Module TOKEN_APPCONSTAINER_INFORMATION @{
    TokenAppContainer = field 0 IntPtr
}