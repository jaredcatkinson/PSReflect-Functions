$SECURITY_DESCRIPTOR = struct $Module SECURITY_DESCRIPTOR @{
    Revision  = field 0 Byte
    Sbz1 = field 1 Byte
    Control = field 2 $SECURITY_DESCRIPTOR_CONTROL
    Owner = field 3 IntPtr
    Group = field 4 IntPtr
    SACL = field 5 IntPtr
    DACL = field 6 IntPtr
}