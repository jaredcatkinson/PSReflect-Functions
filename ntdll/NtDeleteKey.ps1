function NtDeleteKey
{
    <#
    .SYNOPSIS

    Deletes an open key from the registry.

    .PARAMETER KeyHandle

    A HANDLE to an open registry key. Use NtCreateKey to get a registry key handle.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson), Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func ntdll NtDeleteKey ([UInt32]) @(
        [IntPtr]    #_In_ HANDLE KeyHandle
    ) -EntryPoint NtDeleteKey)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff566437(v=vs.85).aspx

    .EXAMPLE
    #>
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $KeyHandle
    )
#>
    $Success = $ntdll::NtDeleteKey($KeyHandle); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $Success) 
    {
        Write-Debug "NtDeleteKey Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

}