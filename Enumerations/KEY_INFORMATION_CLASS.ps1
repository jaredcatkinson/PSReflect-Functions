# https://msdn.microsoft.com/en-us/library/windows/hardware/ff553373(v=vs.85).aspx
# The KEY_INFORMATION_CLASS enumeration type represents the type of information to supply about a registry key.

$KEY_INFORMATION_CLASS = psenum $Module KEY_INFORMATION_CLASS UInt16 @{
    KeyBasicInformation          = 0
    KeyNodeInformation           = 1
    KeyFullInformation           = 2
    KeyNameInformation           = 3
    KeyCachedInformation         = 4
    KeyFlagsInformation          = 5
    KeyVirtualizationInformation = 6
    KeyHandleTagsInformation     = 7
    MaxKeyInfoClass              = 8
}