function GetCurrentProcess
{
    <#
    .SYNOPSIS

    Retrieves a pseudo handle for the current process.

    .DESCRIPTION

    A pseudo handle is a special constant, currently (HANDLE)-1, that is interpreted as the current process handle. For compatibility with future operating systems, it is best to call GetCurrentProcess instead of hard-coding this constant value. The calling process can use a pseudo handle to specify its own process whenever a process handle is required. Pseudo handles are not inherited by child processes.

    This handle has the PROCESS_ALL_ACCESS access right to the process object. For more information, see Process Security and Access Rights.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func kernel32 GetCurrentProcess ([IntPtr]) @() -EntryPoint GetCurrentProcess)

    .LINK
    
    https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getcurrentprocess
    #>

    [OutputType([IntPtr])]
    param()

    $kernel32::GetCurrentProcess()
}