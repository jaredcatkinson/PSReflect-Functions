function CreateRemoteThread
{
    <#
    .SYNOPSIS

    Creates a thread that runs in the virtual address space of another process.

    Use the CreateRemoteThreadEx function to create a thread that runs in the virtual address space of another process and optionally specify extended attributes.

    .PARAMETER ProcessHandle

    A handle to the process in which the thread is to be created. The handle must have the PROCESS_CREATE_THREAD, PROCESS_QUERY_INFORMATION, PROCESS_VM_OPERATION, PROCESS_VM_WRITE, and PROCESS_VM_READ access rights, and may fail without these rights on certain platforms.

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

    (func kernel32 CreateRemoteThread ([IntPtr]) @(
        [IntPtr],                #_In_  HANDLE                 hProcess
        [UInt32],                #_In_  LPSECURITY_ATTRIBUTES  lpThreadAttributes
        [UInt32],                #_In_  SIZE_T                 dwStackSize
        [IntPtr],                #_In_  LPTHREAD_START_ROUTINE lpStartAddress
        [IntPtr],                #_In_  LPVOID                 lpParameter
        [UInt32],                #_In_  DWORD                  dwCreationFlags
        [UInt32].MakeByRefType() #_Out_ LPDWORD                lpThreadId
    ) -EntryPoint CreateRemoteThread -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms682437(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ProcessHandle,

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
    
    $SUCCESS = $Kernel32::CreateRemoteThread($ProcessHandle, 0, $StackSize, $StartAddress, [IntPtr]::Zero, 4, [ref]$ThreadId); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        Write-Error "[CreateRemoteThread] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    $props = @{
        Handle = $SUCCESS
        Id = $ThreadId
    }

    New-Object -TypeName psobject -Property $props
}