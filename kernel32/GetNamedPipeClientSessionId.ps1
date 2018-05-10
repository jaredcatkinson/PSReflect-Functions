function GetNamedPipeClientSessionId
{
    <#
    .SYNOPSIS

    Retrieves the client session identifier for the specified named pipe.

    .PARAMETER PipeHandle

    A handle to an instance of a named pipe. This handle must be created by the CreateNamedPipe function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func kernel32 GetNamedPipeClientSessionId ([Bool]) @(
        [IntPtr],                #_In_  HANDLE Pipe,
        [UInt32].MakeByRefType() #_Out_ PULONG ClientSessionId
    ) -EntryPoint GetNamedPipeClientSessionId -SetLastError)

    .EXAMPLES
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $PipeHandle
    )

    [UInt32]$ClientSessionId = 0

    $SUCCESS = $kernel32::GetNamedPipeClientSessionId($PipeHandle, [ref]$ClientSessionId)

    if(-not $SUCCESS)
    {
        throw "[GetNamedPipeClientSessionId] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $ClientSessionId
}