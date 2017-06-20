function SamCloseHandle
{
    <#
    .SYNOPSIS

    Closes a Sam Handle returned from the SamConnect function.

    .PARAMETER SamHandle

    A handle to the SAM database.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func samlib SamCloseHandle ([Int32]) @(
        [IntPtr] #_In_ SAM_HANDLE SamHandle
    ) -EntryPoint SamCloseHandle)

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $SamHandle
    )

    $SUCCESS = $samlib::SamCloseHandle($SamHandle)

    if($SUCCESS -ne 0)
    {
        throw "[SamCloseHandle] error: $($SUCCESS)"
    }
}