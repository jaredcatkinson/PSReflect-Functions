function SamCloseHandle
{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER SamHandle

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func samlib SamCloseHandle ([Int32]) @(
        [IntPtr] #_In_ SAM_HANDLE SamHandle
    ) -EntryPoint SamCloseHandle)

    .LINK

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