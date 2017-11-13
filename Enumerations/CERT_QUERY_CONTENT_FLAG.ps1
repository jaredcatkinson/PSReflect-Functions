$CERT_QUERY_CONTENT_FLAG = psenum $Module CERT_QUERY_CONTENT_FLAG UInt32 @{
    CERT               = 0x0002
    CTL                = 0x0004
    CRL                = 0x0008
    SERIALIZED_STORE   = 0x0010
    SERIALIZED_CERT    = 0x0020
    SERIALIZED_CTL     = 0x0040
    SERIALIZED_CRL     = 0x0080
    PKCS7_SIGNED       = 0x0100
    PKCS7_UNSIGNED     = 0x0200
    PKCS7_SIGNED_EMBED = 0x0400
    PKCS10             = 0x0800
    PFX                = 0x1000
    PAIR               = 0x2000
    ALL                = 0x3ffe
} -Bitfield