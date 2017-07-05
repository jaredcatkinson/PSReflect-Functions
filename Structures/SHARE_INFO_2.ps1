$SHARE_INFO_2 = struct $Module SHARE_INFO_2 @{
    shi2_netname      = field 0 String -MarshalAs @('LPWStr')
    shi2_type         = field 1 UInt32
    shi2_remark       = field 2 String -MarshalAs @('LPWStr')
    shi2_permissions  = field 3 UInt32
    shi2_max_uses     = field 4 UInt32
    shi2_current_uses = field 5 UInt32
    shi2_path         = field 6 String -MarshalAs @('LPWStr')
    shi2_passwd       = field 7 String -MarshalAs @('LPWStr')
}