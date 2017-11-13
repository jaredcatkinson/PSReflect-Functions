$FILE_NAME_INFORMATION = struct $Module FILE_NAME_INFORMATION @{
   FileNameLength = field 0 UInt32
   FileName       = field 1 string -MarshalAs @('ByValTStr', 260)
}