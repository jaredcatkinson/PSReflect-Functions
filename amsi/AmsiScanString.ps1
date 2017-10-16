function AmsiScanString {
    <#

    .SYNOPSIS

    Submits a string to the AMSI to be scanned by the AntiMalware Provider.

    Author: Ryan Cobb (@cobbr_io)
    License: GNU GPLv3
    Required Dependecies: PSReflect, amsi
    Optional Dependencies: none

    .DESCRIPTION

    AmsiScanString submits a string to to the AMSI to be scanned by the AntiMalware provider by calling
    the function described here: https://msdn.microsoft.com/en-us/library/windows/desktop/dn889866(v=vs.85).aspx

    .PARAMETER amsiContext

    A pointer to the AmsiContext this scan is associated with.

    .PARAMETER string

    The string to be scanned for malware.

    .PARAMETER contentName

    The name of the content to be scanned.

    .PARAMETER session

    A pointer to the AmsiSession this scan is a part of.

    .PARAMETER result

    A reference to the result of the scan that will be set by this function.

    .OUTPUTS

    Int

    .EXAMPLE

    $AmsiResult = $AMSI_RESULT::AMSI_RESULT_NOT_DETECTED
    AmsiScanString $AmsiContext $ScriptString $ContentName $AmsiSession -result ([ref]$AmsiResult)

    .NOTES

    AmsiScanString is a part of PSAmsi, a tool for auditing and defeating AMSI signatures.

    PSAmsi is located at https://github.com/cobbr/PSAmsi. Additional information can be found at https://cobbr.io.

    #>
    Param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [IntPtr] $amsiContext,

        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $string,

        [Parameter(Position = 2, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $contentName,

        [Parameter(Position = 3, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [IntPtr] $session,

        [Parameter(Position = 4, Mandatory)]
        [ref] $result
    )

    $HResult = $amsi::AmsiScanString($amsiContext, $string, $contentName, $session, $result)

    If ($HResult -ne 0) {
        throw "AmsiScanString Error: $($HResult)"
    }

    $HResult
}