$MemProtection = psenum $Mod PageOptions UInt32 @{
    PAGE_NOACCESS          = 0x01
    PAGE_READONLY          = 0x02
    PAGE_READWRITE         = 0x04
    PAGE_WRITECOPY         = 0x08
    PAGE_EXECUTE           = 0x10
    PAGE_EXECUTE_READ      = 0x20
    PAGE_EXECUTE_READWRITE = 0x40
    PAGE_EXECUTE_WRITECOPY = 0x80
    PAGE_GUARD             = 0x100
    PAGE_NOCACHE           = 0x200
    PAGE_WRITECOMBINE      = 0x400
    PAGE_TARGETS_INVALID   = 0x40000000
    PAGE_TARGETS_NO_UPDATE = 0x40000000
} -Bitfield