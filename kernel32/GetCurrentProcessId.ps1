function GetCurrentProcessId
{
    <#
    .SYNOPSIS

    Retrieves the process identifier of the calling process.

    .DESCRIPTION

    Until the process terminates, the process identifier uniquely identifies the process throughout the system.


    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect  
    Optional Dependencies: None

    (func kernel32 GetCurrentProcessId ([UInt32]) @() -EntryPoint GetCurrentProcessId)

    .LINK

    https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getcurrentprocessid

    .EXAMPLE

    #>

    [OutputType([UInt32])]
    Param()

    $Kernel32::GetCurrentProcessId()
}