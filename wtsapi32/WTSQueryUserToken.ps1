function WTSQueryUserToken
{
    <#
    .SYNOPSIS

    Obtains the primary access token of the logged-on user specified by the session ID. To call this function successfully, the calling application must be running within the context of the LocalSystem account and have the SE_TCB_NAME privilege.

    .PARAMETER SessionId

    A Remote Desktop Services session identifier. Any program running in the context of a service will have a session identifier of zero (0). You can use the WTSEnumerateSessions function to retrieve the identifiers of all sessions on a specified RD Session Host server.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func wtsapi32 WTSQueryUserToken ([bool]) @(
      [UInt32],                #_In_  ULONG   SessionId
      [IntPtr].MakeByRefType() #_Out_ PHANDLE phToken
    ) -EntryPoint WTSQueryToken -SetLastError)
    
    .LINK

    https://msdn.microsoft.com/en-us/library/aa383840(v=vs.85).aspx

    .LINK
    
    https://msdn.microsoft.com/en-us/library/aa374909(v=vs.85).aspx

    .LINK

    https://msdn.microsoft.com/en-us/library/aa383488(v=vs.85).aspx

    .LINK
    
    https://msdn.microsoft.com/en-us/library/aa375728(v=vs.85).aspx
    
    .LINK
    
    https://msdn.microsoft.com/en-us/library/ms684190(v=vs.85).aspx
    
    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [UInt32]
        $SessionId
    )

    $hToken = [IntPtr]::Zero
    $SUCCESS = $Wtsapi32::WTSQueryUserToken($SessionId, [ref]$hToken); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        throw "[WTSQueryUserToken] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $hToken
}