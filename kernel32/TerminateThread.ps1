function TerminateThread
{
    <#
    .SYNOPSIS

    Terminates a thread.

    .DESCRIPTION

    TerminateThread is used to cause a thread to exit. When this occurs, the target thread has no chance to execute any user-mode code. DLLs attached to the thread are not notified that the thread is terminating. The system frees the thread's initial stack.

    .PARAMETER ThreadHandle

    A handle to the thread to be terminated.

    The handle must have the THREAD_TERMINATE access right. 
    
    .PARAMETER ExitCode
    
    The exit code for the thread.

    .NOTES
    
    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func kernel32 TerminateThread ([bool]) @(
        [IntPtr],                                  # _InOut_ HANDLE hThread
        [UInt32]                                   # _In_ DWORD dwExitCode
    ) -EntryPoint TerminateThread -SetLastError)
        
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms686717(v=vs.85).aspx
    
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms686769(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ThreadHandle,
        
        [Parameter()]
        [UInt32]
        $ExitCode = 0
    )
    
    $Success = $Kernel32::TerminateThread($ThreadHandle, $ExitCode); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $Success) 
    {
        Write-Debug "TerminateThread Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}