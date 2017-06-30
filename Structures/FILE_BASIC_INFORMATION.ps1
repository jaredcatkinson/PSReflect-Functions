$FILE_BASIC_INFORMATION = struct $Mod _FILE_BASIC_INFORMATION @{
        CreationTime        = field 0 $LARGE_INTEGER
        LastAccessTime      = field 1 $LARGE_INTEGER
        LastWriteTime       = field 2 $LARGE_INTEGER
        ChangeTime          = field 3 $LARGE_INTEGER
        FileAttributes      = field 4 UInt64
}