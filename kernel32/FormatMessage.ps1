function FormatMessage
{
    <#
    .SYNOPSIS

    Formats a message string and returns a string.

    .DESCRIPTION

    The function requires a message definition as input. The message definition can come from a buffer passed into the function. It can come from a message table resource in an already-loaded module. Or the caller can ask the function to search the system's message table resource(s) for the message definition. The function finds the message definition in a message table resource based on a message identifier and a language identifier. The function copies the formatted message text to an output buffer, processing any embedded insert sequences if requested.

    .PARAMETER FormatMessageFlags

    A FORMAT_MESSAGE_FLAGS enum containing the formatting options, and how to interpret the lpSource parameter. The low-order byte of dwFlags specifies how the function handles line breaks in the output buffer. The low-order byte can also specify the maximum width of a formatted output line.    
    
    .PARAMETER ResourceHandle

    A handle to the resource that is passed to lpSource parameter. Typically this is a handle to the message table from a call to LoadResource.

    .PARAMETER MessageId

    The message identifier for the requested message. 

    .PARAMETER LanguageId

    The language identifier for the requested message. 

    .NOTES

    Author: Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 FormatMessage ([UInt32]) @(
        [UInt32], #_In_     DWORD   dwFlags,
        [IntPtr], #_In_     LPCVOID lpSource,
        [UInt32], #_In_     DWORD dwMessageId,
        [UInt32], #_In_     DWORD dwLanguageId,
        [IntPtr], #_Out_    LPTSTR lpBuffer
        [UInt32], #_In_     DWORD nSize,
        [IntPtr]  #_Out_    va_list Arguments
    ) -EntryPoint FormatMessage -SetLastError),

    .LINK

    https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-formatmessage
    
    .EXAMPLE
    #>

    param
    (     
 
        [Parameter()]
        [ValidateSet('FORMAT_MESSAGE_ALLOCATE_BUFFER','FORMAT_MESSAGE_ARGUMENT_ARRAY','FORMAT_MESSAGE_FROM_HMODULE','FORMAT_MESSAGE_FROM_STRING','FORMAT_MESSAGE_FROM_SYSTEM', 'FORMAT_MESSAGE_IGNORE_INSERTS')]
        [string[]]
        $FormatMessageFlags = @('FORMAT_MESSAGE_ALLOCATE_BUFFER','FORMAT_MESSAGE_FROM_HMODULE','FORMAT_MESSAGE_IGNORE_INSERTS'),

        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ResourceHandle,

        [Parameter()]
        [UInt32]
        $MessageId = 0,

        [Parameter()]
        [UInt32]
        $LanguageId = 0
    )

    # https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-formatmessage

    # Calculate dwFlags
    [UInt32]$dwFlags = 0
    foreach($val in $FormatMessageFlags)
    {
        $dwFlags = $dwFlags -bor $FORMAT_MESSAGE_FLAGS::$val
    }

    [IntPtr]$MessagePtr = [IntPtr]::Zero
    [string]$Message = "" 
    $BytesReturned = $kernel32::FormatMessage(
        $dwFlags,
        $ResourceHandle,
        $MessageId,
        $LanguageId,
        $MessagePtr,
        0,
        [IntPtr]::Zero
        )
    $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($BytesReturned -eq 0)
    {
        throw "[FormatMessage]: Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    } else {
        $Message = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($MessagePtr)
        $Message.Replace("\r\n","")
    }

    Write-Output $Message
}