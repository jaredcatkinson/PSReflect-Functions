function NetGetAnyDCName {
<#
.SYNOPSIS

Returns the name of any domain controller (DC) for a domain that is
directly trusted by the specified server

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the NetGetAnyDCName Win32API call to return any
domain controller the a domain/server specified.

.PARAMETER ComputerName

Specifies the hostname to query the DC for (also accepts IP addresses).

.PARAMETER DomainName

The domain the ComputerName resides in to enumerate a domain controller for.

.NOTES

    (func netapi32 NetGetAnyDCName ([Int]) @(
        [String],                   # _In_  LPCWSTR servername
        [String],                   # _In_  LPCWSTR domainname
        [IntPtr].MakeByRefType()    # _Out_ LPBYTE  *bufptr
    ) -EntryPoint NetGetAnyDCName)

    (func netapi32 NetApiBufferFree ([Int]) @(
        [IntPtr]    # _In_ LPVOID Buffer
    )

.EXAMPLE


.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa370419(v=vs.85).aspx
#>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [String]
        $ComputerName,

        [Parameter(Position = 1, ValueFromPipelineByPropertyName = $True)]
        [Alias('domain')]
        [ValidateNotNullOrEmpty()]
        [String]
        $DomainName
    )

    PROCESS {

        # if we get an IP address, try to resolve the IP to a hostname
        if ($Computer -match '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$') {
            $Computer = [System.Net.Dns]::GetHostByAddress($Computer) | Select-Object -ExpandProperty HostName
        }
        else {
            $Computer = $ComputerName
        }

        $PtrInfo = [IntPtr]::Zero

        $Result = $Netapi32::NetGetAnyDCName($Computer, $DomainName, [ref]$PtrInfo)

        if ($Result -eq 0) {
            [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($PtrInfo)
        }
        else {
            Throw "[NetGetAnyDCName] Error enumerating site for '$Computer' : $(([ComponentModel.Win32Exception]$Result).Message)"
        }

        $Null = $Netapi32::NetApiBufferFree($PtrInfo)
    }
}