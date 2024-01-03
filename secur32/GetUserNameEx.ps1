function GetUserNameEx
{
    <#
    .SYNOPSIS

    Retrieves the name of the user or other security principal associated with the calling thread. You can specify the format of the returned name.

    If the thread is impersonating a client, GetUserNameEx returns the name of the client.

    .DESCRIPTION

    .PARAMETER NameFormat

    The format of the name. This parameter is a value from the EXTENDED_NAME_FORMAT enumeration type. It cannot be NameUnknown. If the user account is not in a domain, only NameSamCompatible is supported.
    
    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: LUID (Structure), SECURITY_HANDLE (Structure), SECURITY_INTEGER (Structure), SECPKG_CRED (Enumeration)
    Optional Dependencies: None

    (func secur32 GetUserNameEx ([Bool]) @(
        [UInt32],                          #_In_    EXTENDED_NAME_FORMAT NameFormat
        [StringBuilder],                   #_Out_   LPWSTRE              lpNameBuffer
        [UInt32].MakeByRefType()           #_InOut_ ULONG                nSize
    ) -EntryPoint GetUserNameEx)

    .LINK
    
    https://learn.microsoft.com/en-us/windows/win32/api/secext/nf-secext-getusernameexw
    #>

    param
    (
        [Parameter()]
        [ValidateSet(NameUnknown, NameFullyQualifiedDN, NameSamCompatible, NameDisplay, NameUniqueId, NameCanonical, NameUserPrincipal, NameCanonicalEx, NameServicePrincipal, NameDnsDomain, NameGivenName, NameSurname)]
        [string]
        $NameFormat
    )

    foreach($val in $DesiredAccess)
    {
        $valNameFormat = $NameFormat -bor $EXTENDED_NAME_FORMAT::$val
    }

    $nSize = 0

    $SUCCESS = $Secur32::GetUserNameEx($NameFormat, [IntPtr]::Zero, [ref]$nSize); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($SUCCESS -eq 234)
    {
        $lpNameBuffer = New-Object -TypeName byte[]($nSize)
        $SUCCESS = $Secur32::GetUserNameEx($EXTENDED_NAME_FORMAT::$NameFormat, [ref]$lpNameBuffer, [ref]$nSize)

        if($SUCCESS -eq 0)
        {
            Write-Error "[GetUserNameEx] Error: $(([ComponentModel.Win32Exception] $LastError).Message)" 
        }
    }
    else
    {
        Write-Error "[GetUserNameEx] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    [System.Text.Encoding]::Unicode.GetString($lpNameBuffer)
}