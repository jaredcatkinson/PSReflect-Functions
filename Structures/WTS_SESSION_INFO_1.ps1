$WTS_SESSION_INFO_1 = struct $Module WTS_SESSION_INFO_1 @{
    ExecEnvId    = field 0 UInt32
    State        = field 1 $WTS_CONNECTSTATE_CLASS
    SessionId    = field 2 UInt32
    pSessionName = field 3 String -MarshalAs @('LPWStr')
    pHostName    = field 4 String -MarshalAs @('LPWStr')
    pUserName    = field 5 String -MarshalAs @('LPWStr')
    pDomainName  = field 6 String -MarshalAs @('LPWStr')
    pFarmName    = field 7 String -MarshalAs @('LPWStr')
}