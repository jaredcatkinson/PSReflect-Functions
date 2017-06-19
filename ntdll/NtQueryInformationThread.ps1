function NtQueryInformationThread
{
    <#
    .SYNOPSIS

    Retrieves information about the specified thread.

    .PARAMETER ThreadHandle

    A handle to the thread about which information is being requested.

    .PARAMETER ThreadInformationClass

    If this parameter is the ThreadIsIoPending value of the THREADINFOCLASS enumeration, the function determines whether the thread has any I/O operations pending.
    
    Use the public function GetThreadIOPendingFlag instead to obtain this information.
    
    If this parameter is the ThreadQuerySetWin32StartAddress value of the THREADINFOCLASS enumeration, the function returns the start address of the thread. Note that on versions of Windows prior to Windows Vista, the returned start address is only reliable before the thread starts running.
    
    If this parameter is the ThreadSubsystemInformation value of the THREADINFOCLASS enumeration, the function retrieves a SUBSYSTEM_INFORMATION_TYPE value indicating the subsystem type of the thread. The buffer pointed to by the ThreadInformation parameter should be large enough to hold a single SUBSYSTEM_INFORMATION_TYPE enumeration.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, THREADINFOCLASS (Enumeration)
    Optional Dependencies: None

    (func ntdll NtQueryInformationThread ([Int32]) @(
        [IntPtr], #_In_      HANDLE          ThreadHandle,
        [Int32],  #_In_      THREADINFOCLASS ThreadInformationClass,
        [IntPtr], #_Inout_   PVOID           ThreadInformation,
        [Int32],  #_In_      ULONG           ThreadInformationLength,
        [IntPtr]  #_Out_opt_ PULONG          ReturnLength
    ) -EntryPoint NtQueryInformationThread)
        
    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms684283(v=vs.85).aspx

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
    
    switch($ThreadInformationClass)
    {
        ThreadBasicInformation
        {

        }
        ThreadTimes
        {

        }
        ThreadPriority
        {

        }
        ThreadBasePriority
        {

        }
        ThreadAffinityMask
        {

        }
        ThreadImpersonationToken
        {

        }
        ThreadDescriptorTableEntry
        {

        }
        ThreadEnableAlignmentFaultFixup
        {

        }
        ThreadEventPair_Reusable
        {

        }
        ThreadQuerySetWin32StartAddress
        {
            Write-Output ([System.Runtime.InteropServices.Marshal]::ReadIntPtr($buf))
        }
        ThreadZeroTlsCell
        {

        }
        ThreadPerformanceCount
        {

        }
        ThreadAmILastThread
        {

        }
        ThreadIdealProcessor
        {

        }
        ThreadPriorityBoost
        {

        }
        ThreadSetTlsArrayAddress
        {

        }
        ThreadIsIoPending
        {

        }
        ThreadHideFromDebugger
        {

        }
        ThreadBreakOnTermination
        {

        }
        ThreadSwitchLegacyState
        {

        }
        ThreadIsTerminated
        {

        }
        ThreadLastSystemCall
        {

        }
        ThreadIoPriority
        {

        }
        ThreadCycleTime
        {

        }
        ThreadPagePriority
        {

        }
        ThreadActualBasePriority
        {

        }
        ThreadTebInformation
        {

        }
        ThreadCSwitchMon
        {

        }
        ThreadCSwitchPmu
        {

        }
        ThreadWow64Context
        {

        }
        ThreadGroupInformation
        {

        }
        ThreadUmsInformation
        {

        }
        ThreadCounterProfiling
        {

        }
        ThreadIdealProcessorEx
        {

        }
        ThreadCpuAccountingInformation
        {

        }
        ThreadSuspendCount
        {

        }
        ThreadHeterogeneousCpuPolicy
        {

        }
        ThreadContainerId
        {

        }
        ThreadNameInformation
        {

        }
        ThreadSelectedCpuSets
        {

        }
        ThreadSystemThreadInformation
        {

        }
        ThreadActualGroupAffinity
        {

        }
        ThreadDynamicCodePolicyInfo
        {

        }
        ThreadExplicitCaseSensitivity
        {

        }
        ThreadWorkOnBehalfTicket
        {

        }
        ThreadSubsystemInformation
        {

        }
        ThreadDbgkWerReportActive
        {

        }
        ThreadAttachContainer
        {

        }
        MaxThreadInfoClass
        {

        }
    }
}