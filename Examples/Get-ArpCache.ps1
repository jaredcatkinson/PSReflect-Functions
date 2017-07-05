function Get-ArpCache
{
    <#
    .SYNOPSIS

    Retreives the IPv4 to physical address mapping table, otherwise known as the ARP Cache.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, GetIpNetTable (Function), MIB_IPNETROW (Structure), MIB_IPNET_TYPE (Enumeration)
    Optional Dependencies: None

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa365956%28v=vs.85%29.aspx?f=255&MSPPError=-2147217396

    .EXAMPLE

    Get-ArpCache

    AdapterIndex       : 5
    PhysicalAddress    : 01-00-5E-00-00-16
    IpAddress          : 224.0.0.22
    Type               : STATIC
    AdapterName        : Teredo Tunneling Pseudo-Interface
    AdapterType        : Tunnel
    AdapterDescription : Microsoft Teredo Tunneling Adapter
    AdapterMACAddress  :
    AdapterServiceName : tunnel

    AdapterIndex       : 1
    PhysicalAddress    : 00-00-00-00-00-00
    IpAddress          : 224.0.0.22
    Type               : STATIC
    AdapterName        : Intel(R) 82574L Gigabit Network Connection
    AdapterType        : Ethernet 802.3
    AdapterDescription : Intel(R) 82574L Gigabit Network Connection
    AdapterMACAddress  : 00:0C:29:3A:DF:39
    AdapterServiceName : e1iexpress

    AdapterIndex       : 1
    PhysicalAddress    : 00-00-00-00-00-00
    IpAddress          : 239.255.255.250
    Type               : STATIC
    AdapterName        : Intel(R) 82574L Gigabit Network Connection
    AdapterType        : Ethernet 802.3
    AdapterDescription : Intel(R) 82574L Gigabit Network Connection
    AdapterMACAddress  : 00:0C:29:3A:DF:39
    AdapterServiceName : e1iexpress

    AdapterIndex       : 4
    PhysicalAddress    : 01-00-5E-00-00-16
    IpAddress          : 224.0.0.22
    Type               : STATIC
    AdapterName        : Bluetooth PAN HelpText
    AdapterType        : Ethernet 802.3
    AdapterDescription : Bluetooth Device (Personal Area Network)
    AdapterMACAddress  : 78:4F:43:7F:F9:86
    AdapterServiceName : BthPan
    #>

    [CmdletBinding()]
    param
    (

    )

    $Cache = GetIpNetTable

    foreach($entry in $Cache)
    {
        $adapter = Get-WmiObject -Class win32_networkadapter -Filter "DeviceID = $($entry.AdapterIndex)"
        
        $entry | Add-Member -MemberType NoteProperty -Name AdapterName -Value $adapter.Name
        $entry | Add-Member -MemberType NoteProperty -Name AdapterType -Value $adapter.AdapterType
        $entry | Add-Member -MemberType NoteProperty -Name AdapterDescription -Value $adapter.Description
        $entry | Add-Member -MemberType NoteProperty -Name AdapterMACAddress -Value $adapter.MACAddress
        $entry | Add-Member -MemberType NoteProperty -Name AdapterServiceName -Value $adapter.ServiceName
        
        Write-Output $entry      
    }
}