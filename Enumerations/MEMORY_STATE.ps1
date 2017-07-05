$MEMORY_STATE = psenum $Module MEMORY_STATE UInt32 @{
    MEM_COMMIT  = 0x1000
    MEM_RESERVE = 0x2000
    MEM_FREE    = 0x10000
} -Bitfield