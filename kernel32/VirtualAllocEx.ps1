function VirtualAllocEx
{
    <#
    .SYNOPSIS

    Reserves, commits, or changes the state of a region of memory within the virtual address space of a specified process. The function initializes the memory it allocates to zero.

    .DESCRIPTION

    Each page has an associated page state. The VirtualAllocEx function can perform the following operations:
    - Commit a region of reserved pages
    - Reserve a region of free pages
    - Simultaneously reserve and commit a region of free pages
    
    VirtualAllocEx cannot reserve a reserved page. It can commit a page that is already committed. This means you can commit a range of pages, regardless of whether they have already been committed, and the function will not fail.
    
    You can use VirtualAllocEx to reserve a block of pages and then make additional calls to VirtualAllocEx to commit individual pages from the reserved block. This enables a process to reserve a range of its virtual address space without consuming physical storage until it is needed.
    
    If the lpAddress parameter is not NULL, the function uses the lpAddress and dwSize parameters to compute the region of pages to be allocated. The current state of the entire range of pages must be compatible with the type of allocation specified by the flAllocationType parameter. Otherwise, the function fails and none of the pages is allocated. This compatibility requirement does not preclude committing an already committed page; see the preceding list.
    
    To execute dynamically generated code, use VirtualAllocEx to allocate memory and the VirtualProtectEx function to grant PAGE_EXECUTE access.
    
    The VirtualAllocEx function can be used to reserve an Address Windowing Extensions (AWE) region of memory within the virtual address space of a specified process. This region of memory can then be used to map physical pages into and out of virtual memory as required by the application. The MEM_PHYSICAL and MEM_RESERVE values must be set in the AllocationType parameter. The MEM_COMMIT value must not be set. The page protection must be set to PAGE_READWRITE.
    
    The VirtualFreeEx function can decommit a committed page, releasing the page's storage, or it can simultaneously decommit and release a committed page. It can also release a reserved page, making it a free page.
    
    When creating a region that will be executable, the calling program bears responsibility for ensuring cache coherency via an appropriate call to FlushInstructionCache once the code has been set in place. Otherwise attempts to execute code out of the newly executable region may produce unpredictable results.

    .PARAMETER ProcessHandle
    
    The handle to a process. The function allocates memory within the virtual address space of this process.

    The handle must have the PROCESS_VM_OPERATION access right.

    .PARAMETER Size

    The size of the region of memory to allocate, in bytes.
    
    If lpAddress is NULL, the function rounds dwSize up to the next page boundary.
    
    If lpAddress is not NULL, the function allocates all pages that contain one or more bytes in the range from lpAddress to lpAddress+dwSize. This means, for example, that a 2-byte range that straddles a page boundary causes the function to allocate both pages.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func kernel32 VirtualAllocEx ([IntPtr]) @(
        [IntPtr],                                  # _In_ HANDLE hProcess
        [IntPtr],                                  # _In_opt_ LPVOID lpAddress
        [UInt32],                                  # _In_ SIZE_T dwSize
        [UInt32],                                  # _In_ DWORD  flAllocationType
        [UInt32]                                   # _In_ DWORD  flProtect
    ) -EntryPoint VirtualAllocEx -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa366890(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Handle')]
        [IntPtr]
        $ProcessHandle,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $Size
    )

    $RemoteMemAddr = $Kernel32::VirtualAllocEx($ProcessHandle, [IntPtr]::Zero, $Size, 0x3000, 0x04)

    if (-not($RemoteMemAddr))
    {
        Throw "Unable to allocated memory in desired process!"
    }
    else
    {
        Write-Output $RemoteMemAddr
    }
}