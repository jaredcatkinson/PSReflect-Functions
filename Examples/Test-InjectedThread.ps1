function Test-InjectedThread
{
    $proc = Get-Process -Id $PID
    $BaseAddress = VirtualAllocEx -ProcessHandle $proc.Handle -Size 0x1000 -AllocationType 0x3000 -Protect 0x40
    WriteProcessMemory -ProcessHandle $proc.Handle -BaseAddress $BaseAddress -Buffer @(0x4D,0x5A)
    $hThread = CreateThread -StartAddress $BaseAddress
    $ThreadId = GetThreadId -Handle $hThread
    CloseHandle -Handle $hThread

    $props = @{
        ProcessId = $proc.Id
        ProcessName = $proc.Name
        ThreadId = $ThreadId
        BaseAddress = $BaseAddress
    }
    $obj = New-Object -TypeName psobject -Property $props
    Write-Output $obj
}