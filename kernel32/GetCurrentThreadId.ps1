function GetCurrentThreadId
{
    <#
    .SYNOPSIS

    Retrieves the thread identifier of the calling thread.

    .DESCRIPTION

    Retrieves the thread identifier of the calling thread.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect  
    Optional Dependencies: None

    (func kernel32 GetCurrentThreadId ([UInt32]) @() -EntryPoint GetCurrentThreadId)

    .LINK

    https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getcurrentthreadid

    .EXAMPLE

    #>

    [OutputType([UInt32])]
    Param()

    $Kernel32::GetCurrentThreadId()
}