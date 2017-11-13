<#
.SYNOPSIS

Contains parameters used to check for strong signatures on certificates, certificate revocation lists (CRLs), online certificate status protocol (OCSP) responses, and PKCS #7 messages.

.PARAMETER CbSize

Size, in bytes, of this structure.

.PARAMETER dwInfoChoice

Indicates which nested union member points to the strong signature information.

.PARAMETER DUMMYUNIONNAME

Union that contains the parameters that can be used for checking whether a signature is strong. The parameters consist of signature algorithm / hash algorithm pairs and public key algorithm / bit length pairs.

.PARAMETER pvInfo

Reserved

.PARAMETER pSerializedInfo

Pointer to a CERT_STRONG_SIGN_SERIALIZED_INFO structure that specifies the parameters.

.PARAMETER pszOID

Pointer to a string that contains an object identifier (OID) that represents predefined parameters that can be used for strong signature checking.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct _CERT_STRONG_SIGN_PARA {
  DWORD cbSize;
  DWORD dwInfoChoice;
  union {
    void                              *pvInfo;
    PCERT_STRONG_SIGN_SERIALIZED_INFO pSerializedInfo;
    LPSTR                             pszOID;
  } DUMMYUNIONNAME;
} CERT_STRONG_SIGN_PARA, *PCERT_STRONG_SIGN_PARA;typedef const CERT_STRONG_SIGN_PARA *PCCERT_STRONG_SIGN_PARA;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/hh870262(v=vs.85).aspx
#>

$CERT_STRONG_SIGN_PARA = struct $Module CERT_STRONG_SIGN_PARA @{
    cbSize         = field 0 UInt32
    dwInfoChoice   = field 1 UInt32
    DUMMYUNIONNAME = field 2 IntPtr
}