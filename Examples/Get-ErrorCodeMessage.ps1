function Get-ErrorCodeMessage 
{
    <#
    .SYNOPSIS

    Retrieve the message associated with the provided system error code.

    .DESCRIPTION

    Uses the FormatMessage API to retrieve the built-in system error code. System Error Codes are meant to be used across different applications in the operating system, and can be very generic. They are defined in the WinError.h header file.
    
    The Windows system error codes have identifiers from 0-16000. If your identifier is longer than this, you may have an HRESULT, NTSTATUS, or another kind of error code.

    .PARAMETER Code

    The numeric identifier for an error code, specified as a decimal integer (e.g. 53).

    .NOTES

    Author: Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    .LINK
    https://docs.microsoft.com/en-us/windows/win32/debug/system-error-codes

    .EXAMPLE
    Get-ErrorCodeMessage -Code 53
    The network path was not found.

    .EXAMPLE
    Get-ErrorCodeMessage -Code 0x51F
    There are currently no logon servers available to service the logon request.
   
    #>

    [CmdletBinding(DefaultParameterSetName='Code')]
    param
    (
        [uint32]
        [Parameter( Position=0, Mandatory=$true)]
        $Code,

        [uint32]
        $LanguageId = 0x00
    )

    $FormatMessageFlags = @('FORMAT_MESSAGE_FROM_SYSTEM', 'FORMAT_MESSAGE_ALLOCATE_BUFFER', 'FORMAT_MESSAGE_IGNORE_INSERTS')
    $hModule = [IntPtr]::Zero
    $Message = ""
    $Message = FormatMessage -FormatMessageFlags $FormatMessageFlags -MessageId $Code -LanguageId $LanguageId -ResourceHandle $hModule
    Write-Output $Message
}