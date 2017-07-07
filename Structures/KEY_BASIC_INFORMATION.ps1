$KEY_BASIC_INFORMATION = struct $Module KEY_BASIC_INFORMATION @{
    LastWriteTime = field 0 $LARGE_INTEGER
    TitleIndex    = field 1 UInt32
    NameLength    = field 2 UInt32
    Name          = field 3 string -MarshalAs @('ByValTStr', 260)
} -CharSet Unicode