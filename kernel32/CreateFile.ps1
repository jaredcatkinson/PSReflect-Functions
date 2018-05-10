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
        [ValidateSet('QueryDeviceOnly','SPECIFIC_RIGHTS_ALL','DELETE','READ_CONTROL','STANDARD_RIGHTS_READ','STANDARD_RIGHTS_WRITE','STANDARD_RIGHTS_EXECUTE','WRITE_DAC','WRITE_OWNER','STANDARD_RIGHTS_REQUIRED','SYNCHRONIZE','STANDARD_RIGHTS_ALL','ACCESS_SYSTEM_SECURITY','MAXIMUM_ALLOWED','GENERIC_ALL','GENERIC_EXECUTE','GENERIC_WRITE','GENERIC_READ')]
        [string[]]
        $DesiredAccess,

        [Parameter()]
        [ValidateSet('NONE','READ','WRITE','DELETE')]
        [string[]]
        $ShareMode = 'NONE',

        [Parameter()]
        [IntPtr]
        $SecurityAttributes = [IntPtr]::Zero,

        [Parameter()]
        [ValidateSet('CREATE_NEW','CREATE_ALWAYS','OPEN_EXISTING','OPEN_ALWAYS','TRUNCATE_EXISTING')]
        [string]
        $CreationDisposition = 'OPEN_EXISTING',

        [Parameter()]
        [ValidateSet('NONE','FILE_ATTRIBUTE_READONLY','FILE_ATTRIBUTE_HIDDEN','FILE_ATTRIBUTE_SYSTEM','FILE_ATTRIBUTE_ARCHIVE','FILE_ATTRIBUTE_NORMAL','FILE_ATTRIBUTE_TEMPORARY','FILE_ATTRIBUTE_OFFLINE','FILE_ATTRIBUTE_ENCRYPTED','FILE_FLAG_OPEN_NO_RECALL','FILE_FLAG_POSIX_SEMANTICS','FILE_FLAG_OPEN_REPARSE_POINT','FILE_FLAG_SESSION_AWARE','FILE_FLAG_BACKUP_SEMANTICS','FILE_FLAG_DELETE_ON_CLOSE','FILE_FLAG_SEQUENTIAL_SCAN','FILE_FLAG_RANDOM_ACCESS','FILE_FLAG_NO_BUFFERING','FILE_FLAG_OVERLAPPED','FILE_FLAG_WRITE_THROUGH')]
        [string[]]
        $FlagsAndAttributes = 'FILE_ATTRIBUTE_NORMAL',

        [Parameter()]
        [IntPtr]
        $TemplateHandle = [IntPtr]::Zero
    )

    # Calculate dwDesiredAccess
    [UInt32]$dwDesiredAccess = 0

    foreach($val in $DesiredAccess)
    {
        $dwDesiredAccess = $dwDesiredAccess -bor $FILE_ACCESS::$val
    }

    # Calculate dwShareMode Value
    [UInt32]$dwShareMode = 0

    foreach($val in $ShareMode)
    {
        $dwShareMode = $dwShareMode -bor $FILE_SHARE::$val
    }

    # Calculate dwFlagsAndAttributes Value
    [UInt32]$dwFlagsAndAttributes = 0

    foreach($val in $FlagsAndAttributes)
    {
        $dwFlagsAndAttributes = $dwFlagsAndAttributes -bor $FILE_FLAGS_AND_ATTRIBUTES::$val
    }

    $hFile = $kernel32::CreateFile($FileName, $dwDesiredAccess, $dwShareMode, $SecurityAttributes, $CREATION_DISPOSITION::$CreationDisposition, $dwFlagsAndAttributes, $TemplateHandle); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($hFile -eq -1)
    {
        throw "[CreateFile] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $hFile
}