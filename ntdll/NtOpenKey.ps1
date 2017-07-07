function NtOpenKey
{
    <#
    .SYNOPSIS

    Opens an existing registry key. Once the driver has finished its manipulations, it must call NtClose to close the handle.

    .PARAMETER KeyName

    Specifies the full path of the registry key to be opened, beginning with \Registry. Passed as the object name to an OBJECT_ATTRIBUTES structure.

    .PARAMETER DesiredAccess

    Specifies an ACCESS_MASK bitmask for the registry key. Use the constants KeyRead, KeyWrite, KeyExecute, or KeyAllAccess (default).
    
    .NOTES

    Author: Jared Atkinson (@jaredcatkinson), Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, KEY_ACCESS (Enumeration), OBJECT_ATTRIBUTES (Enumeration)
    Optional Dependencies: None

    (func ntdll NtOpenKey ([UInt32]) @(
        [IntPtr].MakeByRefType(),           #_Out_ PHANDLE KeyHandle,
        [Int32],                            #_In_  ACCESS_MASK        DesiredAccess,
        $OBJECT_ATTRIBUTES.MakeByRefType()  #_In_  POBJECT_ATTRIBUTES ObjectAttributes
    ) -EntryPoint NtOpenKey),

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff567014(v=vs.85).aspx

    .EXAMPLE
    
    $MyKeyHandle = NtOpenKey -KeyName "\Registry\Machine\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    NtClose -KeyHandle $MyKeyHandle

    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $KeyName,

        [Parameter()]
        [ValidateSet('KeyRead','KeyWrite','KeyExecute','KeyAllAccess')]
        [string]
        $DesiredAccess = 'KeyAllAccess'
    )
#>
    $KeyHandle = [IntPtr]::Zero
    #$KeyName = "\Registry\Machine\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"

    # Create a UNICODE_STRING for the key name, should be a fully qualified object name
    $kName = RtlInitUnicodeString -SourceString $KeyName

    switch($DesiredAccess) {
        KeyRead      { $DesiredAccessMask = $KEY_ACCESS::KEY_READ }
        KeyWrite     { $DesiredAccessMask = $KEY_ACCESS::KEY_WRITE }
        KeyExecute   { $DesiredAccessMask = $KEY_ACCESS::KEY_EXECUTE }
        KeyAllAccess { $DesiredAccessMask = $KEY_ACCESS::KEY_ALL_ACCESS }
    }
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

    $Success = $ntdll::NtOpenKey([ref]$KeyHandle, $DesiredAccessMask, [ref]$objectAttribute)

    if(-not $Success) 
    {
        Write-Debug "NtOpenKey Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
    Write-Output $KeyHandle

    # free our memory after allocation
    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($objectAttribute.ObjectName)
}