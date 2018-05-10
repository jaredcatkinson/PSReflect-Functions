function GetNamedPipeServerProcessId
{
    <#
    .SYNOPSIS

    Retrieves the server process identifier for the specified named pipe.

    .PARAMETER PipeHandle

    A handle to an instance of a named pipe. This handle must be created by the CreateNamedPipe function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func kernel32 GetNamedPipeServerProcessId ([Bool]) @(
        [IntPtr],                #_In_  HANDLE Pipe,
        [UInt32].MakeByRefType() #_Out_ PULONG ServerProcessId
    ) -EntryPoint GetNamedPipeServerProcessId -SetLastError)

    .EXAMPLES
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $PipeHandle
    )

    [UInt32]$ServerProcessId = 0

    $SUCCESS = $kernel32::GetNamedPipeServerProcessId($PipeHandle, [ref]$ServerProcessId)

    if(-not $SUCCESS)
    {
        throw "[GetNamedPipeServerProcessId] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $ServerProcessId
}