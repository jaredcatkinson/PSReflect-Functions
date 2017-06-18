$SYSTEM_HANDLE_INFORMATION = struct $Module SYSTEM_HANDLE_INFORMATION @{
	ProcessId        = field 0 UInt32
	ObjectTypeNumber = field 1 Byte
	Flags            = field 2 Byte
	HandleValue      = field 3 UInt16
	Object_Pointer   = field 4 IntPtr
	GrantedAccess    = field 5 UInt32
}