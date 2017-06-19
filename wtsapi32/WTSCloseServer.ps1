function WTSCloseServer {
    <#
    .SYNOPSIS

    Closes an open handle to a Remote Desktop Session Host (RD Session Host) server.

    .DESCRIPTION

    This function will execute the WTSCloseServer Win32 API call to close a handle
    opened up by WTSOpenServerEx.

    .PARAMETER Handle

    Handle to the RD session host to close.

    .NOTES

    Author: Will Schroeder (@harmj0y)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func wtsapi32 WTSCloseServer ([Int]) @(
        [IntPtr] # _In_ HANDLE hServer
    ) -EntryPoint WTSCloseServer)

    .LINK

    https://msdn.microsoft.com/en-us/library/aa383829(v=vs.85).aspx
    
    .EXAMPLE
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