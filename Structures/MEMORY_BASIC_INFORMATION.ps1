$MEMORY_BASIC_INFORMATION = struct $Mod MEMORY_BASIC_INFORMATION @{
    BaseAddress       = field 0 UIntPtr
    AllocationBase    = field 1 UIntPtr
    AllocationProtect = field 2 UInt32
    RegionSize        = field 3 UIntPtr
    State             = field 4 UInt32
    Protect           = field 5 UInt32
    Type              = field 6 UInt32
}