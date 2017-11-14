function LookupPrivilegeName
{
    <#
    .SYNOPSIS

    The LookupPrivilegeName function retrieves the name that corresponds to the privilege represented on a specific system by a specified locally unique identifier (LUID).

    .DESCRIPTION

    The LookupPrivilegeName function supports only the privileges specified in the Defined Privileges section of Winnt.h. 

    .PARAMETER PrivilegeValue

    The value by which the privilege is known on the target system.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, LUID (Structure)
    Optional Dependencies: None

    (func advapi32 LookupPrivilegeName ([bool]) @(
        [string],                    #_In_opt_  LPCTSTR lpSystemName
        [IntPtr],                    #_In_      PLUID   lpLuid
        [sYstem.Text.StringBuilder], #_Out_opt_ LPTSTR  lpName
        [UInt32].MakeByRefType()     #_Inout_   LPDWORD cchName
    ) -EntryPoint LookupPrivilegeName -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa379176(v=vs.85).aspx

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/bb530716(v=vs.85).aspx

    .EXAMPLE

    LookupPrivilegeName -PrivilegeValue 10
    SeLoadDriverPrivilege
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [UInt32]
        $PrivilegeValue
    )

    $L = [Activator]::CreateInstance($LUID)
    $L.LowPart = $PrivilegeValue

    $lpLuid = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($LUID::GetSize())
    [System.Runtime.InteropServices.Marshal]::StructureToPtr($L, $lpLuid, $true)

    $lpName = New-Object -TypeName System.Text.StringBuilder

    $cchName = 0

    $SUCCESS = $Advapi32::LookupPrivilegeName($null, $lpLuid, $lpName, [ref]$cchName); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    $lpName.EnsureCapacity($cchName + 1) | Out-Null

    $SUCCESS = $Advapi32::LookupPrivilegeName($null, $lpLuid, $lpName, [ref]$cchName); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    
    if(-not $SUCCESS) 
    {
        Write-Error "[LookupPrivilegeName] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output ($lpName.ToString())
}