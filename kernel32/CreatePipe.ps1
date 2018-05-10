function CreatePipe
{
<#
    .SYNOPSIS

    Creates an anonymous pipe, and returns handles to the read and write ends of the pipe.

    .DESCRIPTION

    CreatePipe creates the pipe, assigning the specified pipe size to the storage buffer. CreatePipe also creates handles that the process uses to read from and write to the buffer in subsequent calls to the ReadFile and WriteFile functions.

    To read from the pipe, a process uses the read handle in a call to the ReadFile function. ReadFile returns when one of the following is true: a write operation completes on the write end of the pipe, the number of bytes requested has been read, or an error occurs.

    When a process uses WriteFile to write to an anonymous pipe, the write operation is not completed until all bytes are written. If the pipe buffer is full before all bytes are written, WriteFile does not return until another process or thread uses ReadFile to make more buffer space available.

    Anonymous pipes are implemented using a named pipe with a unique name. Therefore, you can often pass a handle to an anonymous pipe to a function that requires a handle to a named pipe.

    If CreatePipe fails, the contents of the output parameters are indeterminate. No assumptions should be made about their contents in this event.

    To free resources used by a pipe, the application should always close handles when they are no longer needed, which is accomplished either by calling the CloseHandle function or when the process associated with the instance handles ends. Note that an instance of a pipe may have more than one handle associated with it. An instance of a pipe is always deleted when the last handle to the instance of the named pipe is closed.

    .NOTES

    (func kernel32 CreatePipe ([bool]) @(
        [IntPtr].MakeByRefType(), #_Out_    PHANDLE               hReadPipe,
        [IntPtr].MakeByRefType(), #_Out_    PHANDLE               hWritePipe,
        [IntPtr],                 #_In_opt_ LPSECURITY_ATTRIBUTES lpPipeAttributes,
        [UInt32]                  #_In_     DWORD                 nSize
    ) -EntryPoint CreatePipe -SetLastError)

#>

    param
    (
        [Parameter()]
        [UInt32]
        $Size = 0
    )

    $hReadPipe = [IntPtr]::Zero
    $hWritePipe = [IntPtr]::Zero
    $lpPipeAttributes = [IntPtr]::Zero

    $SUCCESS = $kernel32::CreatePipe([ref]$hReadPipe, [ref]$hWritePipe, $lpPipeAttributes, $Size); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS)
    {
        throw "[CreatePipe] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    $props = @{
        ReadHandle = $hReadPipe
        WriteHandle = $hWritePipe
    }

    New-Object -TypeName psobject -Property $props
}