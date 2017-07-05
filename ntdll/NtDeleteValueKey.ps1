function NtDeleteValueKey
{
    <#
    .SYNOPSIS

    Deletes a value entry matching a name from an open key in the registry. If no such entry exists, an error is returned.

    .PARAMETER KeyHandle

    A HANDLE to an open registry key. Use NtCreateKey to get a registry key handle. This handle must have sufficient DesiredAccess to delete the key (e.g. KEY_ALL_ACCESS)

    .PARAMETER ValueName

    The name of the value entry to delete. 

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson), Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, UNICODE_STRING (Enumeration)
    Optional Dependencies: None

    (func ntdll NtDeleteValueKey ([UInt32]) @(
        [IntPtr],                           #_In_ HANDLE KeyHandle,
        $UNICODE_STRING.MakeByRefType()     #_In_ PUNICODE_STRING ValueName
    ) -EntryPoint NtDeleteValueKey)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff566439(v=vs.85).aspx

    .EXAMPLE
    #>
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $KeyHandle,

        [Parameter(Mandatory = $true)]
        [string]
        $ValueName
    )

    # Create a $UNICODE_STRING structure and a pointer to it. 
    $vName               = [Activator]::CreateInstance($UNICODE_STRING)
    $vName.Length        = $ValueName.Length * 2
    $vName.MaximumLength = $ValueName.Length * 2
    $vName.Buffer        = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($ValueName)
    $pValueName          = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($UNICODE_STRING::GetSize())
    [System.Runtime.InteropServices.Marshal]::StructureToPtr($vName, $pValueName, $true)

    $Success = $ntdll::NtDeleteValueKey($KeyHandle, [ref]$pValueName); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $Success) 
    {
        Write-Debug "NtDeleteValueKey Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    # free our memory after allocation
    # Cannot convert argument "hglobal", with value: "UNICODE_STRING", for "FreeHGlobal" to type "System.IntPtr"
    # [System.Runtime.InteropServices.Marshal]::FreeHGlobal($pValueName)
}