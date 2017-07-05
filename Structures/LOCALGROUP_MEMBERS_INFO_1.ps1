$LOCALGROUP_MEMBERS_INFO_1 = struct $Module LOCALGROUP_MEMBERS_INFO_1 @{
    lgrmi1_sid      = field 0 IntPtr
    lgrmi1_sidusage = field 1 $SID_NAME_USER
    lgrmi1_name     = field 2 String -MarshalAs @('LPWStr')
}