$CERT_NAME_FLAG = psenum $Module CERT_NAME_FLAG UInt32 @{
    NONE                = 0x0
    ISSUER              = 0x1
    SEARCH_ALL_NAMES    = 0x2
    DISABLE_IE4_UTF8    = 0x00010000
    STR_ENABLE_PUNYCODE = 0x00200000
}