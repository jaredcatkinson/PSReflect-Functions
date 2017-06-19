function VirtualFreeEx
{
    <#
    .SYNOPSIS

    Releases, decommits, or releases and decommits a region of memory within the virtual address space of a specified process.

    .DESCRIPTION

    Each page of memory in a process virtual address space has a Page State. The VirtualFreeEx function can decommit a range of pages that are in different states, some committed and some uncommitted. This means that you can decommit a range of pages without first determining the current commitment state of each page. Decommitting a page releases its physical storage, either in memory or in the paging file on disk.
    
    If a page is decommitted but not released, its state changes to reserved. Subsequently, you can call VirtualAllocEx to commit it, or VirtualFreeEx to release it. Attempting to read from or write to a reserved page results in an access violation exception.
    
    The VirtualFreeEx function can release a range of pages that are in different states, some reserved and some committed. This means that you can release a range of pages without first determining the current commitment state of each page. The entire range of pages originally reserved by VirtualAllocEx must be released at the same time.
    
    If a page is released, its state changes to free, and it is available for subsequent allocation operations. After memory is released or decommitted, you can never refer to the memory again. Any information that may have been in that memory is gone forever. Attempts to read from or write to a free page results in an access violation exception. If you need to keep information, do not decommit or free memory that contains the information.
    
    The VirtualFreeEx function can be used on an AWE region of memory and it invalidates any physical page mappings in the region when freeing the address space. However, the physical pages are not deleted, and the application can use them. The application must explicitly call FreeUserPhysicalPages to free the physical pages. When the process is terminated, all resources are automatically cleaned up.
    
    To delete an enclave when you finish using it, specify the following values:
    - The base address of the enclave for the lpAddress parameter.
    - 0 for the dwSize parameter.
    - MEM_RELEASE for the dwFreeType parameter. The MEM_DECOMMIT value is not supported for enclaves.

    .PARAMETER ProcessHandle

    A handle to a process. The function frees memory within the virtual address space of the process.
    The handle must have the PROCESS_VM_OPERATION access right.

    .PARAMETER BaseAddress

    A pointer to the starting address of the region of memory to be freed.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 VirtualFreeEx ([Bool]) @(
        [IntPtr],                                    # _In_ HANDLE hProcess
        [IntPtr],                                    # _In_ LPVOID lpAddress
        [UInt32],                                    # _In_ SIZE_T dwSize
        [UInt32]                                     # _In_ DWORD  dwFreeType
    ) -EntryPoint VirtualFreeEx -SetLastError)
        
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa366894(v=vs.85).aspx

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
        $BaseAddress
    )

    if(-not($Kernel32::VirtualFreeEx($ProcessHandle, $BaseAddress, 0, 0x8000)))
    {
        Throw "Unable to free memory segment."
    }
}