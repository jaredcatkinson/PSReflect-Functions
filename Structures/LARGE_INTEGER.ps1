$LARGE_INTEGER = struct $Mod _LARGE_INTEGER @{
        QUADPART    = field 0 Int64 0
        LOWPART     = field 1 UInt32 0 
        HIGHPART    = field 2 Int32 4
} -ExplicitLayout