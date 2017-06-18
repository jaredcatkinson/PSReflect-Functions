function VirtualFreeEx
{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ProcessHandle

    .PARAMETER BaseAddress

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func kernel32 VirtualFreeEx ([Bool]) @(
        [IntPtr],                                    # _In_ HANDLE hProcess
        [IntPtr],                                    # _In_ LPVOID lpAddress
        [UInt32],                                    # _In_ SIZE_T dwSize
        [UInt32]                                     # _In_ DWORD  dwFreeType
    ) -EntryPoint VirtualFreeEx -SetLastError)
        
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
        $BaseAddress
    )

    # _In_ HANDLE hProcess
    # _In_ LPVOID lpAddress
    # _In_ SIZE_T dwSize
    # _In_ DWORD  dwFreeType
    if(-not($Kernel32::VirtualFreeEx($ProcessHandle, $BaseAddress, 0, 0x8000)))
    {
        Throw "Unable to free memory segment."
    }
}