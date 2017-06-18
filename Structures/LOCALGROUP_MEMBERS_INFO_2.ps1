$LOCALGROUP_MEMBERS_INFO_2  = struct $Module LOCALGROUP_MEMBERS_INFO_2 @{
    lgrmi2_sid              = field 0 IntPtr
    lgrmi2_sidusage         = field 1 $SID_NAME_USER
    lgrmi2_domainandname    = field 2 String -MarshalAs @('LPWStr')
}