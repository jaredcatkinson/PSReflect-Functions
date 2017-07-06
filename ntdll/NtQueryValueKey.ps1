function NtQueryValueKey
{
    <#
    .SYNOPSIS

    Returns a value entry for a registry key.

    .PARAMETER KeyHandle

    Pointer to a handle to the registry key to read value entries from.

    .PARAMETER ValueName

    The name of the value entry to obtain data for.

    .PARAMETER KeyValueInformationClass

    Specifies a KEY_VALUE_INFORMATION_CLASS value that determines the type of information returned in the KeyValueInformation buffer.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson), Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, KEY_VALUE_INFORMATION_CLASS (Enumeration), KEY_VALUE_BASIC_INFORMATION, KEY_VALUE_FULL_INFORMATION, KEY_VALUE_PARTIAL_INFORMATION (Structures)
    Optional Dependencies: None

    (func ntdll NtQueryValueKey ([UInt32]) @(
        [IntPtr],                           #_In_      HANDLE                      KeyHandle,
        $UNICODE_STRING.MakeByRefType(),    #_In_      PUNICODE_STRING             ValueName,
        $KEY_VALUE_INFORMATION_CLASS,       #_In_      KEY_VALUE_INFORMATION_CLASS KeyValueInformationClass,
        [IntPtr],                           #_Out_opt_ PVOID                       KeyValueInformation,
        [UInt32],                           #_In_      ULONG                       Length,
        [UInt32].MakeByRefType()            #_Out_     PULONG                      ResultLength
    ) -EntryPoint NtQueryValueKey),

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff567069(v=vs.85).aspx

    .EXAMPLE
    
    $MyKeyHandle = NtOpenKey -KeyName "\Registry\Machine\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $KeyInfo = NtQueryValueKey -KeyHandle $MyKeyHandle -ValueName "Viscosity" -KeyValueInformationClass KeyValueFullInformation
    NtClose -KeyHandle $MyKeyHandle

    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $KeyHandle,

        [Parameter(Mandatory = $true)]
        [string]
        $ValueName,

        [Parameter()]
        [ValidateSet('KeyValueBasicInformation','KeyValueFullInformation','KeyValuePartialInformation')]
        [string]
        $KeyValueInformationClass = 'KeyValueBasicInformation'
    )
#>
    $KeyValueInfoPtrSize = 0
    $KeyValueName = RtlInitUnicodeString -SourceString $ValueName

    # initial query to determine the necessary buffer size
    $status = $ntdll::NtQueryValueKey($KeyHandle, [ref]$KeyValueName, $KEY_VALUE_INFORMATION_CLASS::$KeyValueInformationClass, 0, $KeyValueInfoPtrSize, [ref]$KeyValueInfoPtrSize)

    # allocate the correct size and assign the value to our buffer
    [IntPtr]$KeyValueInfoPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($KeyValueInfoPtrSize)
    $status = $ntdll::NtQueryValueKey($KeyHandle, [ref]$KeyValueName, $KEY_VALUE_INFORMATION_CLASS::$KeyValueInformationClass, $KeyValueInfoPtr, $KeyValueInfoPtrSize, [ref]$KeyValueInfoPtrSize)

    if(!$status){
        switch($KeyValueInformationClass)
        {
            KeyValueBasicInformation
            {
                $KeyValueBasicInformation = $KeyValueInfoPtr -as $KEY_VALUE_BASIC_INFORMATION
                Write-Output $KeyValueBasicInformation
            }
            KeyValueFullInformation
            {
                $KeyValueFullInformation = $KeyValueInfoPtr -as $KEY_VALUE_FULL_INFORMATION
                if($KeyValueFullInformation.DataLength -gt 0) {
                    $DataPtr = [IntPtr]::Add($KeyValueInfoPtr, $KeyValueFullInformation.DataOffset)
                    $KeyValueData = New-Object byte[] $KeyValueFullInformation.DataLength
                    [System.Runtime.InteropServices.Marshal]::Copy($DataPtr, $KeyValueData, 0, $KeyValueFullInformation.DataLength)
                    # Need to check Registry Value Type to see what kind of data this is before printing
                    Write-Output $KeyValueFullInformation
                    [System.Text.Encoding]::Unicode.GetString($KeyValueData)
                } else {
                Write-Output $KeyValueFullInformation
                }
            }
            KeyValuePartialInformation
            {
                $KeyValuePartialInformation = $KeyValueInfoPtr -as $KEY_VALUE_PARTIAL_INFORMATION
                Write-Output $KeyValuePartialInformation          
            }
        }
    }
    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($KeyValueInfoPtr)
}

