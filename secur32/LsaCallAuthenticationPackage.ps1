function LsaCallAuthenticationPackage
{
    <#
    .SYNOPSIS

    The LsaCallAuthenticationPackage function is used by a logon application to communicate with an authentication package.
    
    This function is typically used to access services provided by the authentication package.

    .DESCRIPTION

    Logon applications can call LsaCallAuthenticationPackage to communicate with an authentication package. There are several reasons why an application may do this:
    
    - To implement multiple-message authentication protocols, such as the NTLM Challenge-Response protocol.
    - To pass state change information to the authentication package. For example, the NTLM might notify the MSV1_0 package that a previously unreachable domain controller is now reachable. The authentication package would then re-logon any users logged on to that domain controller.
    
    Typically, this function is used to exchange information with a custom authentication package. This function is not needed by an application that is using one of the authentication packages supplied with Windows, such as MSV1_0 or Kerberos.
    
    You must call LsaCallAuthenticationPackage to clean up PKINIT device credentials for LOCAL_SYSTEM and NETWORK_SERVICE. When there is no PKINIT device credential, a successful call does no operation. When there is a PKINIT device credential, a successful call cleans up the PKINIT device credential so that only the password credential remains.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: LsaNtStatusToWinError (Function)
    Optional Dependencies: None

    (func secur32 LsaCallAuthenticationPackage ([UInt32]) @(
        [IntPtr],                 #_In_  HANDLE    LsaHandle
        [UInt64],                 #_In_  ULONG     AuthenticationPackage
        [IntPtr],                 #_In_  PVOID     ProtocolSubmitBuffer
        [UInt64],                 #_In_  ULONG     SubmitBufferLength
        [IntPtr].MakeByRefType(), #_Out_ PVOID     *ProtocolReturnBuffer
        [UInt64].MakeByRefType(), #_Out_ PULONG    *ReturnBufferLength
        [UInt32].MakeByRefType()  #_Out_ PNTSTATUS ProtocolStatus
    ) -EntryPoint LsaCallAuthenticationPackage)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa378261(v=vs.85).aspx

    .EXAMPLE

    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $LsaHandle,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $AuthenticationPackage,

        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ProtocolSubmitBuffer,

        [Parameter(Mandatory = $true)]
        [UInt64]
        $SubmitBufferLength
    )
    
    $ProtocolReturnBuffer = [IntPtr]::Zero
    $ReturnBufferLength = [UInt64]0
    $ProtocolStatus = [UInt32]0

    $SUCCESS = $Secur32::LsaCallAuthenticationPackage($LsaHandle, $AuthenticationPackage, $ProtocolSubmitBuffer, $SubmitBufferLength, [ref]$ProtocolReturnBuffer, [ref]$ReturnBufferLength, [ref]$ProtocolStatus)

    if($SUCCESS -eq 0)
    {
        if($ProtocolStatus -eq 0)
        {
            Write-Output $ProtocolReturnBuffer
        }
        else
        {
            $WinErrorCode = LsaNtStatusToWinError -NtStatus $ProtocolStatus
            $LastError = [ComponentModel.Win32Exception]$WinErrorCode
            throw "LsaCallAuthenticationPackage Error: $($LastError.Message)"                    
        }                    
    }
    else
    {
        $WinErrorCode = LsaNtStatusToWinError -NtStatus $SUCCESS
        $LastError = [ComponentModel.Win32Exception]$WinErrorCode
        throw "LsaCallAuthenticationPackage Error: $($LastError.Message)"
    }      
}

