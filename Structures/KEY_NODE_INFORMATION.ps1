$KEY_NODE_INFORMATION = struct $Module KEY_NODE_INFORMATION @{
    LastWriteTime = field 0 $LARGE_INTEGER
    TitleIndex    = field 1 UInt32
    ClassOffset   = field 2 UInt32
    ClassLength   = field 3 UInt32
    NameLength    = field 4 UInt32
    Name          = field 5 string -MarshalAs @('ByValTStr', 260)
} -CharSet Unicode