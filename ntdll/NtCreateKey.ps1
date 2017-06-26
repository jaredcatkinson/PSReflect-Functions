function NtCreateKey
{
    <#
    .SYNOPSIS

    Creates a new registry key or opens an existing one.

    .PARAMETER KeyHandle

    Pointer to a HANDLE variable that receives a handle to the key.

    .PARAMETER DesiredAccess

    .PARAMETER ObjectAttributes

    .PARAMETER TitleIndex

    .PARAMETER Class

    .PARAMETER CreateOptions

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson), Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, THREADINFOCLASS (Enumeration)
    Optional Dependencies: None

    (func ntdll NtCreateKey ([Int32]) @(
    [IntPtr].MakeByRefType(), #_Out_      PHANDLE      KeyHandle,
    [Int32],                  #_In_       ACCESS_MASK  DesiredAccess,
    [bool],                   #_In_       POBJECT_ATTRIBUTES ObjectAttributes,
    $UNICODE_STRING.MakeByRefType(), #_In_opt_   PUNICODE_STRING    Class,
    [Int32],  #_In_      ULONG           CreateOptions,
    [IntPtr]  #_Out_opt_ PULONG          Disposition
    ) -EntryPoint NtCreateKey),      
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff566425(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ThreadHandle,

        [Parameter(Mandatory = $true)]
        [ValidateSet('ThreadBasicInformation','ThreadTimes','ThreadPriority','ThreadBasePriority','ThreadAffinityMask','ThreadImpersonationToken','ThreadDescriptorTableEntry','ThreadEnableAlignmentFaultFixup','ThreadEventPair_Reusable','ThreadQuerySetWin32StartAddress','ThreadZeroTlsCell','ThreadPerformanceCount','ThreadAmILastThread','ThreadIdealProcessor','ThreadPriorityBoost','ThreadSetTlsArrayAddress','ThreadIsIoPending','ThreadHideFromDebugger','ThreadBreakOnTermination','ThreadSwitchLegacyState','ThreadIsTerminated','ThreadLastSystemCall','ThreadIoPriority','ThreadCycleTime','ThreadPagePriority','ThreadActualBasePriority','ThreadTebInformation','ThreadCSwitchMon','ThreadCSwitchPmu','ThreadWow64Context','ThreadGroupInformation','ThreadUmsInformation','ThreadCounterProfiling','ThreadIdealProcessorEx','ThreadCpuAccountingInformation','ThreadSuspendCount','ThreadHeterogeneousCpuPolicy','ThreadContainerId','ThreadNameInformation','ThreadSelectedCpuSets','ThreadSystemThreadInformation','ThreadActualGroupAffinity','ThreadDynamicCodePolicyInfo','ThreadExplicitCaseSensitivity','ThreadWorkOnBehalfTicket','ThreadSubsystemInformation','ThreadDbgkWerReportActive','ThreadAttachContainer','MaxThreadInfoClass')]
        [string]
        $ThreadInformationClass
    )
    
    $buf = [System.Runtime.InteropServices.Marshal]::AllocHGlobal([IntPtr]::Size)

    $Success = $Ntdll::NtQueryInformationThread($ThreadHandle, $THREAD_INFORMATION_CLASS::$ThreadInformationClass, $buf, [IntPtr]::Size, [IntPtr]::Zero); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $Success) 
    {
        Write-Debug "NtQueryInformationThread Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
    
    }
}