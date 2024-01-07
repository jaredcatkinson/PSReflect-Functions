function ReadProcessMemory
{
    <#
    .SYNOPSIS

    Reads data from an area of memory in a specified process. The entire area to be read must be accessible or the operation fails.

    .DESCRIPTION

    ReadProcessMemory copies the data in the specified address range from the address space of the specified process into the specified buffer of the current process. Any process that has a handle with PROCESS_VM_READ access can call the function.

    The entire area to be read must be accessible, and if it is not accessible, the function fails.

    .PARAMETER ProcessHandle

    A handle to the process with memory that is being read. The handle must have PROCESS_VM_READ access to the process.

    .PARAMETER BaseAddress

    The base address in the specified process from which to read. Before any data transfer occurs, the system verifies that all data in the base address and memory of the specified size is accessible for read access, and if it is not accessible the function fails.

    .PARAMETER Size

    The number of bytes to be read from the specified process.

    .NOTES
    
    Author - Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 ReadProcessMemory ([Bool]) @(
        [IntPtr],             # _In_ HANDLE hProcess
        [IntPtr],             # _In_ LPCVOID lpBaseAddress
        [Byte[]],             # _Out_ LPVOID  lpBuffer
        [Int],                # _In_ SIZE_T nSize
        [Int].MakeByRefType() # _Out_ SIZE_T *lpNumberOfBytesRead
    ) -EntryPoint ReadProcessMemory -SetLastError)
        
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms680553(v=vs.85).aspx
    
    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ProcessHandle,
        
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $BaseAddress,
        
        [Parameter(Mandatory = $true)]
        [Int]
        $Size    
    )
    
    $buf = New-Object byte[]($Size)
    [Int32]$NumberOfBytesRead = 0
    
    $SUCCESS = $Kernel32::ReadProcessMemory($ProcessHandle, $BaseAddress, $buf, $buf.Length, [ref]$NumberOfBytesRead); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        throw "ReadProcessMemory Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
    
    Write-Output $buf
}