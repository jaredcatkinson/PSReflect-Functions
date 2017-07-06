$KEY_VALUE_FULL_INFORMATION = struct $Module KEY_VALUE_FULL_INFORMATION @{
    TitleIndex      = field 0 UInt32
    Type            = field 1 UInt32
    DataOffset      = field 2 UInt32
    DataLength      = field 3 UInt32
    NameLength      = field 4 UInt32
    Name            = field 5 string -MarshalAs @('ByValTStr', 260)
} -CharSet Unicode