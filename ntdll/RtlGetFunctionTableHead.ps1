function RtlGetFunctionTableListHead
{
    <#
    .SYNOPSIS

    Enables a debugger to examine dynamic function table information.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, IO_STATUS_BLOCK (Structure)
    Optional Dependencies: None

    (func ntdll RtlGetFunctionTableListHead ([IntPtr]) @(

    ) -EntryPoint RtlGetFunctionTableListHead)

    .LINK

    https://msdn.microsoft.com/en-us/library/bb432427(v=vs.85).aspx

    .EXAMPLE

    $FunctionTableHead = RtlGetFunctionTableListHead
    #>

    Write-Output ($ntdll::RtlGetFunctionTableListHead())
}
