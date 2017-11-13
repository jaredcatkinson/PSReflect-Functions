function EnumMonitors
{
    <#
    .SYNOPSIS

    The EnumMonitors function retrieves information about the port monitors installed on the specified server.

    .PARAMETER Name
    
    A string that specifies the name of the server on which the monitors reside. If this parameter is NULL, the local monitors are enumerated.

    .NOTES

    BOOL EnumMonitors(
      _In_  LPTSTR  pName,
      _In_  DWORD   Level,
      _Out_ LPBYTE  pMonitors,
      _In_  DWORD   cbBuf,
      _Out_ LPDWORD pcbNeeded,
      _Out_ LPDWORD pcReturned
    );
    
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

            $pcReturned
            for($i = 0; $i -lt $pcReturned; $i++)
            {
                $currentPtr -as $MONITOR_INFO_2
                $currentPtr = [IntPtr]::Add($currentPtr, [IntPtr]::Size * 3)
            }
        }
    }
}
