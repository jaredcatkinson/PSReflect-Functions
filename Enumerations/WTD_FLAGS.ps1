$WTD_FLAGS = psenum $Module WTD_FLAGS UInt32 @{
    USE_IE4_TRUST_FLAG                  = 0x1
    NO_IE4_CHAIN_FLAG                   = 0x2
    NO_POLICY_USAGE_FLAG                = 0x4
    REVOCATION_CHECK_NONE               = 0x10
    REVOCATION_CHECK_END_CERT           = 0x20
    REVOCATION_CHECK_CHAIN              = 0x40
    REVOCATION_CHECK_CHAIN_EXCLUDE_ROOT = 0x80
    SAFER_FLAG                          = 0x100
    HASH_ONLY_FLAG                      = 0x200
    USE_DEFAULT_OSVER_CHECK             = 0x400
    LIFETIME_SIGNING_FLAG               = 0x800
    CACHE_ONLY_URL_RETRIEVAL            = 0x1000
    DISABLE_MD2_MD4                     = 0x2000
    MOTW                                = 0x4000
} -Bitfield