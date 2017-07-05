$LARGE_INTEGER = struct $Module _LARGE_INTEGER @{
        QUADPART    = field 0 Int64  -Offset 0
        LOWPART     = field 1 UInt32 -Offset 0 
        HIGHPART    = field 2 Int32  -Offset 4
} -ExplicitLayout