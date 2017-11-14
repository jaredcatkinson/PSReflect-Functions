function EnumMonitors
{
    <#
    .SYNOPSIS

    The EnumMonitors function retrieves information about the port monitors installed on the specified server.

    .PARAMETER Name
    
    A string that specifies the name of the server on which the monitors reside. If this parameter is NULL, the local monitors are enumerated.

    .NOTES
    
    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, MONITOR_INFO_2 (Structure)
    Optional Dependencies: None

    (func winspool.drv EnumMonitors ([bool]) @(
        [string],                 #_In_  LPTSTR  pName
        [UInt32],                 #_In_  DWORD   Level
        [IntPtr],                 #_Out_ LPBYTE  pMonitors
        [UInt32],                 #_In_  DWORD   cbBuf
        [UInt32].MakeByRefType(), #_Out_ LPDWORD pcbNeeded
        [UInt32].MakeByRefType()  #_Out_ LPDWORD pcReturned
    ) -EntryPoint EnumMonitors)

    .LINK

    .EXAMPLE
    
    EnumMonitors

    pName                                   pEnvironment pDLLName    
    -----                                   ------------ --------    
    WSD Port                                Windows x64  WSDMon.dll  
    ThinPrint Print Port Monitor for VMWare Windows x64  TPVMMon.dll 
    Standard TCP/IP Port                    Windows x64  tcpmon.dll  
    Local Port                              Windows x64  localspl.dll
    IppMon                                  Windows x64  IPPMon.dll  
    Appmon                                  Windows x64  AppMon.dll
    #>

    param
    (
        [Parameter()]
        [string]
        $Name = $null
    )

    $pcbNeeded = 0
    $pcReturned = 0

    $SUCCESS = $winspool::EnumMonitors($Name, 2, [IntPtr]::Zero, 0, [ref]$pcbNeeded, [ref]$pcReturned)

    if(!($SUCCESS))
    {
        $cbBuf = $pcbNeeded
        $pMonitors = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($cbBuf)
        $SUCCESS = $winspool::EnumMonitors($Name, 2, $pMonitors, $cbBuf, [ref]$pcbNeeded, [ref]$pcReturned)

        if($SUCCESS)
        {
            $currentPtr = $pMonitors

            for($i = 0; $i -lt $pcReturned; $i++)
            {
                $currentPtr -as $MONITOR_INFO_2
                $currentPtr = [IntPtr]::Add($currentPtr, [IntPtr]::Size * 3)
            }
        }
    }
}
