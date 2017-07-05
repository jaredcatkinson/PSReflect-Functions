$IO_STATUS_BLOCK = struct $Module IO_STATUS_BLOCK @{
    Status  = field 0 Int64  -Offset 0
    Pointer = field 1 IntPtr -Offset 0
} -ExplicitLayout