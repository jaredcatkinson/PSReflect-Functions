function VirtualAllocEx
{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ProcessHandle

    .PARAMETER Size

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