function CreateFile
{
    <#
    .SYNOPSIS

    Creates or opens a file or I/O device. The most commonly used I/O devices are as follows: file, file stream, directory, physical disk, volume, console buffer, tape drive, communications resource, mailslot, and pipe. The function returns a handle that can be used to access the file or device for various types of I/O depending on the file or device and the flags and attributes specified.
    
    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func kernel32 CreateFile ([IntPtr]) @(
        [string], #_In_     LPCTSTR               lpFileName
        [UInt32], #_In_     DWORD                 dwDesiredAccess
        [UInt32], #_In_     DWORD                 dwShareMode
        [IntPtr], #_In_opt_ LPSECURITY_ATTRIBUTES lpSecurityAttributes
        [UInt32], #_In_     DWORD                 dwCreationDisposition
        [UInt32], #_In_     DWORD                 dwFlagsAndAttributes
        [IntPtr]  #_In_opt_ HANDLE                hTemplateFile
    ) -EntryPoint CreateFile -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa363858(v=vs.85).aspx

    .EXAMPLE
    #>
    
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $FileName,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $DesiredAccess,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $ShareMode,

        [Parameter(Mandatory = $true)]
        [IntPtr]
        $SecurityAttributes = [IntPtr]::Zero,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $CreationDisposition,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $FlagsAndAttributes,

        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TemplateHandle = [IntPtr]::Zero
    )

    $hFile = $kernel32::CreateFile($FileName, $DesiredAccess, $ShareMode, $SecurityAttributes, $CreationDisposition, $FlagsAndAttributes, $TemplateHandle); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($hFile -eq $null) 
    {
        throw "[CreateFile] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $hFile
}