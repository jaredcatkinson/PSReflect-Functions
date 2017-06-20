<#
TOKEN_MANDATORY_POLICY_OFF - No mandatory integrity policy is enforced for the token.
TOKEN_MANDATORY_POLICY_NO_WRITE_UP - A process associated with the token cannot write to objects that have a greater mandatory integrity level.
TOKEN_MANDATORY_POLICY_NEW_PROCESS_MIN - A process created with the token has an integrity level that is the lesser of the parent-process integrity level and the executable-file integrity level.
TOKEN_MANDATORY_POLICY_VALID_MASK - A combination of TOKEN_MANDATORY_POLICY_NO_WRITE_UP and TOKEN_MANDATORY_POLICY_NEW_PROCESS_MIN.
#>

$TOKENMANDATORYPOLICY = psenum $Module TOKENMANDATORYPOLICY UInt32 @{
    OFF                    = 0x0
    NO_WRITE_UP            = 0x1
    POLICY_NEW_PROCESS_MIN = 0x2
    POLICY_VALID_MASK      = 0x3

}