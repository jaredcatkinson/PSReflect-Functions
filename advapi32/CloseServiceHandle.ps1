function CloseServiceHandle
{
    <#
    .SYNOPSIS

    Closes a handle to a service control manager or service object. 

    .DESCRIPTION

    Closes a handle to a service control manager or service object using the
    CloseServiceHandle Win32 API call.

    .PARAMETER Handle

    Handle to the service control manager object or the service object to close.

    .NOTES

    Author: Will Schroeder (@harmj0y)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect 
    Optional Dependencies: None

    (func advapi32 CloseServiceHandle ([Int]) @(
        [IntPtr] # _In_ SC_HANDLE hSCObject
    ) -EntryPoint CloseServiceHandle)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms682028(v=vs.85).aspx

    .EXAMPLE

    #>
    
    [OutputType([IntPtr])]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('hSCObject')]
        [ValidateNotNullOrEmpty()]
        [IntPtr]
        $Handle
    )

    $Result = $Advapi32::CloseServiceHandle($Handle);$LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if ($Result -ne 0) {
        Write-Verbose "[CloseServiceHandle] Success in closing service handle '$Handle'"
    }
    else {
        throw "[CloseServiceHandle] CloseServiceHandle() Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}