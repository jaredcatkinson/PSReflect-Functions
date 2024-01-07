function WriteFile
{
    <#
    .SYNOPSIS

    Writes data to the specified file or input/output (I/O) device.

    .PARAMETER FileHandle

    A handle to the file or I/O device (for example, a file, file stream, physical disk, volume, console buffer, tape drive, socket, communications resource, mailslot, or pipe).

    .PARAMETER Buffer

    A byte array containing the data to be written to the file or device.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 WriteFile ([bool]) @(
        [IntPtr],                 # _In_        HANDLE       hFile
        [Byte[]],                 # _In_        LPCVOID      lpBuffer
        [UInt32],                 # _In_        DWORD        nNumberOfBytesToWrite
        [UInt32].MakeByRefType(), # _Out_opt_   LPDWORD      lpNumberOfBytesWritten
        [IntPtr]                  # _Inout_opt_ LPOVERLAPPED lpOverlapped
    ) -EntryPoint WriteFile -SetLastError)

    .LINK

    https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile

    .EXAMPLE
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [IntPtr]
        $FileHandle,

        [Parameter(Mandatory = $True)]
        [byte[]]
        $Buffer
    )

    [UInt32]$lpNumberOfBytesWritten = 0

    $SUCCESS = $kernel32::WriteFile($FileHandle, $Buffer, $Buffer.Length, [ref]$lpNumberOfBytesWritten, [IntPtr]::Zero); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($SUCCESS -eq 0)
    {
        throw "[WriteFile] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}