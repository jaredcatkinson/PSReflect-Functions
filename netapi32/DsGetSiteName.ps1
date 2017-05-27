function DsGetSiteName {
<#
.SYNOPSIS

Returns the AD site where the local (or a remote) machine resides.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the DsGetSiteName Win32API call to look up the
name of the site where a specified computer resides.

.PARAMETER ComputerName

Specifies the hostname to query the site for (also accepts IP addresses).
Defaults to the local host name.

.NOTES

    (func netapi32 DsGetSiteName ([Int]) @(
        [String],                   # _In_  LPCTSTR ComputerName
        [IntPtr].MakeByRefType())   # _Out_ LPTSTR  *SiteName
    )

    (func netapi32 NetApiBufferFree ([Int]) @(
        [IntPtr]    # _In_ LPVOID Buffer
    )

.EXAMPLE


.LINK

https://msdn.microsoft.com/en-us/library/ms675992(v=vs.85).aspx
#>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = $ENV:ComputerName
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {

            # if we get an IP address, try to resolve the IP to a hostname
            if ($Computer -match '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$') {
                $Computer = [System.Net.Dns]::GetHostByAddress($Computer) | Select-Object -ExpandProperty HostName
            }

            $PtrInfo = [IntPtr]::Zero

            $Result = $Netapi32::DsGetSiteName($Computer, [ref]$PtrInfo)

            if ($Result -eq 0) {
                [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($PtrInfo)
            }
            else {
                Throw "[DsGetSiteName] Error enumerating site for '$Computer' : $(([ComponentModel.Win32Exception]$Result).Message)"
            }

            $Null = $Netapi32::NetApiBufferFree($PtrInfo)
        }
    }
}


$FunctionDefinitions = @(
    (func netapi32 DsGetSiteName ([Int]) @([String], [IntPtr].MakeByRefType())),
    (func netapi32 NetApiBufferFree ([Int]) @([IntPtr]))
)

$Module = New-InMemoryModule -ModuleName Win32
$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Netapi32 = $Types['netapi32']
