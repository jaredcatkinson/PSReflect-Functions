function ResumeThread
{
    <#
    .SYNOPSIS

    Decrements a thread's suspend count. When the suspend count is decremented to zero, the execution of the thread is resumed.

    .DESCRIPTION

    The ResumeThread function checks the suspend count of the subject thread. If the suspend count is zero, the thread is not currently suspended. Otherwise, the subject thread's suspend count is decremented. If the resulting value is zero, then the execution of the subject thread is resumed.
    
    If the return value is zero, the specified thread was not suspended. If the return value is 1, the specified thread was suspended but was restarted. If the return value is greater than 1, the specified thread is still suspended.
    
    Note that while reporting debug events, all threads within the reporting process are frozen. Debuggers are expected to use the SuspendThread and ResumeThread functions to limit the set of threads that can execute within a process. By suspending all threads in a process except for the one reporting a debug event, it is possible to "single step" a single thread. The other threads are not released by a continue operation if they are suspended.

    .PARAMETER ThreadHandle

    A handle to the thread to be restarted.
    
    This handle must have the THREAD_SUSPEND_RESUME access right.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func kernel32 ResumeThread ([UInt32]) @(
        [IntPtr] #_In_ HANDLE hThread
    ) -SetLastError) # MSDN states to call GetLastError if the return value is false.

    .LINK
    
    https://msdn.microsoft.com/en-us/library/windows/desktop/ms685086(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ThreadHandle
    )

    $SUCCESS = $Kernel32::ResumeThread($ThreadHandle); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        throw "ResumeThread Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}