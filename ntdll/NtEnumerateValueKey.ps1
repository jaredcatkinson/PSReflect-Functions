function NtEnumerateValueKey
{
    <#
    .SYNOPSIS

    Provides information about the value entries of an open key.

    .PARAMETER KeyHandle

    Handle to the registry key that you want to enumerate value entries for.

    .PARAMETER Index

    The index of the subkey that you want value information for.

    .PARAMETER KeyInformationClass

    Specifies a KEY_VALUE_INFORMATION_CLASS value that determines the type of information returned in the KeyValueInformation buffer.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson), Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, KEY_INFORMATION_CLASS (Enumeration), KEY_BASIC_INFORMATION, KEY_FULL_INFORMATION, KEY_NODE_INFORMATION, KEY_NAME_INFORMATION (Structures)
    Optional Dependencies: None

    (func ntdll NtEnumerateValueKey ([UInt32]) @(
        [IntPtr],                           #_In_      HANDLE                KeyHandle,
        [UInt32],                           #_In_      ULONG                 Index,
        $KEY_VALUE_INFORMATION_CLASS,       #_In_      KEY_INFORMATION_CLASS KeyValueInformationClass,
        [IntPtr],                           #_Out_opt_ PVOID                 KeyValueInformation,
        [UInt32],                           #_In_      ULONG                 Length,
        [UInt32].MakeByRefType()            #_Out_     PULONG                ResultLength
    ) -EntryPoint NtEnumerateValueKey),

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff566453(v=vs.85).aspx

    .EXAMPLE
    
    $MyKeyHandle = NtOpenKey -KeyName "\Registry\Machine\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $KeyInfo = NtEnumerateValueKey -KeyHandle $MyKeyHandle -Index 0 -KeyValueInformationClass KeyValueFullInformation
    NtClose -KeyHandle $MyKeyHandle

    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $KeyHandle,

        # Index of the value key we wish to enumerate
        [Parameter()]
        [int]
        $Index = 0,

        [Parameter()]
        [ValidateSet('KeyValueBasicInformation','KeyValueFullInformation','KeyValuePartialInformation')]
        [string]
        $KeyValueInformationClass = 'KeyValueBasicInformation'
    )
#>

    $SubKeyValuePtrSize = 0
    $status = $ntdll::NtEnumerateValueKey($KeyHandle, $Index, $KEY_VALUE_INFORMATION_CLASS::$KeyValueInformationClass, 0, $SubKeyValuePtrSize, [ref]$SubKeyValuePtrSize)

    # if it returns STATUS_NO_MORE_ENTRIES, that means the Index is not valid (i.e. there isn't a subkey at that index)
    if($status -eq 0x8000001A) {
        throw [System.IndexOutOfRangeException] "Index out-of-bounds, or the given registry key has no value entries."
    } 
    # allocate the correct size and assign the value to our buffer
    [IntPtr]$SubKeyValuePtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($SubKeyValuePtrSize)
    $status = $ntdll::NtEnumerateValueKey($KeyHandle, $Index, $KEY_VALUE_INFORMATION_CLASS::$KeyValueInformationClass, $SubKeyValuePtr, $SubKeyValuePtrSize, [ref]$SubKeyValuePtrSize)

    # if there are no errors, cast to specific type
    if(!$status){
        switch($KeyValueInformationClass)
        {
            KeyValueBasicInformation
            {
                $KeyValueBasicInformation = $SubKeyValuePtr -as $KEY_VALUE_BASIC_INFORMATION
                Write-Output $KeyValueBasicInformation
            }
            KeyValuePartialInformation
            {
                $KeyValuePartialInformation = $SubKeyValuePtr -as $KEY_VALUE_PARTIAL_INFORMATION
                Write-Output $KeyValuePartialInformation
            }
            KeyValueFullInformation
            {
                $KeyValueFullInformation = $SubKeyValuePtr -as $KEY_VALUE_FULL_INFORMATION
                if($KeyValueFullInformation.DataLength -gt 0) {
                    $DataPtr = [IntPtr]::Add($SubKeyValuePtr, $KeyValueFullInformation.DataOffset)
                    $SubKeyValueData = New-Object byte[] $KeyValueFullInformation.DataLength
                    [System.Runtime.InteropServices.Marshal]::Copy($DataPtr, $SubKeyValueData, 0, $KeyValueFullInformation.DataLength)
                    # Need to check Registry Value Type to see what kind of data this is before printing
                    Write-Output $KeyValueFullInformation
                    [System.Text.Encoding]::Unicode.GetString($SubKeyValueData)
                }
            }
        }
    }
    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($SubKeyValuePtr)
}