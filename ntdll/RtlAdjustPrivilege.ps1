function RtlAdjustPrivilege
{
    <#
    .SYNOPSIS

    Enables a specific privilege for the current process. 

    .DESCRIPTION

    Uses RtlAdjustPrivilege to enable a specific privilege for the current process.
    Privileges can be passed by string, or the output from Get-ProcessTokenPrivilege
    can be passed on the pipeline.

    .PARAMETER Privilege

    The privilege to enable. One of 'SeCreateTokenPrivilege', 'SeAssignPrimaryTokenPrivilege',
    'SeLockMemoryPrivilege', 'SeIncreaseQuotaPrivilege', 'SeUnsolicitedInputPrivilege',
    'SeMachineAccountPrivilege', 'SeTcbPrivilege', 'SeSecurityPrivilege', 'SeTakeOwnershipPrivilege',
    'SeLoadDriverPrivilege', 'SeSystemProfilePrivilege', 'SeSystemtimePrivilege',
    'SeProfileSingleProcessPrivilege', 'SeIncreaseBasePriorityPrivilege', 'SeCreatePagefilePrivilege',
    'SeCreatePermanentPrivilege', 'SeBackupPrivilege', 'SeRestorePrivilege', 'SeShutdownPrivilege',
    'SeDebugPrivilege', 'SeAuditPrivilege', 'SeSystemEnvironmentPrivilege', 'SeChangeNotifyPrivilege',
    'SeRemoteShutdownPrivilege', 'SeUndockPrivilege', 'SeSyncAgentPrivilege', 'SeEnableDelegationPrivilege',
    'SeManageVolumePrivilege', 'SeImpersonatePrivilege', 'SeCreateGlobalPrivilege',
    'SeTrustedCredManAccessPrivilege', 'SeRelabelPrivilege', 'SeIncreaseWorkingSetPrivilege',
    'SeTimeZonePrivilege', or 'SeCreateSymbolicLinkPrivilege'.

    .NOTES

    Author: Will Schroeder (@harmj0y)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect, SecurityEntity (Enumeration)
    Optional Dependencies: None

    (func ntdll RtlAdjustPrivilege ([UInt32]) @(
        [Int32],                # int Privilege,
        [Bool],                 # bool bEnablePrivilege
        [Bool],                 # bool IsThreadPrivilege
        [Int32].MakeByRefType() # out bool PreviousValue
    ) -EntryPoint RtlAdjustPrivilege)

    .LINK

    http://www.pinvoke.net/default.aspx/ntdll.RtlAdjustPrivilege

    .EXAMPLE

    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('Privileges')]
        [ValidateSet('SeCreateTokenPrivilege', 'SeAssignPrimaryTokenPrivilege', 'SeLockMemoryPrivilege', 'SeIncreaseQuotaPrivilege', 'SeUnsolicitedInputPrivilege', 'SeMachineAccountPrivilege', 'SeTcbPrivilege', 'SeSecurityPrivilege', 'SeTakeOwnershipPrivilege', 'SeLoadDriverPrivilege', 'SeSystemProfilePrivilege', 'SeSystemtimePrivilege', 'SeProfileSingleProcessPrivilege', 'SeIncreaseBasePriorityPrivilege', 'SeCreatePagefilePrivilege', 'SeCreatePermanentPrivilege', 'SeBackupPrivilege', 'SeRestorePrivilege', 'SeShutdownPrivilege', 'SeDebugPrivilege', 'SeAuditPrivilege', 'SeSystemEnvironmentPrivilege', 'SeChangeNotifyPrivilege', 'SeRemoteShutdownPrivilege', 'SeUndockPrivilege', 'SeSyncAgentPrivilege', 'SeEnableDelegationPrivilege', 'SeManageVolumePrivilege', 'SeImpersonatePrivilege', 'SeCreateGlobalPrivilege', 'SeTrustedCredManAccessPrivilege', 'SeRelabelPrivilege', 'SeIncreaseWorkingSetPrivilege', 'SeTimeZonePrivilege', 'SeCreateSymbolicLinkPrivilege')]
        [String[]]
        $Privilege
    )

    PROCESS {
        ForEach ($Priv in $Privilege) {
            [UInt32]$PreviousState = 0
            Write-Verbose "[RtlAdjustPrivilege] Attempting to enable '$Priv' for the current process"
            $Success = $NTDll::RtlAdjustPrivilege($SecurityEntity::$Priv, $True, $False, [ref]$PreviousState)
            if ($Success -ne 0) {
                Write-Warning "[RtlAdjustPrivilege] enable for '$Priv' failed: $Success"
            }
            else {
                 Write-Verbose "[RtlAdjustPrivilege] enable for '$Priv' successful"
            }
        }
    }
}