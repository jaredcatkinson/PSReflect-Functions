function WriteProcessMemory
{
    <#
    .SYNOPSIS

    Writes data to an area of memory in a specified process. The entire area to be written to must be accessible or the operation fails.

    .DESCRIPTION

    WriteProcessMemory copies the data from the specified buffer in the current process to the address range of the specified process. Any process that has a handle with PROCESS_VM_WRITE and PROCESS_VM_OPERATION access to the process to be written to can call the function. Typically but not always, the process with address space that is being written to is being debugged.
    
    The entire area to be written to must be accessible, and if it is not accessible, the function fails.

    .PARAMETER ProcessHandle

    A handle to the process memory to be modified. The handle must have PROCESS_VM_WRITE and PROCESS_VM_OPERATION access to the process.

    .PARAMETER BaseAddress

    A pointer to the base address in the specified process to which data is written. Before data transfer occurs, the system verifies that all data in the base address and memory of the specified size is accessible for write access, and if it is not accessible, the function fails.

    .PARAMETER Buffer

    A byte array that contains data to be written in the address space of the specified process.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func kernel32 WriteProcessMemory ([Bool]) @(
        [IntPtr],                                  # _In_ HANDLE hProcess
        [IntPtr],                                  # _In_ LPVOID lpBaseAddress
        [Byte[]],                                  # _In_ LPCVOID lpBuffer
        [UInt32],                                  # _In_ SIZE_T nSize
        [UInt32].MakeByRefType()                   # _Out_ SIZE_T *lpNumberOfBytesWritten
    ) -SetLastError) # MSDN states to call GetLastError if the return value is false. 

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms681674(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Handle')]
        [IntPtr]
        $ProcessHandle,

        [Parameter(Mandatory = $true)]
        [IntPtr]
        $BaseAddress,

        [Parameter(Mandatory = $true)]
        [byte[]]
        $Buffer
    )

    [Int32]$lpNumberOfBytesWritten = 0

    $SUCCESS = $Kernel32::WriteProcessMemory($ProcessHandle, $BaseAddress, $Buffer, $Buffer.Length, [ref]$lpNumberOfBytesWritten); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($SUCCESS -eq 0) 
    {
        throw "WriteProcessMemory Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}