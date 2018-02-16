function GetThreadId
{
    <#
    .SYNOPSIS

    Retrieves the thread identifier of the specified thread.

    .PARAMETER Handle

    A handle to the thread. The handle must have the THREAD_QUERY_INFORMATION or THREAD_QUERY_LIMITED_INFORMATION access right.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func kernel32 GetThreadId ([UInt32]) @(
        [IntPtr] #_In_ HANDLE Thread
    ) -EntryPoint GetThreadId -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms683233(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $Handle    
    )
    
    $SUCCESS = $Kernel32::GetThreadId($Handle); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        Write-Error "[GetThreadId] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $SUCCESS
}