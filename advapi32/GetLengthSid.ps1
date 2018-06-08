function GetLengthSid
{
    <#
    .SYNOPSIS

    The GetLengthSid function returns the length, in bytes, of a valid security identifier (SID).

    .DESCRIPTION

    .PARAMETER SidPointer

    A pointer to the SID structure whose length is returned. The structure is assumed to be valid.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: N/A

    (func advapi32 GetLengthSid ([UInt32]) @(
        [IntPtr] #_In_ PSID pSid
    ) -EntryPoint GetLengthSid)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa446642(v=vs.85).aspx
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $SidPointer
    )

    $SUCCESS = $Advapi32::GetLengthSid($SidPointer)
    if(-not $SUCCESS)
    {
        throw "[GetLengthSid] Error:"
    }

    Write-Output $Success
}