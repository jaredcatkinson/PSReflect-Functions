$SESSION_INFO_1         = struct $Module SESSION_INFO_1 @{
    sesi1_cname         = field 0 String -MarshalAs @('LPWStr')
    sesi1_username      = field 1 String -MarshalAs @('LPWStr')
    sesi1_num_opens     = field 2 UInt32
    sesi1_time          = field 3 UInt32
    sesi1_idle_time     = field 4 UInt32
    sesi1_user_flags    = field 5 UInt32
}