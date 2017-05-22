function WriteProcessMemory
{
    <#
    .SYNOPSIS

    Writes data to an area of memory in a specified process. The entire area to be written to must be accessible or the operation fails.

    .DESCRIPTION

    .PARAMETER ProcessHandle

    .PARAMETER BaseAddress

    .PARAMETER Buffer

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

    if(-not($Kernel32::WriteProcessMemory($ProcessHandle, $BaseAddress, $Buffer, $Buffer.Length, [ref]$lpNumberOfBytesWritten)))
    {
        Throw "Unable to Write to Memory"
    }
}