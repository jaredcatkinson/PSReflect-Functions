function CreateThread
{
    <#
    .SYNOPSIS

    Creates a thread to execute within the virtual address space of the calling process.

    .DESCRIPTION

    The number of threads a process can create is limited by the available virtual memory. By default, every thread has one megabyte of stack space. Therefore, you can create at most 2,048 threads. If you reduce the default stack size, you can create more threads. However, your application will have better performance if you create one thread per processor and build queues of requests for which the application maintains the context information. A thread would process all requests in a queue before processing requests in the next queue.

    The new thread handle is created with the THREAD_ALL_ACCESS access right. If a security descriptor is not provided when the thread is created, a default security descriptor is constructed for the new thread using the primary token of the process that is creating the thread. When a caller attempts to access the thread with the OpenThread function, the effective token of the caller is evaluated against this security descriptor to grant or deny access.

    .PARAMETER StartAddress

    A pointer to the application-defined function of type LPTHREAD_START_ROUTINE to be executed by the thread and represents the starting address of the thread in the remote process. The function must exist in the remote process.

    .PARAMETER StackSize

    The initial size of the stack, in bytes. The system rounds this value to the nearest page. If this parameter is 0 (zero), the new thread uses the default size for the executable.

    .PARAMETER CreationFlags

    The flags that control the creation of the thread.
    None - The flags that control the creation of the thread.
    CREATE_SUSPENDED - The thread is created in a suspended state, and does not run until the ResumeThread function is called.
    STACK_SIZE_PARAM_IS_A_RESERVATION - The StackSize parameter specifies the initial reserve size of the stack. If this flag is not specified, StackSize specifies the commit size.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func kernel32 CreateThread ([IntPtr]) @(
        [UInt32],                #_In_opt_  LPSECURITY_ATTRIBUTES  lpThreadAttributes
        [UInt32],                #_In_      SIZE_T                 dwStackSize
        [IntPtr],                #_In_      LPTHREAD_START_ROUTINE lpStartAddress
        [IntPtr],                #_In_opt_  LPVOID                 lpParameter
        [UInt32],                #_In_      DWORD                  dwCreationFlags
        [UInt32].MakeByRefType() #_Out_opt_ LPDWORD                lpThreadId
    ) -EntryPoint CreateThread -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms682453(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $StartAddress,
        
        [Parameter()]
        [UInt32]
        $StackSize = 0,
        
        [Parameter()]
        [ValidateSet('None','CREATE_SUSPENDED','STACK_SIZE_PARAM_IS_A_RESERVATION')]
        [string[]]
        $CreationFlags = 'None'
    )
    
    $ThreadId = 0
    
    $SUCCESS = $Kernel32::CreateThread(0, $StackSize, $StartAddress, [IntPtr]::Zero, 4, [ref]$ThreadId); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        Write-Error "[CreateThread] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    $props = @{
        Handle = $SUCCESS
        Id = $ThreadId
    }

    New-Object -TypeName psobject -Property $props
}