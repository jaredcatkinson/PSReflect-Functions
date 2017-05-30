function OpenThread
{
    <#
    .SYNOPSIS

    Opens an existing thread object.

    .DESCRIPTION

    The handle returned by OpenThread can be used in any function that requires a handle to a thread, such as the wait functions, provided you requested the appropriate access rights. The handle is granted access to the thread object only to the extent it was specified in the dwDesiredAccess parameter.
    When you are finished with the handle, be sure to close it by using the CloseHandle function.

    .PARAMETER ThreadId

    The identifier of the thread to be opened.

    .PARAMETER DesiredAccess

    The access to the thread object. This access right is checked against the security descriptor for the thread. This parameter can be one or more of the thread access rights.
    If the caller has enabled the SeDebugPrivilege privilege, the requested access is granted regardless of the contents of the security descriptor.

    .PARAMETER InheritHandle

    If this value is TRUE, processes created by this process will inherit the handle. Otherwise, the processes do not inherit this handle.
    
    .NOTES
    
    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func kernel32 OpenThread ([IntPtr]) @(
        [UInt32], #_In_ DWORD dwDesiredAccess
        [bool],   #_In_ BOOL  bInheritHandle
        [UInt32]  #_In_ DWORD dwThreadId
    ) -EntryPoint OpenThread -SetLastError)
        
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms684335(v=vs.85).aspx
    
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms686769(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [UInt32]
        $ThreadId,
        
        [Parameter(Mandatory = $true)]
        [UInt32]
        $DesiredAccess,
        
        [Parameter()]
        [bool]
        $InheritHandle = $false
    )
    
    $hThread = $Kernel32::OpenThread($DesiredAccess, $InheritHandle, $ThreadId); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($hThread -eq 0) 
    {
        Write-Debug "OpenThread Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
    
    Write-Output $hThread
}