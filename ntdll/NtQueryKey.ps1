function NtQueryKey
{
    <#
    .SYNOPSIS

    Provides information about the class of a registry key, and the number and sizes of its subkeys.

    .PARAMETER KeyHandle

    Pointer to a handle to the registry key to obtain information about.

    .PARAMETER KeyInformationClass

    Specifies a KEY_INFORMATION_CLASS value that determines the type of information returned in the KeyInformation buffer.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson), Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, KEY_INFORMATION_CLASS (Enumeration), KEY_BASIC_INFORMATION, KEY_FULL_INFORMATION, KEY_NODE_INFORMATION, KEY_NAME_INFORMATION (Structures)
    Optional Dependencies: None

    (func ntdll NtQueryKey ([UInt32]) @(
        [IntPtr],                           #_In_      HANDLE                KeyHandle,
        $KEY_INFORMATION_CLASS,             #_In_      KEY_INFORMATION_CLASS KeyInformationClass,
        [IntPtr],                           #_Out_opt_ PVOID                 KeyInformation,
        [UInt32],                           #_In_      ULONG                 Length,
        [UInt32].MakeByRefType()            #_Out_     PULONG                ResultLength
    ) -EntryPoint NtQueryKey),

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff567060(v=vs.85).aspx

    .EXAMPLE
    
    $MyKeyHandle = NtOpenKey -KeyName "\Registry\Machine\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $KeyInfo = NtQueryKey -KeyHandle $MyKeyHandle -KeyInformationClass KeyFullInformation
    NtClose -KeyHandle $MyKeyHandle

    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $KeyHandle,

        [Parameter()]
        [ValidateSet('KeyBasicInformation','KeyFullInformation','KeyNodeInformation','KeyNameInformation')]
        [string]
        $KeyInformationClass = 'KeyBasicInformation'
    )
#>

    $KeyInfoPtrSize = 0
    # initial query to determine the necessary buffer size
    $status = $ntdll::NtQueryKey($KeyHandle, $KEY_INFORMATION_CLASS::$KeyInformationClass, 0, $KeyInfoPtrSize, [ref]$KeyInfoPtrSize)

    # allocate the correct size and assign the value to our buffer
    [IntPtr]$KeyInfoPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($KeyInfoPtrSize)
    $status = $ntdll::NtQueryKey($KeyHandle, $KEY_INFORMATION_CLASS::$KeyInformationClass, $KeyInfoPtr, $KeyInfoPtrSize, [ref]$KeyInfoPtrSize)

    # if there are no errors, cast to specific type
    if(!$status){
        switch($KeyInformationClass)
        {
            KeyBasicInformation
            {
                $KeyBasicInformation = $KeyInfoPtr -as $KEY_BASIC_INFORMATION
                Write-Output $KeyBasicInformation
            }
            KeyNodeInformation
            {
                $KeyNodeInformation = $KeyInfoPtr -as $KEY_NODE_INFORMATION
                Write-Output $KeyNodeInformation
            }
            KeyFullInformation
            {
                $KeyFullInformation = $KeyInfoPtr -as $KEY_FULL_INFORMATION
                Write-Output $KeyFullInformation
            }
            KeyNameInformation
            {
                $KeyNameInformation = $KeyInfoPtr -as $KEY_NAME_INFORMATION
                Write-Output $KeyNameInformation           
            }
        }
    }
[System.Runtime.InteropServices.Marshal]::FreeHGlobal($KeyInfoPtr)
}

