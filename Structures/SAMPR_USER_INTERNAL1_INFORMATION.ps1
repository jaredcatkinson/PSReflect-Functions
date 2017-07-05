$SAMPR_USER_INTERNAL1_INFORMATION = struct $Module SAMPR_USER_INTERNAL1_INFORMATION @{
	EncryptedNtOwfPassword = field 0 byte[] -MarshalAs @('ByValArray', 16)
	EncryptedLmOwfPassword = field 1 byte[] -MarshalAs @('ByValArray', 16)
    NtPasswordPresent      = field 2 byte
	LmPasswordPresent      = field 3 byte
	PasswordExpired        = field 4 byte
}