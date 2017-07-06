$KEY_VALUE_PARTIAL_INFORMATION = struct $Module KEY_VALUE_PARTIAL_INFORMATION @{
    TitleIndex      = field 0 UInt32
    Type            = field 1 UInt32
    DataLength      = field 2 UInt32
    ValueData       = field 3 string -MarshalAs @('ByValTStr', 260)
} -CharSet Unicode