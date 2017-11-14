function LookupPrivilegeDisplayName
{
    <#
    .SYNOPSIS

    The LookupPrivilegeDisplayName function retrieves the display name that represents a specified privilege.

    .DESCRIPTION

    The LookupPrivilegeDisplayName function retrieves display names only for the privileges specified in the Defined Privileges section of Winnt.h.

    .PARAMETER Privilege

    A string that specifies the name of the privilege, as defined in Winnt.h. For example, this parameter could specify the constant, SE_REMOTE_SHUTDOWN_NAME, or its corresponding string, "SeRemoteShutdownPrivilege".
    
    .NOTES
    
    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func advapi32 LookupPrivilegeDisplayName ([bool]) @(
        [string],                    #_In_opt_  LPCTSTR lpSystemName,
        [string],                    #_In_      LPCTSTR lpName,
        [System.Text.StringBuilder], #_Out_opt_ LPTSTR  lpDisplayName,
        [UInt32].MakeByRefType(),    #_Inout_   LPDWORD cchDisplayName,
        [UInt32].MakeByRefType()     #_Out_     LPDWORD lpLanguageId
    ) -EntryPoint LookupPrivilegeDisplayName -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa379168(v=vs.85).aspx

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/bb530716(v=vs.85).aspx

    .EXAMPLE

    LookupPrivilegeDisplayName -Privilege SeRemoteShutdownPrivilege
    Force shutdown from a remote system

    #>
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Privilege
    )

    $lpDisplayName = New-Object -TypeName System.Text.StringBuilder

    $cchDisplayName = 0
    $lpLanguageId = 0

    $SUCCESS = $Advapi32::LookupPrivilegeDisplayName($null, $Privilege, $lpDisplayName, [ref]$cchDisplayName, [ref]$lpLanguageId)

    $lpDisplayName.EnsureCapacity($cchDisplayName + 1) | Out-Null

    $SUCCESS = $Advapi32::LookupPrivilegeDisplayName($null, $Privilege, $lpDisplayName, [ref]$cchDisplayName, [ref]$lpLanguageId); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    
    if(-not $SUCCESS) 
    {
        Write-Error "[LookupPrivilegeDisplayName] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output ($lpDisplayName.ToString())
}