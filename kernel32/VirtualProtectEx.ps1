function VirtualProtectEx
{
    <#
    .SYNOPSIS

    Changes the protection on a region of committed pages in the virtual address space of a specified process.

    .DESCRIPTION

    The access protection value can be set only on committed pages. If the state of any page in the specified region is not committed, the function fails and returns without modifying the access protection of any pages in the specified region.

    The PAGE_GUARD protection modifier establishes guard pages. Guard pages act as one-shot access alarms. For more information, see Creating Guard Pages.
    
    It is best to avoid using VirtualProtectEx to change page protections on memory blocks allocated by GlobalAlloc, HeapAlloc, or LocalAlloc, because multiple memory blocks can exist on a single page. The heap manager assumes that all pages in the heap grant at least read and write access.
    
    When protecting a region that will be executable, the calling program bears responsibility for ensuring cache coherency via an appropriate call to FlushInstructionCache once the code has been set in place. Otherwise attempts to execute code out of the newly executable region may produce unpredictable results.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func kernel32 VirtualProtectEx ([bool]) @(
        [IntPtr],                #_In_  HANDLE hProcess
        [IntPtr],                #_In_  LPVOID lpAddress
        [UInt32],                #_In_  SIZE_T dwSize
        [UInt32]                 #_In_  DWORD  flNewProtect
        [IntPtr].MakeByRefType() #_Out_ PDWORD lpflOldProtect
    ) -SetLastError) # MSDN states to call GetLastError if the return value is false.

    .LINK
    
    https://msdn.microsoft.com/en-us/library/windows/desktop/aa366899(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter()]
        [IntPtr]
        $ProcessHandle,

        [Parameter()]
        [IntPtr]
        $BaseAddress,

        [Parameter()]
        [UInt32]
        $Size,

        [Parameter()]
        [UInt32]
        $NewProtection
    )

    $lpflOldProtect = [IntPtr]::Zero

    $SUCCESS = $Kernel32::VirtualProtectEx($ProcessHandle, $BaseAddress, $Size, $NewProtection, [ref]$lpflOldProtect); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        throw "VirtualProtectEx Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}