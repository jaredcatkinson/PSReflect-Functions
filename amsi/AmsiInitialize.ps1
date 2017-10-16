function AmsiInitialize {
    <#

    .SYNOPSIS

    Initializes an AmsiContext to conduct AMSI scans.

    Author: Ryan Cobb (@cobbr_io)
    License: GNU GPLv3
    Required Dependecies: PSReflect, amsi
    Optional Dependencies: none

    .DESCRIPTION

    AmsiInitialize initializes an AmsiContext to conduct AMSI scans by calling the function
    described here: https://msdn.microsoft.com/en-us/library/windows/desktop/dn889862(v=vs.85).aspx 

    .PARAMETER appName

    The name of the App that will be submitting AMSI scan requests.

    .PARAMETER amsiContext

    A reference to the amsiContext that will be set by this function.

    .OUTPUTS

    Int

    .EXAMPLE

    $AmsiContext = [IntPtr]::Zero
    AmsiInitialize -appName "PSAmsi" -amsiContext ([ref]$AmsiContext)

    .NOTES

    AmsiInitialize is a part of PSAmsi, a tool for auditing and defeating AMSI signatures.

    PSAmsi is located at https://github.com/cobbr/PSAmsi. Additional information can be found at https://cobbr.io.

    #>
    Param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $appName,

        [Parameter(Position = 1, Mandatory)]
        [ref] $amsiContext
    )

    $HResult = $amsi::AmsiInitialize($appName, $amsiContext)

    If ($HResult -ne 0) {
        throw "AmsiInitialize Error: $($HResult). AMSI may not be enabled on your system."
    }

    $HResult
}