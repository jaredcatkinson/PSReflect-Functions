$LSA_UNICODE_STRING = struct $Module LSA_UNICODE_STRING @{
    Length        = field 0 UInt16
    MaximumLength = field 1 UInt16
    Buffer        = field 2 IntPtr
}