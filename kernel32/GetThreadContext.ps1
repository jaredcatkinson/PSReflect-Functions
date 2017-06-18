function GetThreadContext
{
    <#
    .SYNOPSIS

    Retrieves the context of the specified thread.

    .DESCRIPTION
    
    This function is used to retrieve the thread context of the specified thread. The function retrieves a selective context based on the value of the ContextFlags member of the context structure. The thread identified by the hThread parameter is typically being debugged, but the function can also operate when the thread is not being debugged.
    
    You cannot get a valid context for a running thread. Use the SuspendThread function to suspend the thread before calling GetThreadContext.
    
    If you call GetThreadContext for the current thread, the function returns successfully; however, the context returned is not valid.
    
    .PARAMETER ThreadHandle

    A handle to the thread whose context is to be retrieved. The handle must have THREAD_GET_CONTEXT access to the thread.
    
    WOW64:  The handle must also have THREAD_QUERY_INFORMATION access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: CONTEXT64 (Struct)
    Optional Dependencies: None

    (func kernel32 GetThreadContextx64 ([bool]) @(
        [IntPtr],                  #_In_    HANDLE    hThread
        $CONTEXT64.MakeByRefType() #_Inout_ LPCONTEXT lpContext
    ) -EntryPoint GetThreadContext -SetLastError)

    .LINK
    
    https://msdn.microsoft.com/en-us/library/windows/desktop/ms679362(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ThreadHandle
    )

    $Context = [Activator]::CreateInstance($CONTEXT64)

    $SUCCESS = $Kernel32::GetThreadContextx64($ThreadHandle, [ref]$Context); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($SUCCESS -eq 0) 
    {
        throw "GetThreadContext Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $Context
}