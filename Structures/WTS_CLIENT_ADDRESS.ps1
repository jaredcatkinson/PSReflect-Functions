$WTS_CLIENT_ADDRESS     = struct $Module WTS_CLIENT_ADDRESS @{
    AddressFamily       = field 0 UInt32
    Address             = field 1 Byte[] -MarshalAs @('ByValArray', 20)
}