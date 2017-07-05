$CONNECTION_INFO_1 = struct $Module CONNECTION_INFO_1 @{
    coni1_id        = field 0 UInt32
    coni1_type      = field 1 UInt32
    coni1_num_opens = field 2 UInt32
    coni1_num_users = field 3 UInt32
    coni1_time      = field 4 UInt32
    coni1_username  = field 5 String -MarshalAs @('LPWStr')
    coni1_netname   = field 6 String -MarshalAs @('LPWStr')
}