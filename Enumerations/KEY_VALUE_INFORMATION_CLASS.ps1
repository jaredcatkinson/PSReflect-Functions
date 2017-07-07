# https://msdn.microsoft.com/en-us/library/windows/hardware/ff554218(v=vs.85).aspx
# The KEY_VALUE_INFORMATION_CLASS enumeration type specifies the type of information to supply about the value of a registry key.
$KEY_VALUE_INFORMATION_CLASS = psenum $Module KEY_VALUE_INFORMATION_CLASS UInt16 @{
    KeyValueBasicInformation          = 0
    KeyValueFullInformation           = 1
    KeyValuePartialInformation        = 2
    KeyValueFullInformationAlign64    = 3
    KeyValuePartialInnformationAlign64= 4
    MaxKeyValueInfoClass              = 5
}