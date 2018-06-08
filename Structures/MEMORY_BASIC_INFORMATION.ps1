$MEMORY_BASIC_INFORMATION = struct $Module MEMORY_BASIC_INFORMATION @{
    BaseAddress       = field 0 IntPtr
    AllocationBase    = field 1 IntPtr
    AllocationProtect = field 2 $MEMORY_PROTECTION
    RegionSize        = field 3 IntPtr
    State             = field 4 $MEMORY_STATE
    Protect           = field 5 $MEMORY_PROTECTION
    Type              = field 6 $MEMORY_TYPE
}