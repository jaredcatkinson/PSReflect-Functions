$CERT_FIND_FLAG = psenum $Module CERT_FIND_FLAG UInt32 @{
    NONE                       = 0
    ENHKEY_USAGE_FLAG          = 1
    EXT_ONLY_ENHKEY_USAGE_FLAG = 2
    NO_ENHKEY_USAGE_FLAG       = 8
    OR_ENHKEY_USAGE_FLAG       = 16
    VALID_ENHKEY_USAGE_FLAG    = 32
} -Bitfield