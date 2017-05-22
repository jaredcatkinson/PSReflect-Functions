function LsaGetLogonSessionData
{
    <#
    .SYNOPSIS

    The LsaGetLogonSessionData function retrieves information about a specified logon session.

    .DESCRIPTION

    .Parameter LuidPtr

    .Parameter SessionCount

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: LsaNtStatusToWinError, SECURITY_LOGON_SESSION_DATA (Struct), SECURITY_LOGON_TYPE (Enum)
    Optional Dependencies: None

    (func secur32 LsaGetLogonSessionData ([UInt32]) @(
        [IntPtr],                #_In_  PLUID                        LogonId,
        [IntPtr].MakeByRefType() #_Out_ PSECURITY_LOGON_SESSION_DATA *ppLogonSessionData
    ))

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa378290(v=vs.85).aspx

    .EXAMPLE

    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $LuidPtr,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $SessionCount
    )

    $CurrentLuidPtr = $LuidPtr

    for($i = 0; $i -lt $SessionCount; $i++)
    {
        $sessionDataPtr = [IntPtr]::Zero
        $SUCCESS = $Secur32::LsaGetLogonSessionData($CurrentLuidPtr, [ref]$sessionDataPtr)

        if($SUCCESS -ne 0)
        {
            $WinErrorCode = LsaNtStatusToWinError -NtStatus $success
            $LastError = [ComponentModel.Win32Exception]$WinErrorCode
            throw "LsaGetLogonSessionData Error: $($LastError.Message)"
        }

        try
        {
            $sessionData = $sessionDataPtr -as $SECURITY_LOGON_SESSION_DATA
            
            $props = @{
                LogonId = $sessionData.LogonId.LowPart
                UserName = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($sessionData.Username.Buffer, $sessionData.Username.Length / 2)
                LogonDomain = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($sessionData.LogonDomain.Buffer, $sessionData.LognDomain.Length / 2)
                AuthenticationPackage = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($sessionData.AuthenticationPackage.Buffer, $sessionData.AuthenticationPackage.Length / 2)
                LogonType = $sessionData.LogonType -as $SECURITY_LOGON_TYPE
                Session = $sessionData.Session
                Sid = New-Object -TypeName System.Security.Principal.SecurityIdentifier($sessionData.PSiD)
                LogonTime = [datetime]::FromFileTime($sessionData.LogonTime)
                LogonServer = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($sessionData.LogonServer.Buffer, $sessionData.LogonServer.Length / 2)
                DnsDomainName = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($sessionData.DnsDomainName.Buffer, $sessionData.DnsDomainName.Length / 2)
                Upn =  [System.Runtime.InteropServices.Marshal]::PtrToStringUni($sessionData.Upn.Buffer, $sessionData.Upn.Length / 2)
                UserFlags = $sessionData.UserFlags
                LastSuccessfulLogon = $sessionData.LastLogonInfo.LastSuccessfulLogon
                LastFailedLogon = $sessionData.LastLogonInfo.LastFailedLogon
                FailedAttemptCountSinceLastSuccessfulLogon = $sessionData.LastLogonInfo.FailedAttemptCountSinceLastSuccessfulLogon
                LogonScript = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($sessionData.LogonScript.Buffer, $sessionData.LogonScript.Length / 2)
                ProfilePath = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($sessionData.ProfilePath.Buffer, $sessionData.ProfilePath.Length / 2)
                HomeDirectory = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($sessionData.HomeDirectory.Buffer, $sessionData.HomeDirectory.Length / 2)
                HomeDirectoryDrive = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($sessionData.HomeDirectoryDrive.Buffer, $sessionData.HomeDirectoryDrive.Length / 2)
                LogoffTime = $sessionData.LogoffTime
                KickOffTime = $sessionData.KickOffTime
                PasswordLastSet = [datetime]::FromFileTime($sessionData.PasswordLastSet)
                PasswordCanChange = [datetime]::FromFileTime($sessionData.PasswordCanChange)
                PasswordMustChange = $sessionData.PasswordMustChange
            }
                    
            $obj = New-Object -TypeName psobject -Property $props

            Write-Output $obj
        }
        catch
        {

        }

        #LsaFreeReturnBuffer -Buffer $sessionDataPtr
        $CurrentLuidPtr = [IntPtr]($CurrentLuidPtr.ToInt64() + $LUID::GetSize())
    }
}