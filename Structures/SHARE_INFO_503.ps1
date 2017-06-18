$SHARE_INFO_503                 = struct $Module SHARE_INFO_503 @{
    shi503_netname              = field 0 String -MarshalAs @('LPWStr')
    shi503_type                 = field 1 UInt32
    shi503_remark               = field 2 String -MarshalAs @('LPWStr')
    shi503_permissions          = field 3 UInt32
    shi503_max_uses             = field 4 UInt32
    shi503_current_uses         = field 5 UInt32
    shi503_path                 = field 6 String -MarshalAs @('LPWStr')
    shi503_passwd               = field 7 String -MarshalAs @('LPWStr')
    shi503_servername           = field 8 String -MarshalAs @('LPWStr')
    shi503_reserved             = field 9 UInt32
    shi503_security_descriptor  = field 10 IntPtr
}