function GetCurrentThread
{
    <#
    .SYNOPSIS

    Retrieves a pseudo handle for the calling thread.

    .DESCRIPTION

    A pseudo handle is a special constant that is interpreted as the current thread handle. The calling thread can use this handle to specify itself whenever a thread handle is required. Pseudo handles are not inherited by child processes.

    This handle has the THREAD_ALL_ACCESS access right to the thread object. For more information, see Thread Security and Access Rights.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func kernel32 GetCurrentThread ([IntPtr]) @() -EntryPoint GetCurrentThread)

    .LINK
    
    https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getcurrentthread
    #>

    [OutputType([IntPtr])]
    param()

    $kernel32::GetCurrentThread()
}