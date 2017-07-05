$DsDomainFlag = psenum $Module DsDomainFlag UInt32 @{
    IN_FOREST       = 0x01
    DIRECT_OUTBOUND = 0x02
    TREE_ROOT       = 0x04
    PRIMARY         = 0x08
    NATIVE_MODE     = 0x10
    DIRECT_INBOUND  = 0x20
} -Bitfield