function LsaCallAuthenticationPackageKerbPurgeTktCache
{
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $LsaHandle,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $AuthenticationPackage,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $LogonId,

        [Parameter()]
        [string]
        $ServerName,

        [Parameter()]
        [string]
        $RealmName
    )

    $LogonIdLuid = [Activator]::CreateInstance($LUID)
    $LogonIdLuid.LowPart = $LogonId
    $LogonIdLuid.HighPart = 0

    $Request = [Activator]::CreateInstance($KERB_PURGE_TKT_CACHE_REQUEST)
    $Request.MessageType = $KERB_PROTOCOL_MESSAGE_TYPE::KerbPurgeTicketCacheMessage
    $Request.LogonId = $LogonIdLuid

    if($PSBoundParameters.ContainsKey('ServerName'))
    {
        $ServerName_String = [Activator]::CreateInstance($LSA_UNICODE_STRING)
        $ServerName_String.Length = $ServerName.Length * 2
        $ServerName_String.MaximumLength = $ServerName.Length * 2
        $ServerName_String.Buffer = [System.Runtime.InteropServices.Marshal]::StringToHGlobalAuto($ServerString)
        
        $Request.ServerName = $ServerName_String
    }

    if($PSBoundParameters.ContainsKey('RealmName'))
    {
        $RealmName_String = [Activator]::CreateInstance($LSA_UNICODE_STRING)
        $RealmName_String.Length = $RealmName.Length * 2
        $RealmName_String.MaximumLength = $RealmName.Length * 2
        $RealmName_String.Buffer = [System.Runtime.InteropServices.Marshal]::StringToHGlobalAuto($RealmString)
        
        $Request.RealmName = $RealmName_String
    }

    $ProtocolSubmitBuffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($KERB_PURGE_TKT_CACHE_REQUEST::GetSize())
    [System.Runtime.InteropServices.Marshal]::StructureToPtr($Request, $ProtocolSubmitBuffer, $true)

    $ProtocolReturnBuffer = LsaCallAuthenticationPackage -LsaHandle $LsaHandle -AuthenticationPackage $AuthenticationPackage -ProtocolSubmitBuffer $ProtocolSubmitBuffer -SubmitBufferLength $KERB_PURGE_TKT_CACHE_REQUEST::GetSize()

    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($ProtocolSubmitBuffer)
        
    Write-Output $ProtocolReturnBuffer
}

function LsaCallAuthenticationPackageKerbQueryTktCache
{
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $LsaHandle,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $AuthenticationPackage,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $LogonId
    )

    $LogonIdLuid = [Activator]::CreateInstance($LUID)
    $LogonIdLuid.LowPart = $LogonId
    $LogonIdLuid.HighPart = 0

    $Request = [Activator]::CreateInstance($KERB_QUERY_TKT_CACHE_REQUEST)
    $Request.MessageType = $KERB_PROTOCOL_MESSAGE_TYPE::KerbQueryTicketCacheMessage
    $Request.LogonId = $LogonIdLuid

    $ProtocolSubmitBuffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($KERB_QUERY_TKT_CACHE_REQUEST::GetSize())
    [System.Runtime.InteropServices.Marshal]::StructureToPtr($Request, $ProtocolSubmitBuffer, $true)

    $ProtocolReturnBuffer = LsaCallAuthenticationPackage -LsaHandle $LsaHandle -AuthenticationPackage $AuthenticationPackage -ProtocolSubmitBuffer $ProtocolSubmitBuffer -SubmitBufferLength $KERB_QUERY_TKT_CACHE_REQUEST::GetSize()

    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($ProtocolSubmitBuffer)

    Write-Output $ProtocolReturnBuffer
}

function LsaCallAuthenticationPackageKerbRetrieveTkt
{
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $LsaHandle,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $AuthenticationPackage,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $LogonId
    )

    $LogonIdLuid = [Activator]::CreateInstance($LUID)
    $LogonIdLuid.LowPart = $LogonId
    $LogonIdLuid.HighPart = 0

    $Request = [Activator]::CreateInstance($KERB_RETRIEVE_TKT_REQUEST)
    $Request.MessageType = $KERB_PROTOCOL_MESSAGE_TYPE::KerbRetrieveTicketMessage
    $Request.LogonId = $LogonIdLuid

    $ProtocolSubmitBuffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($KERB_RETRIEVE_TKT_REQUEST::GetSize())
    [System.Runtime.InteropServices.Marshal]::StructureToPtr($Request, $ProtocolSubmitBuffer, $true)

    $ProtocolReturnBuffer = LsaCallAuthenticationPackage -LsaHandle $hLsa -AuthenticationPackage $AuthenticationPackage -ProtocolSubmitBuffer $ProtocolSubmitBuffer -SubmitBufferLength $KERB_RETRIEVE_TKT_REQUEST::GetSize()

    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($ProtocolSubmitBuffer)

    Write-Output $ProtocolReturnBuffer
}