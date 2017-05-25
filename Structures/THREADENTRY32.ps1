$THREADENTRY32 = struct $Mod THREADENTRY32 @{
    dwSize             = field 0 UInt32
    cntUsage           = field 1 UInt32
    th32ThreadID       = field 2 UInt32
    th32OwnerProcessID = field 3 UInt32
    tpBasePri          = field 4 UInt32
    tpDeltaPri         = field 5 UInt32
    dwFlags            = field 6 UInt32
}