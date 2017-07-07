$KEY_VALUE_BASIC_INFORMATION = struct $Module KEY_VALUE_BASIC_INFORMATION @{
    TitleIndex      = field 0 UInt32
    Type            = field 1 UInt32
    NameLength      = field 2 UInt32
    Name            = field 3 string -MarshalAs @('ByValTStr', 260)
} -CharSet Unicode