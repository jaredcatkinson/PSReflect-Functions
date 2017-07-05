$SHARE_INFO_1 = struct $Module SHARE_INFO_1 @{
    shi1_netname = field 0 String -MarshalAs @('LPWStr')
    shi1_type    = field 1 UInt32
    shi1_remark  = field 2 String -MarshalAs @('LPWStr')
}