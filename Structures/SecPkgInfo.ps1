$SecPkgInfo = struct $Module SecPkgInfo @{
    Capabilities = field 0 $SECPKG_FLAG
    Version      = field 1 UInt16
    RPCID        = field 2 UInt16
    MaxToken     = field 3 UInt32
    Name         = field 4 IntPtr
    Comment      = field 5 IntPtr
}