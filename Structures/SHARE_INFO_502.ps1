$SHARE_INFO_502                 = struct $Module SHARE_INFO_502 @{
    shi502_netname              = field 0 String -MarshalAs @('LPWStr')
    shi502_type                 = field 1 UInt32
    shi502_remark               = field 2 String -MarshalAs @('LPWStr')
    shi502_permissions          = field 3 UInt32
    shi502_max_uses             = field 4 UInt32
    shi502_current_uses         = field 5 UInt32
    shi502_path                 = field 6 String -MarshalAs @('LPWStr')
    shi502_passwd               = field 7 String -MarshalAs @('LPWStr')
    shi502_reserved             = field 8 UInt32
    shi502_security_descriptor  = field 9 IntPtr
}