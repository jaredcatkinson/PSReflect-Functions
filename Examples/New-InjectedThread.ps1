function New-InjectedThread
{
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName = 'ByProcess', Position = 0)]
        [System.Diagnostics.Process]
        $Process,

        [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
        [UInt32]
        $Id
    )

    switch($PSCmdlet.ParameterSetName)
    {
        ById
        {
            $Process = Get-Process -Id $Id
        }
        None
        {
           $Process = Get-Process -Id $PID 
        }
    }

    $BaseAddress = VirtualAllocEx -ProcessHandle $Process.Handle -Size 0x1000 -AllocationType 0x3000 -Protect 0x40
    WriteProcessMemory -ProcessHandle $Process.Handle -BaseAddress $BaseAddress -Buffer @(0x4D,0x5A)

    $thread = CreateRemoteThread -ProcessHandle $Process.Handle -StartAddress $BaseAddress
    
    CloseHandle -Handle $thread.Handle

    $obj = New-Object -TypeName psobject
    $obj | Add-Member -MemberType NoteProperty -Name ProcessName -Value $Process.Name
    $obj | Add-Member -MemberType NoteProperty -Name ProcessId -Value $Process.Id
    $obj | Add-Member -MemberType NoteProperty -Name ThreadId -Value $thread.Id
    $obj | Add-Member -MemberType NoteProperty -Name StartAddress -Value $BaseAddress
    Write-Output $obj
}