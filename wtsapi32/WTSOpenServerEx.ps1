function WTSOpenServerEx {
<#
.SYNOPSIS

Opens a handle to the specified Remote Desktop Session Host (RD Session Host)
server or Remote Desktop Virtualization Host (RD Virtualization Host) server

Note: only members of the Administrators or Account Operators local group
can successfully execute this functionality on a remote target.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the WTSOpenServerEx Win32 API call to open up a handle
to the Remote Desktop Session Host.

.PARAMETER ComputerName

Specifies the hostname to open the handle to (also accepts IP addresses).
Defaults to 'localhost'.

.NOTES

(func wtsapi32 WTSOpenServerEx ([IntPtr]) @(
    [String]        # _In_ LPTSTR pServerName
))

.OUTPUTS

IntPtr

A handle to the specified server.

.EXAMPLE

.LINK

https://msdn.microsoft.com/en-us/library/ee621021(v=vs.85).aspx
#>

    [OutputType([IntPtr])]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = 'localhost'
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {
            # open up a handle to the Remote Desktop Session host
            $Wtsapi32::WTSOpenServerEx($Computer)
        }
    }
}