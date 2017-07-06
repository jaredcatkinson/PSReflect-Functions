$KEY_FULL_INFORMATION = struct $Module KEY_FULL_INFORMATION @{
    LastWriteTime    = field 0 $LARGE_INTEGER
    TitleIndex       = field 1 UInt32
    ClassOffset      = field 2 UInt32
    ClassLength      = field 3 UInt32
    SubKeys          = field 4 UInt32
    MaxNameLen       = field 5 UInt32
    MaxClassLen      = field 6 UInt32
    Values           = field 7 UInt32
    MaxValueNameLen  = field 8 UInt32
    MaxValueDataLen  = field 9 UInt32
    Class            = field 10 string -MarshalAs @('ByValTStr', 260)
} -CharSet Unicode