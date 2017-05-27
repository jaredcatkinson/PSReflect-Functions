# used by NetLocalGroupGetMembers


$SID_NAME_USE               = psenum $Module SID_NAME_USE UInt16 @{
    SidTypeUser             = 1
    SidTypeGroup            = 2
    SidTypeDomain           = 3
    SidTypeAlias            = 4
    SidTypeWellKnownGroup   = 5
    SidTypeDeletedAccount   = 6
    SidTypeInvalid          = 7
    SidTypeUnknown          = 8
    SidTypeComputer         = 9
}

$LOCALGROUP_MEMBERS_INFO_0  = struct $Module LOCALGROUP_MEMBERS_INFO_0 @{
    lgrmi0_sid              = field 0 IntPtr
}

$LOCALGROUP_MEMBERS_INFO_1  = struct $Module LOCALGROUP_MEMBERS_INFO_1 @{
    lgrmi1_sid              = field 0 IntPtr
    lgrmi1_sidusage         = field 1 $SID_NAME_USE
    lgrmi1_name             = field 2 String -MarshalAs @('LPWStr')
}

$LOCALGROUP_MEMBERS_INFO_2  = struct $Module LOCALGROUP_MEMBERS_INFO_2 @{
    lgrmi2_sid              = field 0 IntPtr
    lgrmi2_sidusage         = field 1 $SID_NAME_USE
    lgrmi2_domainandname    = field 2 String -MarshalAs @('LPWStr')
}

$LOCALGROUP_MEMBERS_INFO_3  = struct $Module LOCALGROUP_MEMBERS_INFO_3 @{
    lgrmi3_domainandname    = field 0 String -MarshalAs @('LPWStr')
}
