function AmsiOpenSession {
    <#

    .SYNOPSIS

    Opens an AmsiSession associated with an AmsiContext to conduct AMSI scans.

    Author: Ryan Cobb (@cobbr_io)
    License: GNU GPLv3
    Required Dependecies: PSReflect, amsi
    Optional Dependencies: none

    .DESCRIPTION

    AmsiOpenSession opens an AmsiSession assocaited with an AmsiContext by calling the function
    described here: https://msdn.microsoft.com/en-us/library/windows/desktop/dn889863(v=vs.85).aspx 

    .PARAMETER amsiContext

    A pointer to the AmsiContext for which this AmsiSession will be associated.

    .PARAMETER session

    A reference to the AmsiSession that will be set by this function.

    .OUTPUTS

    Int

    .EXAMPLE

    $AmsiSession = [IntPtr]::Zero
    AmsiInitialize -amsiContext $AmsiContext -session ([ref]$AmsiSession)

    .NOTES

    AmsiOpenSession is a part of PSAmsi, a tool for auditing and defeating AMSI signatures.

    PSAmsi is located at https://github.com/cobbr/PSAmsi. Additional information can be found at https://cobbr.io.

    #>
    Param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [IntPtr] $amsiContext,

        [Parameter(Position = 1, Mandatory)]
        [ref] $session
    )

    $HResult = $amsi::AmsiOpenSession($amsiContext, $session)

    If ($HResult -ne 0) {
        throw "AmsiOpenSession Error: $($HResult)"
    }

    $HResult
}