function NtEnumerateKey
{
    <#
    .SYNOPSIS

    Provides information about a subkey of an open registry key.

    .PARAMETER KeyHandle

    Handle to the registry key that contains the subkeys to be enumerated.

    .PARAMETER Index

    The index of the subkey that you want information for.

    .PARAMETER KeyInformationClass

    Specifies a KEY_INFORMATION_CLASS value that determines the type of information returned in the KeyInformation buffer.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson), Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, KEY_INFORMATION_CLASS (Enumeration), KEY_BASIC_INFORMATION, KEY_FULL_INFORMATION, KEY_NODE_INFORMATION, KEY_NAME_INFORMATION (Structures)
    Optional Dependencies: None

    (func ntdll NtEnumerateKey ([UInt32]) @(
        [IntPtr],                           #_In_      HANDLE                KeyHandle,
        [UInt32],                           #_In_      ULONG                 Index,
        $KEY_INFORMATION_CLASS,             #_In_      KEY_INFORMATION_CLASS KeyInformationClass,
        [IntPtr],                           #_Out_opt_ PVOID                 KeyInformation,
        [UInt32],                           #_In_      ULONG                 Length,
        [UInt32].MakeByRefType()            #_Out_     PULONG                ResultLength
    ) -EntryPoint NtEnumerateKey),

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff566447(v=vs.85).aspx

    .EXAMPLE
    
    $MyKeyHandle = NtOpenKey -KeyName "\Registry\Machine\SOFTWARE\Microsoft\Windows\CurrentVersion"
    $KeyInfo = NtEnumerateKey -KeyHandle $MyKeyHandle -Index 0 -KeyInformationClass KeyFullInformation
    NtClose -KeyHandle $MyKeyHandle

    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $KeyHandle,

        # Index of the subkey we wish to enumerate
        [Parameter()]
        [int]
        $Index = 0,

        [Parameter()]
        [ValidateSet('KeyBasicInformation','KeyFullInformation','KeyNodeInformation')]
        [string]
        $KeyInformationClass = 'KeyBasicInformation'
    )
#>

    $SubKeyPtrSize = 0
    $status = $ntdll::NtEnumerateKey($KeyHandle, $Index, $KEY_INFORMATION_CLASS::$KeyInformationClass, 0, $SubKeyPtrSize, [ref]$SubKeyPtrSize)
    
    # if it returns STATUS_NO_MORE_ENTRIES, that means the Index is not valid (i.e. there isn't a subkey at that index)
    if($status -eq 0x8000001A) {
        throw [System.IndexOutOfRangeException] "Index out-of-bounds, or the given registry key has no subkeys."
    } 
    # allocate the correct size and assign the value to our buffer
    [IntPtr]$SubKeyPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($SubKeyPtrSize)
    $status = $ntdll::NtEnumerateKey($KeyHandle, $Index, $KEY_INFORMATION_CLASS::$KeyInformationClass, $SubKeyPtr, $SubKeyPtrSize, [ref]$SubKeyPtrSize)


    # if there are no errors, cast to specific type
    if(!$status){
        switch($KeyInformationClass)
        {
            KeyBasicInformation
            {
                $KeyBasicInformation = $SubKeyPtr -as $KEY_BASIC_INFORMATION
                Write-Output $KeyBasicInformation
            }
            KeyNodeInformation
            {
                $KeyNodeInformation = $SubKeyPtr -as $KEY_NODE_INFORMATION
                Write-Output $KeyNodeInformation
            }
            KeyFullInformation
            {
                $KeyFullInformation = $SubKeyPtr -as $KEY_FULL_INFORMATION
                Write-Output $KeyFullInformation
            }
        }
    }
    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($SubKeyPtr)
}

