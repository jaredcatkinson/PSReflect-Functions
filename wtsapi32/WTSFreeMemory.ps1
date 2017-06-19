function WTSFreeMemory
{
    <#
    .SYNOPSIS

    Frees memory allocated by a Remote Desktop Services function.

    .DESCRIPTION

    Several Remote Desktop Services functions allocate buffers to return information. Use the WTSFreeMemory function to free these buffers.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func wtsapi32 WTSFreeMemory ([void]) @(
        [IntPtr] #_In_ PVOID pMemory
    ) -EntryPoint WTSFreeMemory)
    
    .LINK

    https://msdn.microsoft.com/en-us/library/aa383834(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $Buffer
    )
   
    $wtsapi32::WTSFreeMemory($Buffer)
}