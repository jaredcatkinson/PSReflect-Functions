$SIGNATURE_STATE = psenum $Module SIGNATURE_STATE UInt32 @{
    UNSIGNED_MISSING     = 0
    UNSIGNED_UNSUPPORTED = 1
    UNSIGNED_POLICY      = 2
    INVALID_CORRUPT      = 3
    INVALID_POLICY       = 4
    VALID                = 5
    TRUSTED              = 6
    UNTRUSTED            = 7
}
