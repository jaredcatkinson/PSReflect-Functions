function Format-Message 
{
    <#

    .SYNOPSIS

    .DESCRIPTION

    .NOTES

    Author: Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    .LINK

    .EXAMPLE

    Format-Message

    #>

    [CmdletBinding()]
    param
    (

    )
    $hModule = LoadLibrary("C:\WINDOWS\system32\msobjs.dll")
    $MessageId = 1537
    FormatMessage($hModule, $MessageId)
}