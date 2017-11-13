$CERT_QUERY_FORMAT_FLAG = psenum $Module CERT_QUERY_FORMAT_FLAG UInt32 @{
    BINARY                = 0x02
    BASE64_ENCODED        = 0x04
    ASN_ASCII_HEX_ENCODED = 0x08
    ALL                   = 0x0E
} -Bitfield