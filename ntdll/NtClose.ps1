function NtClose
{
    <#
    .SYNOPSIS

    Closes an object handle (used for NtCreateKey instead of CloseHandle).

    .PARAMETER KeyHandle

    A HANDLE to an open registry key. Use NtCreateKey to get a registry key handle.

    .DESCRIPTION

    CloseHandle should not be used to close a registry key handle, as documented on MSDN:
    "Do not use the CloseHandle function to close a handle to an open registry key. Instead, use the RegCloseKey function. CloseHandle does not close the handle to the registry key, but does not return an error to indicate this failure."

    .NOTES

    Author: Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func ntdll NtClose ([Int32]) @(
        [IntPtr] #_In_      HANDLE          ObjectHandle
    ) -EntryPoint NtClose)
    
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff566417(v=vs.85).aspx

    .EXAMPLE

    <Usage Example>
#>
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $KeyHandle    
    )
    
    $SUCCESS = $ntdll::NtClose($KeyHandle); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        Write-Debug "NtClose Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}