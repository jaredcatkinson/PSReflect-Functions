function CreateToolhelp32Snapshot
{
    <#
    .SYNOPSIS

    Takes a snapshot of the specified processes, as well as the heaps, modules, and threads used by these processes.

    .DESCRIPTION

    The snapshot taken by this function is examined by the other tool help functions to provide their results. Access to the snapshot is read only. The snapshot handle acts as an object handle and is subject to the same rules regarding which processes and threads it is valid in.

    To enumerate the heap or module states for all processes, specify TH32CS_SNAPALL and set th32ProcessID to zero. Then, for each additional process in the snapshot, call CreateToolhelp32Snapshot again, specifying its process identifier and the TH32CS_SNAPHEAPLIST or TH32_SNAPMODULE value.

    When taking snapshots that include heaps and modules for a process other than the current process, the CreateToolhelp32Snapshot function can fail or return incorrect information for a variety of reasons. For example, if the loader data table in the target process is corrupted or not initialized, or if the module list changes during the function call as a result of DLLs being loaded or unloaded, the function might fail with ERROR_BAD_LENGTH or other error code. Ensure that the target process was not started in a suspended state, and try calling the function again. If the function fails with ERROR_BAD_LENGTH when called with TH32CS_SNAPMODULE or TH32CS_SNAPMODULE32, call the function again until it succeeds.

    The TH32CS_SNAPMODULE and TH32CS_SNAPMODULE32 flags do not retrieve handles for modules that were loaded with the LOAD_LIBRARY_AS_DATAFILE or similar flags. For more information, see LoadLibraryEx.

    To destroy the snapshot, use the CloseHandle function.

    Note that you can use the QueryFullProcessImageName function to retrieve the full name of an executable image for both 32- and 64-bit processes from a 32-bit process.

    .PARAMETER ProcessId

    The process identifier of the process to be included in the snapshot. This parameter can be zero to indicate the current process. This parameter is used when the TH32CS_SNAPHEAPLIST, TH32CS_SNAPMODULE, TH32CS_SNAPMODULE32, or TH32CS_SNAPALL value is specified. Otherwise, it is ignored and all processes are included in the snapshot.
    
    If the specified process is the Idle process or one of the CSRSS processes, this function fails and the last error code is ERROR_ACCESS_DENIED because their access restrictions prevent user-level code from opening them.
    
    If the specified process is a 64-bit process and the caller is a 32-bit process, this function fails and the last error code is ERROR_PARTIAL_COPY (299).

    .PARAMETER Flags
    
    The portions of the system to be included in the snapshot.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: TH32CS (Enumeration)

    (func kernel32 CreateToolhelp32Snapshot ([IntPtr]) @(
        [UInt32], #_In_ DWORD dwFlags,
        [UInt32]  #_In_ DWORD th32ProcessID
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