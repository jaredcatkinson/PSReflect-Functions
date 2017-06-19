function LsaNtStatusToWinError
{
    <#
    .SYNOPSIS

    The LsaNtStatusToWinError function converts an NTSTATUS code returned by an LSA function to a Windows error code.

    .PARAMETER NtStatus

    An NTSTATUS code returned by an LSA function call. This value will be converted to a System error code.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func advapi32 LsaNtStatusToWinError ([UInt64]) @(
        [UInt32] #_In_ NTSTATUS Status
    ) -EntryPoint LsaNtStatusToWinError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms721800(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [UInt32]
        $NtStatus
    )

    $STATUS = $Advapi32::LsaNtStatusToWinError($NtStatus)

    Write-Output $STATUS
}