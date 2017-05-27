# used by NetShareEnum


$SHARE_INFO_0       = struct $Module SHARE_INFO_0 @{
    shi0_netname    = field 0 String -MarshalAs @('LPWStr')
}

$SHARE_INFO_1       = struct $Module SHARE_INFO_1 @{
    shi1_netname    = field 0 String -MarshalAs @('LPWStr')
    shi1_type       = field 1 UInt32
    shi1_remark     = field 2 String -MarshalAs @('LPWStr')
}

$SHARE_INFO_2                 = struct $Module SHARE_INFO_2 @{
    shi2_netname              = field 0 String -MarshalAs @('LPWStr')
    shi2_type                 = field 1 UInt32
    shi2_remark               = field 2 String -MarshalAs @('LPWStr')
    shi2_permissions          = field 3 UInt32
    shi2_max_uses             = field 4 UInt32
    shi2_current_uses         = field 5 UInt32
    shi2_path                 = field 6 String -MarshalAs @('LPWStr')
    shi2_passwd               = field 7 String -MarshalAs @('LPWStr')
}

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

$SHARE_INFO_503                 = struct $Module SHARE_INFO_503 @{
    shi503_netname              = field 0 String -MarshalAs @('LPWStr')
    shi503_type                 = field 1 UInt32
    shi503_remark               = field 2 String -MarshalAs @('LPWStr')
    shi503_permissions          = field 3 UInt32
    shi503_max_uses             = field 4 UInt32
    shi503_current_uses         = field 5 UInt32
    shi503_path                 = field 6 String -MarshalAs @('LPWStr')
    shi503_passwd               = field 7 String -MarshalAs @('LPWStr')
    shi503_servername           = field 8 String -MarshalAs @('LPWStr')
    shi503_reserved             = field 9 UInt32
    shi503_security_descriptor  = field 10 IntPtr
}