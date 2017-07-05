$SESSION_INFO_2 = struct $Module SESSION_INFO_2 @{
    sesi2_cname       = field 0 String -MarshalAs @('LPWStr')
    sesi2_username    = field 1 String -MarshalAs @('LPWStr')
    sesi2_num_opens   = field 2 UInt32
    sesi2_time        = field 3 UInt32
    sesi2_idle_time   = field 4 UInt32
    sesi2_user_flags  = field 5 UInt32
    sesi2_cltype_name = field 6 String -MarshalAs @('LPWStr')
}