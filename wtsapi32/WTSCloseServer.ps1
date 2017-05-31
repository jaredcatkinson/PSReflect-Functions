function WTSCloseServer {
<#
.SYNOPSIS

Closes an open handle to a Remote Desktop Session Host (RD Session Host) server.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the WTSCloseServer Win32 API call to close a handle
opened up by WTSOpenServerEx.

.PARAMETER Handle

Handle to the RD session host to close.

.NOTES

(func wtsapi32 WTSCloseServer ([Int]) @(
    [IntPtr]    # _In_ HANDLE hServer
))

.EXAMPLE

.LINK

https://msdn.microsoft.com/en-us/library/aa383829(v=vs.85).aspx
#>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('hServer')]
        [ValidateNotNullOrEmpty()]
        [IntPtr]
        $Handle
    )

    PROCESS {
        $Wtsapi32::WTSCloseServer($Handle)
    }
}

$FunctionDefinitions = @(
    (func wtsapi32 WTSCloseServer ([Int]) @([IntPtr]))
)

$Module = New-InMemoryModule -ModuleName Win32
$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Wtsapi32 = $Types['wtsapi32']
