function Thread32First
{
    <#
    .SYNOPSIS

    Retrieves information about the first thread of any process encountered in a system snapshot.

    .PARAMETER SnapshotHandle

    A handle to the snapshot returned from a previous call to the CreateToolhelp32Snapshot function.

    .NOTES
    
    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 Thread32First ([bool]) @(
        [IntPtr],                      #_In_    HANDLE          hSnapshot
        $THREADENTRY32.MakeByRefType() #_Inout_ LPTHREADENTRY32 lpte
    ) -EntryPoint Thread32First -SetLastError)
        
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms686728(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $SnapshotHandle
    )
        
    $Thread = [Activator]::CreateInstance($THREADENTRY32)
    $Thread.dwSize = $THREADENTRY32::GetSize()

    $Success = $Kernel32::Thread32First($hSnapshot, [Ref]$Thread); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $Success) 
    {
        Write-Debug "Thread32First Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
    
    Write-Output $Thread
}