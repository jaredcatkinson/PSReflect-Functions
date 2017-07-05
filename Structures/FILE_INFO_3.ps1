$FILE_INFO_3 = struct $Module FILE_INFO_3 @{
    fi3_id          = field 0 UInt32
    fi3_permissions = field 1 UInt32
    fi3_num_locks   = field 2 UInt32
    fi3_pathname    = field 3 String -MarshalAs @('LPWStr')
    fi3_username    = field 4 String -MarshalAs @('LPWStr')
}