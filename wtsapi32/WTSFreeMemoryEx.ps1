function WTSFreeMemoryEx
{
    <#
    .SYNOPSIS

    Frees memory that contains WTS_PROCESS_INFO_EX or WTS_SESSION_INFO_1 structures allocated by a Remote Desktop Services function.

    .DESCRIPTION

    Several Remote Desktop Services functions allocate buffers to return information. To free buffers that contain WTS_PROCESS_INFO_EX or WTS_SESSION_INFO_1 structures, you must call the WTSFreeMemoryEx function. To free other buffers, you can call either the WTSFreeMemory function or the WTSFreeMemoryEx function.

    .PARAMETER WTSTypeClass

    A value of the WTS_TYPE_CLASS enumeration type that specifies the type of structures contained in the buffer referenced by the pMemory parameter.

    .PARAMETER Buffer

    A pointer to the buffer to free.

    .PARAMETER NumberOfEntries

    The number of elements in the buffer referenced by the pMemory parameter.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, WTS_INFO_CLASS (Enumeration)
    Optional Dependencies: None

    (func wtsapi32 WTSFreeMemoryEx ([Int32]) @(
        [Int32],  #_In_ WTS_TYPE_CLASS WTSTypeClass
        [IntPtr], #_In_ PVOID          pMemory
        [Int32]   #_In_ ULONG          NumberOfEntries
    ) -EntryPoint WTSFreeMemoryEx -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/ee621015(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet()]
        [string]
        $WTSTypeClass,

        [Parameter(Mandatory = $true)]
        [IntPtr]
        $Buffer,

        [Parameter(Mandatory = $true)]
        [Int32]
        $NumberOfEntries
    )

    $SUCCESS = $wtsapi32::WTSFreeMemoryEx($WTS_TYPE_CLASS::$WTSTypeClass, $Buffer, $NumberOfEntries); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if (-not $SUCCESS)
    {
        throw "[WTSFreeMemoryEx] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}