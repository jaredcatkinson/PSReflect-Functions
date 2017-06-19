$MEMORY_BASIC_INFORMATION = struct $Module MEMORY_BASIC_INFORMATION @{
    BaseAddress       = field 0 UIntPtr
    AllocationBase    = field 1 UIntPtr
    AllocationProtect = field 2 $MEMORY_PROTECTION
    RegionSize        = field 3 UIntPtr
    State             = field 4 $MEMORY_STATE
    Protect           = field 5 $MEMORY_PROTECTION
    Type              = field 6 $MEMORY_TYPE
}