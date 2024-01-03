function ReadFile
{
    <#
    .SYNOPSIS

    Reads data from the specified file or input/output (I/O) device. Reads occur at the position specified by the file pointer if supported by the device.

    .PARAMETER FileHandle

    A handle to the file or I/O device (for example, a file, file stream, physical disk, volume, console buffer, tape drive, socket, communications resource, mailslot, or pipe).

    .PARAMETER Size

    The maximum number of bytes to be read.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 ReadFile ([bool]) @(
        [IntPtr],                 # _In_        HANDLE       hFile
        [Byte[]],                 # _Out_       LPVOID       lpBuffer
        [UInt32],                 # _In_        DWORD        nNumberOfBytesToRead
        [UInt32].MakeByRefType(), # _Out_opt_   LPDWORD      lpNumberOfBytesRead
        [IntPtr]                  # _Inout_opt_ LPOVERLAPPED lpOverlapped
    ) -EntryPoint ReadFile -SetLastError)

    .LINK

    https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-readfile

    .EXAMPLE
    #>


    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [IntPtr]
        $FileHandle,

        [Parameter(Mandatory = $True)]
        [UInt32]
        $Size
    )

    $lpBuffer = New-Object byte[]($NumberOfBytesToRead)
    [UInt32]$lpNumberOfBytesRead = 0

    $SUCCESS = $kernel32::ReadFile($FileHandle, $lpBuffer, $NumberOfBytesToRead, [ref]$lpNumberOfBytesRead, [IntPtr]::Zero); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($SUCCESS -eq 0)
    {
        throw "[ReadFile] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $lpBuffer
}