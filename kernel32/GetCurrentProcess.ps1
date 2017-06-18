function GetCurrentProcess
{
<#
.SYNOPSIS

Retrieves a pseudo handle for the current process.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect  

.DESCRIPTION

Retrieves a pseudo handle for the current process.

.NOTES

(func kernel32 GetCurrentProcess ([IntPtr]) @() -EntryPoint GetCurrentProcess)

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/ms683179(v=vs.85).aspx

.EXAMPLE

#>

    [OutputType([IntPtr])]
    Param()

    $Kernel32::GetCurrentProcess()
}