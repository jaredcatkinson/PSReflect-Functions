function QueryFullProcessImageName
{
    <#
    .SYNOPSIS

    Retrieves the full name of the executable image for the specified process.

    .PARAMETER ProcessHandle

    A handle to the process. This handle must be created with the PROCESS_QUERY_INFORMATION or PROCESS_QUERY_LIMITED_INFORMATION access right.

    .PARAMETER Flags

    This parameter can be one of the following values.
    0x00 - The name should use the Win32 path format.
    0x01 - The name should use the native system path format.

    .NOTES
    
    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 QueryFullProcessImageName ([bool]) @(
      [IntPtr]                    #_In_    HANDLE hProcess
      [UInt32]                    #_In_    DWORD  dwFlags,
      [System.Text.StringBuilder] #_Out_   LPTSTR lpExeName,
      [UInt32].MakeByRefType()    #_Inout_ PDWORD lpdwSize
    ) -EntryPoint QueryFullProcessImageName -SetLastError)
        
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms684919(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ProcessHandle,
        
        [Parameter()]
        [UInt32]
        $Flags = 0
    )
    
    $capacity = 2048
    $sb = New-Object -TypeName System.Text.StringBuilder($capacity)

    $Success = $Kernel32::QueryFullProcessImageName($ProcessHandle, $Flags, $sb, [ref]$capacity); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $Success) 
    {
        Write-Debug "QueryFullProcessImageName Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
    
    Write-Output $sb.ToString()
}