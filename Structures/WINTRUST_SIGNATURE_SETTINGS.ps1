<#
.SYNOPSIS

The WINTRUST_SIGNATURE_SETTINGS structure can be used to specify the signatures on a file.

.PARAMETER cbStruct

Size, in bytes, of this structure.

.PARAMETER dwIndex

Contains the index of the signature to be validated if the dwFlags member is set to WSS_VERIFY_SPECIFIC.

.PARAMETER dwFlags

Flags that can be used to refine behavior.

.PARAMETER cSecondarySigs

Contains the number of secondary signatures found if the dwFlags member is set to WSS_GET_SECONDARY_SIG_COUNT.

.PARAMETER dwVerifiedSigIndex

The index used for verification. This member is set on return from Wintrust.

.PARAMETER pCryptoPolicy

Pointer to a CERT_STRONG_SIGN_PARA structure that contains the policy that a signature must pass to be considered valid.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, CERT_STRING_SIGN_PARA (Structure)
Optional Dependencies: None

typedef struct WINTRUST_SIGNATURE_SETTINGS_ {
  DWORD                  cbStruct;
  DWORD                  dwIndex;
  DWORD                  dwFlags;
  DWORD                  cSecondarySigs;
  DWORD                  dwVerifiedSigIndex;
  PCERT_STRONG_SIGN_PARA pCryptoPolicy;
} WINTRUST_SIGNATURE_SETTINGS, *PWINTRUST_SIGNATURE_SETTINGS;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/jj161044(v=vs.85).aspx
#>
$WINTRUST_SIGNATURE_SETTINGS = struct $Module WINTRUST_SIGNATURE_SETTINGS @{
    cbStruct           = field 0 UInt32
    dwIndex            = field 1 UInt32
    dwFlags            = field 2 UInt32
    cSecondarySigs     = field 3 UInt32
    dwVerifiedSigIndex = field 4 UInt32
    pCryptoPolicy      = field 5 IntPtr
}