$LSA_LAST_INTER_LOGON_INFO = struct $Module LSA_LAST_INTER_LOGON_INFO @{
    LastSuccessfulLogon                        = field 0 Int64
    LastFailedLogon                            = field 1 Int64
    FailedAttemptCountSinceLastSuccessfulLogon = field 2 UInt64
}