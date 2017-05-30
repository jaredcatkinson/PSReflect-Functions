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

(func kernel32 GetCurrentProcess ([IntPtr]) @())

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/ms683179(v=vs.85).aspx

.EXAMPLE

#>

    [OutputType([IntPtr])]
    Param()

    $Kernel32::GetCurrentProcess()
}


$FunctionDefinitions = @(
    (func kernel32 GetCurrentProcess ([IntPtr]) @())
)

$Module = New-InMemoryModule -ModuleName Win32
$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Kernel32 = $Types['kernel32']
