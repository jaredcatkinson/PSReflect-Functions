function K32GetMappedFileName
{
    <#
    .SYNOPSIS

    Checks whether the specified address is within a memory-mapped file in the address space of the specified process. If so, the function returns the name of the memory-mapped file.

    .DESCRIPTION

    Starting with Windows 7 and Windows Server 2008 R2, Psapi.h establishes version numbers for the PSAPI functions. The PSAPI version number affects the name used to call the function and the library that a program must load.
    
    If PSAPI_VERSION is 2 or greater, this function is defined as K32GetMappedFileName in Psapi.h and exported in Kernel32.lib and Kernel32.dll. If PSAPI_VERSION is 1, this function is defined as GetMappedFileName in Psapi.h and exported in Psapi.lib and Psapi.dll as a wrapper that calls K32GetMappedFileName.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 K32GetMappedFileName ([UInt32]) @(
        [IntPtr], #_In_  HANDLE hProcess 
        [IntPtr], #_In_  LPVOID lpv
        [Byte[]], #_Out_ LPTSTR lpFilename
        [UInt32]  #_In_  DWORD  nSize
    ) -EntryPoint K32GetMappedFileName -SetLastError)
    
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms683195(v=vs.85).aspx

    .EXAMPLE
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ProcessHandle,

        [Parameter(Mandatory = $true)]
        [IntPtr]
        $BaseAddress
    )

    $buf = New-Object byte[](1024)

    $SUCCESS = $kernel32::K32GetMappedFileName($ProcessHandle, $BaseAddress, $buf, $buf.Length); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        throw "[K32GetMappedFileName] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output ([System.Text.Encoding]::Unicode.GetString($buf))
}