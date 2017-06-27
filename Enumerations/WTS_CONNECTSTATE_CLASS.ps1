$WTS_CONNECTSTATE_CLASS = psenum $Module WTS_CONNECTSTATE_CLASS UInt16 @{
    WTSActive        = 0
    WTSConnected     = 1
    WTSConnectQuery  = 2
    WTSShadow        = 3
    WTSDisconnected  = 4
    WTSIdle          = 5
    WTSListen        = 6
    WTSReset         = 7
    WTSDown          = 8
    WTSInit          = 9
}