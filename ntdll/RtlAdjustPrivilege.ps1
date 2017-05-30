function RtlAdjustPrivilege
{
<#
.SYNOPSIS

Enables a specific privilege for the current process.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect  

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

(func ntdll RtlAdjustPrivilege ([UInt32]) @(
    [Int32],                # int Privilege,
    [Bool],                 # bool bEnablePrivilege
    [Bool],                 # bool IsThreadPrivilege
    [Int32].MakeByRefType() # out bool PreviousValue
))

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


$Module = New-InMemoryModule -ModuleName Win32


$SecurityEntity = psenum $Module SecurityEntity UInt32 @{
    SeCreateTokenPrivilege              =   1
    SeAssignPrimaryTokenPrivilege       =   2
    SeLockMemoryPrivilege               =   3
    SeIncreaseQuotaPrivilege            =   4
    SeUnsolicitedInputPrivilege         =   5
    SeMachineAccountPrivilege           =   6
    SeTcbPrivilege                      =   7
    SeSecurityPrivilege                 =   8
    SeTakeOwnershipPrivilege            =   9
    SeLoadDriverPrivilege               =   10
    SeSystemProfilePrivilege            =   11
    SeSystemtimePrivilege               =   12
    SeProfileSingleProcessPrivilege     =   13
    SeIncreaseBasePriorityPrivilege     =   14
    SeCreatePagefilePrivilege           =   15
    SeCreatePermanentPrivilege          =   16
    SeBackupPrivilege                   =   17
    SeRestorePrivilege                  =   18
    SeShutdownPrivilege                 =   19
    SeDebugPrivilege                    =   20
    SeAuditPrivilege                    =   21
    SeSystemEnvironmentPrivilege        =   22
    SeChangeNotifyPrivilege             =   23
    SeRemoteShutdownPrivilege           =   24
    SeUndockPrivilege                   =   25
    SeSyncAgentPrivilege                =   26
    SeEnableDelegationPrivilege         =   27
    SeManageVolumePrivilege             =   28
    SeImpersonatePrivilege              =   29
    SeCreateGlobalPrivilege             =   30
    SeTrustedCredManAccessPrivilege     =   31
    SeRelabelPrivilege                  =   32
    SeIncreaseWorkingSetPrivilege       =   33
    SeTimeZonePrivilege                 =   34
    SeCreateSymbolicLinkPrivilege       =   35
}


$FunctionDefinitions = @(
    (func ntdll RtlAdjustPrivilege ([UInt32]) @([Int32], [Bool], [Bool], [Int32].MakeByRefType()))
)


$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$NTDll    = $Types['ntdll']
