<#
.SYNOPSIS

The CLAIM_SECURITY_ATTRIBUTE_FQBN_VALUE structure specifies the fully qualified binary name.

.PARAMETER Version

The version of the fully qualified binary name value.

.PARAMETER Name

A fully qualified binary name.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct _CLAIM_SECURITY_ATTRIBUTE_FQBN_VALUE {
  DWORD64 Version;
  PWSTR   Name;
} CLAIM_SECURITY_ATTRIBUTE_FQBN_VALUE, *PCLAIM_SECURITY_ATTRIBUTE_FQBN_VALUE;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/hh448483(v=vs.85).aspx
#>

$CLAIM_SECURITY_ATTRIBUTE_FQBN_VALUE = struct $Module CLAIM_SECURITY_ATTRIBUTE_FQBN_VALUE @{
    Version = field 0 UInt64
    Name    = field 1 IntPtr
}