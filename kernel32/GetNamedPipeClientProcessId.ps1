function GetNamedPipeClientProcessId
{
    <#
    .SYNOPSIS

    Retrieves the client process identifier for the specified named pipe.

    .PARAMETER PipeHandle

    A handle to an instance of a named pipe. This handle must be created by the CreateNamedPipe function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func kernel32 GetNamedPipeClientProcessId ([Bool]) @(
        [IntPtr],                #_In_  HANDLE Pipe,
        [UInt32].MakeByRefType() #_Out_ PULONG ClientProcessId
    ) -EntryPoint GetNamedPipeClientProcessId -SetLastError)

    .EXAMPLES
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $PipeHandle
    )

    [UInt32]$ClientProcessId = 0

    $SUCCESS = $kernel32::GetNamedPipeClientProcessId($PipeHandle, [ref]$ClientProcessId)

    if(-not $SUCCESS)
    {
        throw "[GetNamedPipeClientProcessId] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $ClientProcessId
}