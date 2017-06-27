function NtSetValueKey
{
    <#
    .SYNOPSIS

    Creates or replaces a registry key's value entry.

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
        $Handle,

        [Parameter(Mandatory = $true)]
        [ValidateSet('RegNone','RegSz','RegBinary','RegDWord','RegDWordBigEndian','RegLink','RegMultiSz','RegExpandSz','RegResourceList','RegResourceRequirementsList','RegFullResourceDescriptor')]
        [string]
        $RegType,
    )
    
    $SUCCESS = $ntdll::NtSetValueKey($Handle); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        Write-Debug "NtClose Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}