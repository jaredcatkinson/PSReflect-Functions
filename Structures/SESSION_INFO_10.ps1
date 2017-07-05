$SESSION_INFO_10 = struct $Module SESSION_INFO_10 @{
    sesi10_cname     = field 0 String -MarshalAs @('LPWStr')
    sesi10_username  = field 1 String -MarshalAs @('LPWStr')
    sesi10_time      = field 2 UInt32
    sesi10_idle_time = field 3 UInt32
}