function ConvertStringSidToSid
{
    <#
    .SYNOPSIS

    The ConvertStringSidToSid function converts a string-format security identifier (SID) into a valid, functional SID. You can use this function to retrieve a SID that the ConvertSidToStringSid function converted to string format.

    .PARAMETER Sid

    A string containing the string-format SID to convert. The SID string can use either the standard S-R-I-S-S… format for SID strings, or the SID string constant format, such as "BA" for built-in administrators. For more information about SID string notation, see SID Components.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func advapi32 ConvertStringSidToSid ([bool]) @(
        [string],                #_In_  LPCTSTR StringSid,
        [IntPtr].MakeByRefType() #_Out_ PSID    *Sid
    ) -EntryPoint ConvertStringSidToSid -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa376402(v=vs.85).aspx
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Sid
    )

    $SidPtr = [IntPtr]::Zero
    $SUCCESS = $Advapi32::ConvertStringSidToSid($Sid, [ref]$SidPtr); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    
    if(-not $SUCCESS)
    {
        Write-Verbose "[ConvertStringSidToSid] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
    
    Write-Output $SidPtr
}