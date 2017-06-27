function WTSQuerySessionInformation
{
    <#
    .SYNOPSIS

    Retrieves session information for the specified session on the specified Remote Desktop Session Host (RD Session Host) server. It can be used to query session information on local and remote RD Session Host servers.
    
    .DESCRIPTION

    To retrieve the session ID for the current session when Remote Desktop Services is running, call WTSQuerySessionInformation and specify WTS_CURRENT_SESSION for the SessionId parameter and WTSSessionId for the WTSInfoClass parameter. The session ID will be returned in the ppBuffer parameter. If Remote Desktop Services is not running, calls to WTSQuerySessionInformation fail. In this situation, you can retrieve the current session ID by calling the ProcessIdToSessionId function.
    
    To determine whether your application is running on the physical console, you must specify WTS_CURRENT_SESSION for the SessionId parameter, and WTSClientProtocolType as the WTSInfoClass parameter. If ppBuffer is "0", the session is attached to the physical console.

    .PARAMETER ServerHandle

    A handle to an RD Session Host server. Specify a handle opened by the WTSOpenServer function, or specify WTS_CURRENT_SERVER_HANDLE to indicate the RD Session Host server on which your application is running.

    .PARAMETER SessionId

    A Remote Desktop Services session identifier. To indicate the session in which the calling application is running (or the current session) specify WTS_CURRENT_SESSION. Only specify WTS_CURRENT_SESSION when obtaining session information on the local server. If WTS_CURRENT_SESSION is specified when querying session information on a remote server, the returned session information will be inconsistent. Do not use the returned data.
    You can use the WTSEnumerateSessions function to retrieve the identifiers of all sessions on a specified RD Session Host server.
    To query information for another user's session, you must have Query Information permission. 

    .PARAMETER WTSInfoClass

    A value of the WTS_INFO_CLASS enumeration that indicates the type of session information to retrieve in a call to the WTSQuerySessionInformation function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, WTS_INFO_CLASS (Enumeration)
    Optional Dependencies: None

    (func wtsapi32 WTSQuerySessionInformation ([Int32]) @(
        [IntPtr]                 #_In_  HANDLE         hServer
        [Int32]                  #_In_  DWORD          SessionId
        [Int32]                  #_In_  WTS_INFO_CLASS WTSInfoClass
        [IntPtr].MakeByRefType() #_Out_ LPTSTR         *ppBuffer
        [Int32].MakeByRefType()  #_Out_ DWORD          *pBytesReturned
    ) -EntryPoint WTSQuerySessionInformation -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/aa383838(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ServerHandle,
        
        [Parameter(Mandatory = $true)]
        [UInt32]
        $SessionId,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet('WTSInitialProgram','WTSApplicationName','WTSWorkingDirectory','WTSSessionId','WTSUserName','WTSWinStationName','WTSDomainName','WTSConnectState','WTSClientBuildNumber','WTSClientName','WTSClientDirectory','WTSClientProductId','WTSClientHardwareId','WTSClientAddress','WTSClientDisplay','WTSClientProtocolType','WTSIdleTime','WTSLogonTime','WTSIncomingBytes','WTSOutgoingBytes','WTSIncomingFrames','WTSOutgoingFrames','WTSClientInfo','WTSSessionInfo','WTSSessionInfoEx','WTSConfigInfo','WTSSessionAddressV4','WTSIsRemoteSession')]
        [string]
        $WTSInfoClass
    )

    $ppBuffer = [IntPtr]::Zero
    $pBytesReturned = 0

    $SUCCESS = $wtsapi32::WTSQuerySessionInformation($ServerHandle, $SessionId, $WTS_INFO_CLASS::$WTSInfoClass, [ref]$ppBuffer, [ref]$pBytesReturned); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if (-not $SUCCESS)
    {
        throw "[WTSQuerySessionInformation] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    switch($WTS_INFO_CLASS)
    {
        WTSInitialProgram
        {
            # A null-terminated string that contains the name of the initial program that Remote Desktop Services runs when the user logs on.
            Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ppBuffer))
        }
        WTSApplicationName
        {
            <#
            A null-terminated string that contains the published name of the application that the session is running.
            Windows Server 2008 R2, Windows 7, Windows Server 2008 and Windows Vista:  This value is not supported
            #>
            Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ppBuffer))
        }
        WTSWorkingDirectory
        {
            # A null-terminated string that contains the default directory used when launching the initial program.
            Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ppBuffer))
        }
        WTSSessionId
        {
            # A ULONG value that contains the session identifier.
            Write-Output ([System.Runtime.InteropServices.Marshal]::ReadInt64($ppBuffer))
        }
        WTSUserName
        {
            # A null-terminated string that contains the name of the user associated with the session.
            Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ppBuffer))
        }
        WTSWinStationName
        {
            <#
            A null-terminated string that contains the name of the Remote Desktop Services session.
            Note  Despite its name, specifying this type does not return the window station name. Rather, it returns the name of the Remote Desktop Services session. Each Remote Desktop Services session is associated with an interactive window station. Because the only supported window station name for an interactive window station is "WinSta0", each session is associated with its own "WinSta0" window station.
            #>
            Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ppBuffer))
        }
        WTSDomainName
        {
            # A null-terminated string that contains the name of the domain to which the logged-on user belongs.
            Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ppBuffer))
        }
        WTSConnectState
        {
            <#
            The session's current connection state.
                 WTS_CONNECTSTATE_CLASS
            #>
            Write-Output ([System.Runtime.InteropServices.Marshal]::ReadInt16($ppBuffer) -as $WTS_CONNECTSTATE_CLASS)
        }
        WTSClientBuildNumber
        {
            # A ULONG value that contains the build number of the client.
            Write-Output ([System.Runtime.InteropServices.Marshal]::ReadInt64($ppBuffer))
        }
        WTSClientName
        {
            # A null-terminated string that contains the name of the client.
            Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ppBuffer))
        }
        WTSClientDirectory
        {
            # A null-terminated string that contains the directory in which the client is installed.
            Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ppBuffer))
        }
        WTSClientProductId
        {
            # A USHORT client-specific product identifier.
            Write-Output ([System.Runtime.InteropServices.Marshal]::ReadInt16($ppBuffer))
        }
        WTSClientHardwareId
        {
            # A ULONG value that contains a client-specific hardware identifier. This option is reserved for future use. WTSQuerySessionInformation will always return a value of 0.
            Write-Output ([System.Runtime.InteropServices.Marshal]::ReadInt64($ppBuffer))
        }
        WTSClientAddress
        {
            <#
            The network type and network address of the client. 
            The IP address is offset by two bytes from the start of the Address member of the WTS_CLIENT_ADDRESS structure.
                WTS_CLIENT_ADDRESS
            #>
        }
        WTSClientDisplay
        {
            <#
            Information about the display resolution of the client.
                WTS_CLIENT_DISPLAY
            #>
        }
        WTSClientProtocolType
        {
            # A USHORT value that specifies information about the protocol type for the session.
            $ProtocolType = [System.Runtime.InteropServices.Marshal]::ReadInt16($ppBuffer)
            switch($ProtocolType)
            { 
                0 {Write-Output "Console"; break}
                1 {Write-Output "Legacy"; break}
                2 {Write-Output "RDP"; break}
            }
        }
        WTSClientInfo
        {
            <#
            Information about a Remote Desktop Connection (RDC) client. 
                WTSCLIENT
            #>
        }
        WTSSessionInfo
        {
            <#
            Information about a client session on a RD Session Host server. 
                WTSINFO
            #>
        }
        WTSSessionInfoEx
        {
            <#
            Extended information about a session on a RD Session Host server. 
            Windows Server 2008 and Windows Vista:  This value is not supported.
                WTSINFOEX
            #>
        }
        WTSConfigInfo
        {
            <#
            A WTSCONFIGINFO structure that contains information about the configuration of a RD Session Host server.
            Windows Server 2008 and Windows Vista:  This value is not supported.
            #>
        }
        WTSSessionAddressV4
        {
            <#
            A WTS_SESSION_ADDRESS structure that contains the IPv4 address assigned to the session. If the session does not have a virtual IP address, the WTSQuerySessionInformation function returns ERROR_NOT_SUPPORTED.
            Windows Server 2008 and Windows Vista:  This value is not supported.
            #>
        }
        WTSIsRemoteSession
        {
            <#
            Determines whether the current session is a remote session. The WTSQuerySessionInformation function returns a value of TRUE to indicate that the current session is a remote session, and FALSE to indicate that the current session is a local session. This value can only be used for the local machine, so the hServer parameter of the WTSQuerySessionInformation function must contain WTS_CURRENT_SERVER_HANDLE.
            Windows Server 2008 and Windows Vista:  This value is not supported.
            #>
        }
    }
}