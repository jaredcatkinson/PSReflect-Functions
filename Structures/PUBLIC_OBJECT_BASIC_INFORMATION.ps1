$PUBLIC_OBJECT_BASIC_INFORMATION = struct $Module PUBLIC_OBJECT_BASIC_INFORMATION @{
   Attributes    = field 0 UInt32
   GrantedAccess = field 1 UInt32
   HandleCount   = field 2 UInt32
   PointerCount  = field 3 UInt32
   Reserved      = field 4 byte[] -MarshalAs ('ByValArray', 0x28)
}