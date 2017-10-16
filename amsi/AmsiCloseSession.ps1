function AmsiCloseSession {
    <#

    .SYNOPSIS

    Closes an AmsiSession opened with AmsiOpenSession.

    Author: Ryan Cobb (@cobbr_io)
    License: GNU GPLv3
    Required Dependecies: PSReflect, amsi
    Optional Dependencies: none

    .DESCRIPTION

    AmsiCloseSession closes an AmsiSession opened with AmsiOpenSession by calling the function
    described here: https://msdn.microsoft.com/en-us/library/windows/desktop/dn889861(v=vs.85).aspx

    .PARAMETER amsiContext

    A pointer to the AmsiContext for which this AmsiSession is associated.

    .PARAMETER session

    A pointer to the AmsiSession to be closed.

    .OUTPUTS

    None

    .EXAMPLE

    $AmsiSession = [IntPtr]::Zero
    AmsiOpenSession -amsiContext $AmsiContext -session ([ref]$AmsiSession)
    AmsiCloseSession -amsiConext $AmsiContext -session $AmsiSession

    .NOTES

    AmsiCloseSession is a part of PSAmsi, a tool for auditing and defeating AMSI signatures.

    PSAmsi is located at https://github.com/cobbr/PSAmsi. Additional information can be found at https://cobbr.io.

    #>
    Param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [IntPtr] $amsiContext,

        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [IntPtr] $session
    )

    $HResult = $amsi::AmsiCloseSession($amsiContext, $session)
}