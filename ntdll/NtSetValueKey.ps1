function NtSetValueKey
{
    <#
    .SYNOPSIS

    Creates or replaces a registry key's value entry.

    .PARAMETER KeyHandle

    Pointer to a registry key HANDLE where the value will be written.

    .PARAMETER ValueType

    Specifies the type of the registry key value to be written, e.g. REG_SZ.

    .PARAMETER ValueName

    Specifies the name of the registry key value to be written.

    .PARAMETER ValueData

    Specifies the data to be written for the registry value. 

    .DESCRIPTION

    Set the data for a value associated with a key.

    .NOTES

    Author: Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, UNICODE_STRING (Enumeration), REGISTRY_VALUE_TYPES (Enumeration)
    Optional Dependencies: None

    (func ntdll NtSetValueKey ([Int32]) @(
        [IntPtr],                       #_In_     HANDLE          KeyHandle,
        $UNICODE_STRING.MakeByRefType(),#_In_     PUNICODE_STRING ValueName,
        [Int32],                        #_In_opt_ ULONG           TitleIndex,
        [Int32],                        #_In_     ULONG           Type,
        [IntPtr],                       #_In_opt_ PVOID           Data,
        [Int32]                         #_In_     ULONG           DataSize
    ) -EntryPoint NtSetValueKey),
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff567109(v=vs.85).aspx

    .EXAMPLE

    <Usage Example>
#>
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $KeyHandle,

        [Parameter(Mandatory = $true)]
        [string]
        $ValueName,

        [Parameter(Mandatory = $true)]
        [ValidateSet('RegNone','RegSz','RegBinary','RegDWord','RegDWordBigEndian','RegLink','RegMultiSz','RegExpandSz','RegResourceList','RegResourceRequirementsList','RegFullResourceDescriptor')]
        [string]
        $ValueType,

        [Parameter()]
        [string]
        $ValueData
    )

switch($ValueType)
{
    RegNone             { $RegType = $REG_VALUE_TYPE::REG_NONE }
    RegBinary           { $RegType = $REG_VALUE_TYPE::REG_BINARY }
    RegDWord            { $RegType = $REG_VALUE_TYPE::REG_DWORD }
    RegDWordBigEndian   { $RegType = $REG_VALUE_TYPE::REG_DWORD_BIG_ENDIAN }
    RegLink             { $RegType = $REG_VALUE_TYPE::REG_LINK }
    RegMultiSz          { $RegType = $REG_VALUE_TYPE::REG_MULTI_SZ }
    RegExpandSz         { $RegType = $REG_VALUE_TYPE::REG_EXPAND_SZ }
    RegSz               { $RegType = $REG_VALUE_TYPE::REG_SZ }
}
if($RegType -ne $REG_VALUE_TYPE::REG_SZ) {
    throw [System.NotImplementedException]"The $($RegType) Registry Value Type is not implemented yet."
}

# Create a $UNICODE_STRING structure and a pointer to it. 
$vName               = [Activator]::CreateInstance($UNICODE_STRING)
$vName.Length        = $ValueName.Length * 2
$vName.MaximumLength = $ValueName.Length * 2
$vName.Buffer        = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($ValueName)
$pValueName          = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($UNICODE_STRING::GetSize())
[System.Runtime.InteropServices.Marshal]::StructureToPtr($vName, $pValueName, $true)

# For data of type REG_SZ, we can use $UNICODE_STRING
if ($ValueData) {
    $vData               = [Activator]::CreateInstance($UNICODE_STRING)
    $vData.Length        = $ValueData.Length * 2
    $vData.MaximumLength = $ValueData.Length * 2
    $vData.Buffer        = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($ValueData)
}

$TitleIndex = 0 # this is always set to 0 according to MSDN
# "This parameter is reserved. Device and intermediate drivers should set this parameter to zero."

    # $KeyHandle, [ref]$pValueName, $TitleIndex, $ValueType, $vData.Buffer, $ValueData.Length
    $SUCCESS = $ntdll::NtSetValueKey($KeyHandle, [ref]$pValueName, $TitleIndex, $RegType, $vData.Buffer, $vData.Length); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        Write-Debug "NtSetValueKey Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    # free our memory after allocation
    # Cannot convert argument "hglobal", with value: "UNICODE_STRING", for "FreeHGlobal" to type "System.IntPtr"
    #[System.Runtime.InteropServices.Marshal]::FreeHGlobal($pValueName)
}