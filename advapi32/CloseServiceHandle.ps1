function CloseServiceHandle
{
<#
.SYNOPSIS

Closes a handle to a service control manager or service object.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect  

.DESCRIPTION

Closes a handle to a service control manager or service object using the
CloseServiceHandle Win32 API call.

.PARAMETER Handle

Handle to the service control manager object or the service object to close.

.NOTES

(func advapi32 CloseServiceHandle ([Int]) @(
    [IntPtr]        # _In_ SC_HANDLE hSCObject
))

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


$FunctionDefinitions = @(
    (func advapi32 CloseServiceHandle ([Int]) @([IntPtr]))
)

$Module = New-InMemoryModule -ModuleName Win32
$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Advapi32 = $Types['advapi32']
