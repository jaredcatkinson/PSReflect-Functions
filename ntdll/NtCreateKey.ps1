function NtCreateKey
{
    <#
    .SYNOPSIS

    Creates a new registry key or opens an existing one. Once the driver has finished its manipulations, it must call NtClose to close the handle.

    .PARAMETER KeyName

    Specifies the full path of the registry key to be created, beginning with \Registry. Passed as the object name to an OBJECT_ATTRIBUTES structure.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson), Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, KEY_ACCESS (Enumeration), OBJECT_ATTRIBUTES (Enumeration), UNICODE_STRING (Enumeration)
    Optional Dependencies: None

    (func ntdll NtCreateKey ([UInt32]) @(
        [IntPtr].MakeByRefType(),               #_Out_      PHANDLE      KeyHandle,
        [Int32],                                #_In_       ACCESS_MASK  DesiredAccess,
        $OBJECT_ATTRIBUTES.MakeByRefType(),     #_In_       POBJECT_ATTRIBUTES ObjectAttributes,
        [Int32],                                #_Reserved_ ULONG              TitleIndex,
        $UNICODE_STRING.MakeByRefType(),        #_In_opt_   PUNICODE_STRING    Class,
        [Int32],                                #_In_       ULONG           CreateOptions,
        [IntPtr]                                #_Out_opt_  PULONG          Disposition
    ) -EntryPoint NtCreateKey),
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff566425(v=vs.85).aspx

    .EXAMPLE
    #>
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $KeyName
    )
#>
    $KeyHandle = [IntPtr]::Zero
    #$KeyName = "\Registry\Machine\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"

    # Create a UNICODE_STRING for the key name, should be a fully qualified object name
    $kName = [Activator]::CreateInstance($UNICODE_STRING)
    $kName.Length = $KeyName.Length * 2
    $kName.MaximumLength = $KeyName.Length * 2
    $kName.Buffer = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($KeyName)

    $DesiredAccess  = $KEY_ACCESS::KEY_ALL_ACCESS

    # InitializeObjectAttributes clone
    $objectAttribute                = [Activator]::CreateInstance($OBJECT_ATTRIBUTES)
    $objectAttribute.Length         = $OBJECT_ATTRIBUTES::GetSize()
    $objectAttribute.RootDirectory  = [IntPtr]::Zero
    $objectAttribute.Attributes     = $OBJ_ATTRIBUTE::OBJ_CASE_INSENSITIVE
    $objectAttribute.ObjectName     = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($UNICODE_STRING::GetSize())
    [System.Runtime.InteropServices.Marshal]::StructureToPtr($kName, $objectAttribute.ObjectName, $true)

    # These are set to NULL for default Security Settings (mirrors the InitializeObjectAttributes macro).
    $objectAttribute.SecurityDescriptor = [IntPtr]::Zero
    $objectAttribute.SecurityQualityOfService = [IntPtr]::Zero

    $TitleIndex = 0 # this is always set to 0 according to MSDN
    # "This parameter is reserved. Device and intermediate drivers should set this parameter to zero."

    $Class = [Activator]::CreateInstance($UNICODE_STRING)
    $CreateOptions = $REG_OPTION::REG_OPTION_NON_VOLATILE
    $Disposition = [IntPtr]::Zero

    $Success = $ntdll::NtCreateKey([ref]$KeyHandle, $DesiredAccess, [ref]$objectAttribute, $TitleIndex, [ref]$Class, $CreateOptions, $Disposition)

    if(-not $Success) 
    {
        Write-Debug "NtCreateKey Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    # free our memory after allocation
    [Marshal]::FreeHGlobal($objectAttribute.ObjectName)
}