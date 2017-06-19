$MIB_IPNETROW = struct $Module MIB_IPNETROW @{
    dwIndex = field 0 UInt32
    dwPhysAddrLen = field 1 UInt32
    bPhysAddr = field 2 byte[] -MarshalAs @('ByValArray', 6)
    dwAddr = field 3 UInt32
    dwType = field 4 UInt32
}