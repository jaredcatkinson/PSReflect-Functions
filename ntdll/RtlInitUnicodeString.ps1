function RtlInitUnicodeString
{
    <#
    .SYNOPSIS

    Initializes a counted Unicode string.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, UNICODE_STRING (Structure)
    Optional Dependencies: None

    (func ntdll RtlInitUnicodeString ([void]) @(
        $UNICODE_STRING.MakeByRefType(), #_Inout_  PUNICODE_STRING DestinationString
        [string]                         #_In_opt_ PCWSTR          SourceString
    ) -EntryPoint RtlInitUnicodeString)

    .LINK

    https://msdn.microsoft.com/en-us/library/ms648420(v=vs.85).aspx

    .EXAMPLE
    #>

    [OutputType([IntPtr])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $SourceString
    )

    $DestinationString = [Activator]::CreateInstance($UNICODE_STRING)
    $Ntdll::RtlInitUnicodeString([ref]$DestinationString, $SourceString)

    Write-Output $DestinationString
}