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
        [ValidateSet('WTSInitialProgram','WTSApplicationName','WTSWorkingDirectory','WTSOEMId','WTSSessionId','WTSUserName','WTSWinStationName','WTSDomainName','WTSConnectState','WTSClientBuildNumber','WTSClientName','WTSClientDirectory','WTSClientProductId','WTSClientHardwareId','WTSClientAddress','WTSClientDisplay','WTSClientProtocolType','WTSIdleTime','WTSLogonTime','WTSIncomingBytes','WTSOutgoingBytes','WTSIncomingFrames','WTSOutgoingFrames','WTSClientInfo','WTSSessionInfo','WTSSessionInfoEx','WTSConfigInfo','WTSValidationInfo','WTSSessionAddressV4','WTSIsRemoteSession')]
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

        }
        WTSApplicationName
        {

        }
        WTSWorkingDirectory
        {

        }
        WTSOEMId
        {

        }
        WTSSessionId
        {

        }
        WTSUserName
        {

        }
        WTSWinStationName
        {

        }
        WTSDomainName
        {

        }
        WTSConnectState
        {

        }
        WTSClientBuildNumber
        {

        }
        WTSClientName
        {

        }
        WTSClientDirectory
        {

        }
        WTSClientProductId
        {

        }
        WTSClientHardwareId
        {

        }
        WTSClientAddress
        {

        }
        WTSClientDisplay
        {

        }
        WTSClientProtocolType
        {

        }
        WTSIdleTime
        {

        }
        WTSLogonTime
        {

        }
        WTSIncomingBytes
        {

        }
        WTSOutgoingBytes
        {

        }
        WTSIncomingFrames
        {

        }
        WTSOutgoingFrames
        {

        }
        WTSClientInfo
        {

        }
        WTSSessionInfo
        {

        }
        WTSSessionInfoEx
        {

        }
        WTSConfigInfo
        {

        }
        WTSValidationInfo
        {

        }
        WTSSessionAddressV4
        {

        }
        WTSIsRemoteSession
        {

        }
    }
}