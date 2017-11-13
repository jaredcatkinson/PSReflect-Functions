$FILE_FULL_EA_INFORMATION = struct $Module FILE_FULL_EA_INFORMATION @{
    NextEntryOffset = field 0 UInt32
    Flags           = field 1 byte
    EaNameLength    = field 2 byte
    EaValueLength   = field 3 UInt16
    EaName          = field 4 char[] -MarshalAs @('ByValArray', 1)
}