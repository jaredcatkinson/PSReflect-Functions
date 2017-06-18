function CreateToolhelp32Snapshot
{
    <#
    .SYNOPSIS

    Takes a snapshot of the specified processes, as well as the heaps, modules, and threads used by these processes.

    .DESCRIPTION

    .PARAMETER ProcessId

    .PARAMETER Flags
    
    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func kernel32 CreateToolhelp32Snapshot ([IntPtr]) @(
        [UInt32],                                 #_In_ DWORD dwFlags,
        [UInt32]                                  #_In_ DWORD th32ProcessID
    ) -EntryPoint CreateToolhelp32Snapshot -SetLastError)
        
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [UInt32]
        $ProcessId,
        
        [Parameter(Mandatory = $true)]
        [UInt32]
        $Flags
    )
    
    $hSnapshot = $Kernel32::CreateToolhelp32Snapshot($Flags, $ProcessId); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $hSnapshot) 
    {
        Write-Debug "CreateToolhelp32Snapshot Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
    
    Write-Output $hSnapshot
}