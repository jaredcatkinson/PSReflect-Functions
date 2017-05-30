function OpenProcessToken
{ 
    <#
    .SYNOPSIS

    The OpenProcessToken function opens the access token associated with a process.

    .PARAMETER ProcessHandle

    A handle to the process whose access token is opened. The process must have the PROCESS_QUERY_INFORMATION access permission.

    .PARAMETER DesiredAccess

    Specifies an access mask that specifies the requested types of access to the access token. These requested access types are compared with the discretionary access control list (DACL) of the token to determine which accesses are granted or denied.
    For a list of access rights for access tokens, see Access Rights for Access-Token Objects.

    .NOTES
    
    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func advapi32 OpenProcessToken ([bool]) @(
      [IntPtr],                #_In_  HANDLE  ProcessHandle
      [UInt32],                #_In_  DWORD   DesiredAccess
      [IntPtr].MakeByRefType() #_Out_ PHANDLE TokenHandle
    ) -EntryPoint OpenProcessToken -SetLastError)
        
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa379295(v=vs.85).aspx
    
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa374905(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ProcessHandle,
        
        [Parameter(Mandatory = $true)]
        [UInt32]
        $DesiredAccess  
    )
    
    $hToken = [IntPtr]::Zero
    $Success = $Advapi32::OpenProcessToken($ProcessHandle, $DesiredAccess, [ref]$hToken); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $Success) 
    {
        Write-Debug "OpenProcessToken Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
    
    Write-Output $hToken
}