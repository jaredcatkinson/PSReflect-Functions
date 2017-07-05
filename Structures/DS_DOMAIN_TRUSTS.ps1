$DS_DOMAIN_TRUSTS = struct $Module DS_DOMAIN_TRUSTS @{
    NetbiosDomainName = field 0 String -MarshalAs @('LPWStr')
    DnsDomainName     = field 1 String -MarshalAs @('LPWStr')
    Flags             = field 2 $DsDomainFlag
    ParentIndex       = field 3 UInt32
    TrustType         = field 4 $DsDomainTrustType
    TrustAttributes   = field 5 $DsDomainTrustAttributes
    DomainSid         = field 6 IntPtr
    DomainGuid        = field 7 Guid
}