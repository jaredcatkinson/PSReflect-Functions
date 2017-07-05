$SESSION_INFO_502 = struct $Module SESSION_INFO_502 @{
    sesi502_cname       = field 0 String -MarshalAs @('LPWStr')
    sesi502_username    = field 1 String -MarshalAs @('LPWStr')
    sesi502_num_opens   = field 2 UInt32
    sesi502_time        = field 3 UInt32
    sesi502_idle_time   = field 4 UInt32
    sesi502_cltype_name = field 5 String -MarshalAs @('LPWStr')
    sesi502_transport   = field 6 String -MarshalAs @('LPWStr')
}