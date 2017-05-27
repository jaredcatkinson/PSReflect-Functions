# used by NetWkstaUserEnum


$WKSTA_USER_INFO_0 = struct $Module WKSTA_USER_INFO_0 @{
    wkui0_username = field 0 String -MarshalAs @('LPWStr')
}

$WKSTA_USER_INFO_1      = struct $Module WKSTA_USER_INFO_1 @{
    wkui1_username      = field 0 String -MarshalAs @('LPWStr')
    wkui1_logon_domain  = field 1 String -MarshalAs @('LPWStr')
    wkui1_oth_domains   = field 2 String -MarshalAs @('LPWStr')
    wkui1_logon_server  = field 3 String -MarshalAs @('LPWStr')
}