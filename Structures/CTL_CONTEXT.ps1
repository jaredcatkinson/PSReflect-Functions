<#
.SYNOPSIS

The CTL_CONTEXT structure contains both the encoded and decoded representations of a CTL. It also contains an opened HCRYPTMSG handle to the decoded, cryptographically signed message containing the CTL_INFO as its inner content.

CryptoAPI low-level message functions can be used to extract additional signer information.

A CTL_CONTEXT returned by any CryptoAPI function must be freed by calling the CertFreeCTLContext function.

.PARAMETER dwMsgAndCertEncodingType

Type of encoding used. It is always acceptable to specify both the certificate and message encoding types by combining them with a bitwise-OR operation.

Currently defined encoding types are:
- X509_ASN_ENCODING
- PKCS_7_ASN_ENCODING

.PARAMETER pbCtlEncoded

A pointer to the encoded CTL.

.PARAMETER cbCtlEncoded

The size, in bytes, of the encoded CTL.

.PARAMETER pCtlInfo

A pointer to CTL_INFO structure contain the CTL information.

.PARAMETER hCertStore

A handle to the certificate store.

.PARAMETER hCryptMsg

Open HCRYPTMSG handle to a decoded, cryptographic-signed message containing the CTL_INFO as its inner content.

.PARAMETER pbCtlContent

The encoded inner content of the signed message.

.PARAMETER cbCtlContent

Count, in bytes, of pbCtlContent.

.NOTES

Author: Jared Atkinson (@jaredcatkinson)
License: BSD 3-Clause
Required Dependencies: PSReflect, CTL_INFO (Structure)
Optional Dependencies: None

typedef struct _CTL_CONTEXT {
  DWORD      dwMsgAndCertEncodingType;
  BYTE       *pbCtlEncoded;
  DWORD      cbCtlEncoded;
  PCTL_INFO  pCtlInfo;
  HCERTSTORE hCertStore;
  HCRYPTMSG  hCryptMsg;
  BYTE       *pbCtlContent;
  DWORD      cbCtlContent;
} CTL_CONTEXT, *PCTL_CONTEXT;typedef const CTL_CONTEXT *PCCTL_CONTEXT;

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa381486(v=vs.85).aspx
#>
$CTL_CONTEXT = struct $Module CTL_CONTEXT @{
    dwMsgAndCertEncodingType = field 0 UInt32
    pbCtlEncoded             = field 1 IntPtr
    cbCtlEncoded             = field 2 UInt32
    pCtlInfo                 = field 3 IntPtr
    hCertStore               = field 4 IntPtr
    hCryptMsg                = field 5 IntPtr
    pbCtlContent             = field 6 IntPtr
    cbCtlContent             = field 7 UInt32
}