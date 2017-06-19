$SECURITY_LOGON_TYPE = psenum $Module SECURITY_LOGON_TYPE UInt32 @{
    Interactive             = 2
    Network                 = 3
    Batch                   = 4
    Service                 = 5
    Proxy                   = 6
    Unlock                  = 7
    NetworkCleartext        = 8
    NewCredentials          = 9
    RemoteInteractive       = 10
    CachedInteractive       = 11
    CachedRemoteInteractive = 12
    CachedUnlock            = 13
}