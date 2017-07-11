function LsaEnumerateLogonSessions
{
    <#
    .SYNOPSIS

    The LsaEnumerateLogonSessions function retrieves the set of existing logon session identifiers (LUIDs) and the number of sessions.

    .DESCRIPTION

    To retrieve information about the logon sessions returned by LsaEnumerateLogonSessions, call the LsaGetLogonSessionData function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, LsaNtStatusToWinError (Function)
    Optional Dependencies: None

    (func secur32 LsaEnumerateLogonSessions ([UInt32]) @(
        [UInt64].MakeByRefType(), #_Out_ PULONG LogonSessionCount,
        [IntPtr].MakeByRefType()  #_Out_ PLUID  *LogonSessionList
    ) -EntryPoint LsaEnumerateLogonSessions)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa378275(v=vs.85).aspx

    .EXAMPLE

    LsaEnumerateLogonSessions
    8
    2390553591808

    .EXAMPLE

    $SessionCount, $LogonSessionListPtr = LsaEnumerateLogonSessions
    #>

    $LogonSessionCount = [UInt64]0
    $LogonSessionList = [IntPtr]::Zero

    $SUCCESS = $Secur32::LsaEnumerateLogonSessions([ref]$LogonSessionCount, [ref]$LogonSessionList)

    if($SUCCESS -ne 0)
    {
        $WinErrorCode = LsaNtStatusToWinError -NtStatus $success
        $LastError = [ComponentModel.Win32Exception]$WinErrorCode
        throw "LsaEnumerateLogonSessions Error: $($LastError.Message)"
    }

    $obj = New-Object -TypeName psobject

    $obj | Add-Member -MemberType NoteProperty -Name SessionCount -Value $LogonSessionCount
    $obj | Add-Member -MemberType NoteProperty -Name SessionListPointer -Value $LogonSessionList
    
    Write-Output $obj
}