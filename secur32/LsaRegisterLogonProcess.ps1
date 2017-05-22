function LsaRegisterLogonProcess
{
    <#
    .SYNOPSIS

    The LsaLookupAuthenticationPackage function obtains the unique identifier of an authentication package.

    .DESCRIPTION

    The authentication package identifier is used in calls to authentication functions such as LsaLogonUser and LsaCallAuthenticationPackage.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: LsaNtStatusToWinError (Function), LSA_STRING (Struct)
    Optional Dependencies: None

    (func secur32 LsaRegisterLogonProcess ([UInt32]) @(
        $LSA_STRING.MakeByRefType() #_In_  PLSA_STRING           LogonProcessName,
        [IntPtr].MakeByRefType()    #_Out_ PHANDLE               LsaHandle,
        [UInt64].MakeByRefType()    #_Out_ PLSA_OPERATIONAL_MODE SecurityMode
    ))

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa378297(v=vs.85).aspx

    .EXAMPLE

    $hLsa = LsaRegisterLogonProcess
    #>

    $lsaStringArray = [System.Text.Encoding]::ASCII.GetBytes("INVOKE-IR")
    [int]$size = $lsaStringArray.Length
    [IntPtr]$pnt = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($size) 
    [System.Runtime.InteropServices.Marshal]::Copy($lsaStringArray, 0, $pnt, $lsaStringArray.Length)
    
    $lsaString = [Activator]::CreateInstance($LSA_STRING)
    $lsaString.Length = [UInt16]$lsaStringArray.Length
    $lsaString.MaximumLength = [UInt16]$lsaStringArray.Length
    $lsaString.Buffer = $pnt

    $LsaHandle = [IntPtr]::Zero
    $SecurityMode = [UInt64]0

    $SUCCESS = $Secur32::LsaRegisterLogonProcess([ref]$lsaString, [ref]$LsaHandle, [ref]$SecurityMode)

    if($SUCCESS -ne 0)
    {
        $WinErrorCode = LsaNtStatusToWinError -NtStatus $success
        $LastError = [ComponentModel.Win32Exception]$WinErrorCode
        throw "LsaRegisterLogonProcess Error: $($LastError.Message)"
    }

    Write-Output $LsaHandle
}