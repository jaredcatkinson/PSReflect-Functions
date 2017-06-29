# https://msdn.microsoft.com/en-us/library/windows/desktop/ms724884(v=vs.85).aspx

$REG_VALUE_TYPE = psenum $Module REG_VALUE_TYPE UInt32 @{
    REG_NONE                       = 0x00000000
    REG_SZ                         = 0x00000001
    REG_EXPAND_SZ                  = 0x00000002
    REG_BINARY                     = 0x00000003
    REG_DWORD                      = 0x00000004
    REG_DWORD_BIG_ENDIAN           = 0x00000005
    REG_LINK                       = 0x00000006
    REG_MULTI_SZ                   = 0x00000007
    REG_RESOURCE_LIST              = 0x00000008
    REG_FULL_RESOURCE_DESCRIPTOR   = 0x00000009
    REG_RESOURCE_REQUIREMENTS_LIST = 0x0000000A
    REG_QWORD                      = 0x0000000B
}