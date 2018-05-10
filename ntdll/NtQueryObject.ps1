function NtQueryObject
{
    <#
    .SYNOPSIS

    Retrieves various kinds of object information.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func ntdll NtQueryObject ([UInt32]) @(
        [IntPtr],                #_In_opt_  HANDLE                   Handle,
        [UInt32],                #_In_      OBJECT_INFORMATION_CLASS ObjectInformationClass,
        [IntPtr],                #_Out_opt_ PVOID                    ObjectInformation,
        [UInt32],                #_In_      ULONG                    ObjectInformationLength,
        [UInt32].MakeByRefType() #_Out_opt_ PULONG                   ReturnLength
    ) -EntryPoint NtQueryObject)

    .LINK

    https://msdn.microsoft.com/en-us/library/bb432383(v=vs.85).aspx

    .EXAMPLE
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $Handle,

        [Parameter(Mandatory = $true)]
        [ValidateSet('ObjectBasicInformation','ObjectNameInformation','ObjectTypeInformation','ObjectTypesInformation','ObjectHandleFlagInformation','ObjectSessionInformation','ObjectSessionObjectInformation','MaxObjectInfoClass')]
        [string]
        $ObjectInformationClass
    )

    $ObjectInformationPtr = [IntPtr]::Zero
    $ObjectInformationLength = 0
    $ReturnLength = 0

    # Query with empty pointer and size to get return object size
    $SUCCESS = $Ntdll::NtQueryObject($Handle, $OBJECT_INFORMATION_CLASS::$ObjectInformationClass, $ObjectInformationPtr, $ObjectInformationLength, [ref]$ReturnLength)

    # Allocate memory to receive output
    $ObjectInformationPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($ReturnLength)
    $ObjectInformationLength = $ReturnLength
    
    # Query with properly sized pointer
    $SUCCESS = $ntdll::NtQueryObject($Handle, $OBJECT_INFORMATION_CLASS::$ObjectInformationClass, $ObjectInformationPtr, $ObjectInformationLength, [ref]$ReturnLength)
    
    switch($ObjectInformationClass)
    {
        ObjectBasicInformation
        {

        }
        ObjectNameInformation
        {
        }
        ObjectTypeInformation
        {
        }
        ObjectTypesInformation
        {
        }
        ObjectHandleFlagInformation
        {
        }
        ObjectSessionInformation
        {
            throw [System.NotImplementedException]
        }
        ObjectSessionObjectInformation
        {
            throw [System.NotImplementedException]
        }
        MaxObjectInfoClass
        {
            throw [System.NotImplementedException]
        }
    }

    Write-Output $ObjectInformationPtr
    
    #[System.Runtime.InteropServices.Marshal]::FreeHGlobal($ObjectInformationPtr)
}