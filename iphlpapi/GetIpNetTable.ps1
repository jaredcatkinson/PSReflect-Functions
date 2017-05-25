function GetIpNetTable
{
    <#
    .SYNOPSIS

    Retreives the IPv4 to physical address mapping table.

    .DESCRIPTION

    The GetIpNetTable function enumerates the Address Resolution Protocol (ARP) entries for IPv4 on a local system from the IPv4 to physical address mapping table and returns this information in a MIB_IPNETTABLE structure.

    on Windows Vista and later, the GetIpNetTable2 function can be used to retrieve the neighbor IP addresses for both IPv6 and IPv4.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: MIB_IPNETROW (Struct), MIB_IPNET_TYPE (Enum)
    Optional Dependencies: None
    
    (func iphlpapi GetIpNetTable ([Int32]) @(
        [IntPtr],                 #_Out_   PMIB_IPNETTABLE pIpNetTable
        [Int32].MakeByRefType(),  #_Inout_ PULONG          pdwSize
        [bool]                    #_In_    BOOL            bOrder
    ))

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa365956%28v=vs.85%29.aspx?f=255&MSPPError=-2147217396

    .EXAMPLE

    GetIpNetTable

    AdapterIndex PhysicalAddress   IpAddress          Type
    ------------ ---------------   ---------          ----
              14 00-50-56-C0-00-08 192.168.1.1      DYNAMIC
              14 00-50-56-F8-64-30 192.168.1.2      DYNAMIC
              14 00-0C-29-BB-51-6D 192.168.1.137    DYNAMIC
              14 00-00-00-00-00-00 192.168.1.254    INVALID
              14 FF-FF-FF-FF-FF-FF 192.168.1.255    STATIC
              14 01-00-5E-00-00-16 224.0.0.22       STATIC
              14 01-00-5E-00-00-FC 224.0.0.252      STATIC
              14 01-00-5E-7F-FF-FA 239.255.255.250  STATIC
              14 FF-FF-FF-FF-FF-FF 255.255.255.255  STATIC
               1 00-00-00-00-00-00 224.0.0.22       STATIC
               1 00-00-00-00-00-00 224.0.0.252      STATIC
               1 00-00-00-00-00-00 239.255.255.250  STATIC
              11 01-00-5E-00-00-16 224.0.0.22       STATIC
              10 01-00-5E-00-00-16 224.0.0.22       STATIC
    #>

    $pThrowAway = [IntPtr]::Zero
    $dwSize = [Int32]0

    # Run the function once to get the size of the MIB_NETTABLE Structure
    $SUCCESS = $iphlpapi::GetIpNetTable($pThrowAway, [ref]$dwSize, $false)
    
    # ERROR_INSUFFICIENT_BUFFER means that $dwSize now contains the size of the stucture
    if($SUCCESS -eq 122)
    {
        $pIpNetTable = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($dwSize)
        $SUCCESS = $iphlpapi::GetIpNetTable($pIpNetTable, [ref]$dwSize, $false)
        
        if($SUCCESS -eq 0)
        {
            $count = [System.Runtime.InteropServices.Marshal]::ReadInt32($pIpNetTable)

            for($i = 0; $i -lt $count; $i++)
            {
                $CurrentPtr = [IntPtr]($pIpNetTable.ToInt64() + 4 + ($i * 24))
                $IpNetRow = $CurrentPtr -as $MIB_IPNETROW
    
                $obj = New-Object -TypeName psobject
                $obj | Add-Member -MemberType NoteProperty -Name AdapterIndex -Value $IpNetRow.dwIndex
                $obj | Add-Member -MemberType NoteProperty -Name PhysicalAddress -Value ([PhysicalAddress]::new($IpNetRow.bPhysAddr).ToString().Insert(2, '-').Insert(5, '-').Insert(8, '-').Insert(11, '-').Insert(14, '-'))
                $obj | Add-Member -MemberType NoteProperty -Name IpAddress -Value ([ipaddress]::new($IpNetRow.dwAddr).IPAddressToString)
                $obj | Add-Member -MemberType NoteProperty -Name Type -Value ($IpNetRow.dwType -as $MIB_IPNET_TYPE)

                Write-Output $obj
            }
        }
    }

    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($pIpNetTable)
}