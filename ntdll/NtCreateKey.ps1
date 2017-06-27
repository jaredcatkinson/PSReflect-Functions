function NtCreateKey
{
    <#
    .SYNOPSIS

    Creates a new registry key or opens an existing one.

    .PARAMETER KeyHandle

    Pointer to a HANDLE variable that receives a handle to the key.

    .PARAMETER DesiredAccess

    Specifies an ACCESS_MASK value that determines the requested access to the object. 

    .PARAMETER KeyName

    Specifies the full path of the registry key to be created, beginning with \Registry. Passed as the object name to an OBJECT_ATTRIBUTES structure.

    .PARAMETER Class

    .PARAMETER CreateOptions
    
    Specifies the options to apply when creating or opening a key, specified as a compatible combination of the following flags: REG_OPTION_VOLATILE, REG_OPTION_NON_VOLATILE, REG_OPTION_CREATE_LINK, REG_OPTION_BACKUP_RESTORE.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson), Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, THREADINFOCLASS (Enumeration)
    Optional Dependencies: None

    (func ntdll NtCreateKey ([Int32]) @(
    [IntPtr].MakeByRefType(), #_Out_      PHANDLE      KeyHandle,
    [Int32],                  #_In_       ACCESS_MASK  DesiredAccess,
    [bool],                   #_In_       POBJECT_ATTRIBUTES ObjectAttributes,
    $UNICODE_STRING.MakeByRefType(), #_In_opt_   PUNICODE_STRING    Class,
    [Int32],  #_In_      ULONG           CreateOptions,
    [IntPtr]  #_Out_opt_ PULONG          Disposition
    ) -EntryPoint NtCreateKey),      
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff566425(v=vs.85).aspx

    .EXAMPLE
    #>
<#
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $KeyName,

        [Parameter(Mandatory = $true)]
        [string]
        $DesiredAccess
    )
#>
 <# 	CString csFullKey = CheckRegFullPath(csKey);

	ANSI_STRING asKey;
	RtlZeroMemory(&asKey,sizeof(asKey));
	RtlInitAnsiString(&asKey,csFullKey);
	UNICODE_STRING usKeyName;
	RtlZeroMemory(&usKeyName,sizeof(usKeyName));
	RtlAnsiStringToUnicodeString(&usKeyName,&asKey,TRUE);
	usKeyName.MaximumLength = usKeyName.Length += 2;

	OBJECT_ATTRIBUTES ObjectAttributes;
	InitializeObjectAttributes(&ObjectAttributes,&usKeyName,OBJ_CASE_INSENSITIVE,m_hMachineReg,NULL);
    m_dwDisposition = 0;
	HANDLE hKey = NULL;
	//
	// if the key doesn't exist, create it
	m_NtStatus = NtCreateKey(&hKey, 
							 KEY_ALL_ACCESS, 
							 &ObjectAttributes,
							 0, 
							 NULL, 
							 REG_OPTION_NON_VOLATILE, 
							 &m_dwDisposition);
#> 
    $KeyHandle = [IntPtr]::Zero
    $KeyName = "\Registry\User\S-1-5-21-922925213-184676331-3052236288-1001\Microsoft\Windows\CurrentVersion\Run"
    $DesiredAccess = $KEY_ACCESS::KEY_ALL_ACCESS

    # InstantiateObjectAttributes
    $objectAttribute = [Activator]::CreateInstance($OBJECT_ATTRIBUTES)
    $objectAttribute.Length = $OBJECT_ATTRIBUTES::GetSize()
    $objectAttribute.RootDirectory = [IntPtr]::Zero
    $objectAttribute.ObjectName = $KeyName
    $objectAttribute.Attributes = 0x00000040
    $objectAttribute.SecurityDescriptor = [IntPtr]::Zero
    $objectAttribute.SecurityQualityOfService = [IntPtr]::Zero

    $CreateOptions = $REG_OPTION::REG_OPTION_NON_VOLATILE

    $Success = $ntdll::NtCreateKey([ref]$KeyHandle, $DesiredAccess, $objectAttribute, $CreateOptions, 0)

    if(-not $Success) 
    {
        Write-Debug "NtQueryInformationThread Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}