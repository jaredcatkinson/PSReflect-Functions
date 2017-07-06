$KEY_NAME_INFORMATION = struct $Module KEY_NAME_INFORMATION @{
    NameLength    = field 0 UInt32
    Name          = field 1 string -MarshalAs @('ByValTStr', 260)
} -CharSet Unicode