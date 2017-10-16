function AmsiUninitialize {
    <#

    .SYNOPSIS

    Uninitializes an AmsiContext initialized with AmsiInitialize.

    Author: Ryan Cobb (@cobbr_io)
    License: GNU GPLv3
    Required Dependecies: PSReflect, amsi
    Optional Dependencies: none

    .DESCRIPTION

    AmsiUninitialize uninitializes an AmsiContext initialized with AmsiInitialize by calling the function
    described here: https://msdn.microsoft.com/en-us/library/windows/desktop/dn889867(v=vs.85).aspx

    .PARAMETER amsiContext

    A pointer to the AmsiContext to be uninitialized.

    .OUTPUTS

    None

    .EXAMPLE

    $AmsiContext = [IntPtr]::Zero
    AmsiInitialize -appName "PSAmsi" -amsiContext ([ref]$AmsiContext)
    AmsiUninitialize -amsiConext $AmsiContext

    .NOTES

    AmsiUninitialize is a part of PSAmsi, a tool for auditing and defeating AMSI signatures.

    PSAmsi is located at https://github.com/cobbr/PSAmsi. Additional information can be found at https://cobbr.io.

    #>
    Param (
        [Parameter(Position = 0, Mandatory)]
        [IntPtr] $amsiContext
    )

    $HResult = $amsi::AmsiUninitialize($amsiContext)
}