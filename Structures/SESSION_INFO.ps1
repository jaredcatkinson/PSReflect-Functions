# used by NetSessionEnum


$SESSION_INFO_0 = struct $Module SESSION_INFO_0 @{
    sesi0_cname = field 0 String -MarshalAs @('LPWStr')
}

$SESSION_INFO_1         = struct $Module SESSION_INFO_1 @{
    sesi1_cname         = field 0 String -MarshalAs @('LPWStr')
    sesi1_username      = field 1 String -MarshalAs @('LPWStr')
    sesi1_num_opens     = field 2 UInt32
    sesi1_time          = field 3 UInt32
    sesi1_idle_time     = field 4 UInt32
    sesi1_user_flags    = field 5 UInt32
}

$SESSION_INFO_2         = struct $Module SESSION_INFO_2 @{
    sesi2_cname         = field 0 String -MarshalAs @('LPWStr')
    sesi2_username      = field 1 String -MarshalAs @('LPWStr')
    sesi2_num_opens     = field 2 UInt32
    sesi2_time          = field 3 UInt32
    sesi2_idle_time     = field 4 UInt32
    sesi2_user_flags    = field 5 UInt32
    sesi2_cltype_name   = field 6 String -MarshalAs @('LPWStr')
}

$SESSION_INFO_10        = struct $Module SESSION_INFO_10 @{
    sesi10_cname        = field 0 String -MarshalAs @('LPWStr')
    sesi10_username     = field 1 String -MarshalAs @('LPWStr')
    sesi10_time         = field 2 UInt32
    sesi10_idle_time    = field 3 UInt32
}

$SESSION_INFO_502       = struct $Module SESSION_INFO_502 @{
    sesi502_cname       = field 0 String -MarshalAs @('LPWStr')
    sesi502_username    = field 1 String -MarshalAs @('LPWStr')
    sesi502_num_opens   = field 2 UInt32
    sesi502_time        = field 3 UInt32
    sesi502_idle_time   = field 4 UInt32
    sesi502_cltype_name = field 5 String -MarshalAs @('LPWStr')
    sesi502_transport   = field 6 String -MarshalAs @('LPWStr')
}
