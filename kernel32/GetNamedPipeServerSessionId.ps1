function GetNamedPipeServerSessionId
{
    <#
    .SYNOPSIS

    Retrieves the server session identifier for the specified named pipe.

    .PARAMETER PipeHandle

    A handle to an instance of a named pipe. This handle must be created by the CreateNamedPipe function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func kernel32 GetNamedPipeServerSessionId ([Bool]) @(
        [IntPtr],                #_In_  HANDLE Pipe,
        [UInt32].MakeByRefType() #_Out_ PULONG ServerSessionId
    ) -EntryPoint GetNamedPipeServerSessionId -SetLastError)

    .EXAMPLES
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $PipeHandle
    )

    [UInt32]$ServerSessionId = 0

    $SUCCESS = $kernel32::GetNamedPipeServerSessionId($PipeHandle, [ref]$ServerSessionId)

    if(-not $SUCCESS)
    {
        throw "[GetNamedPipeServerSessionId] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $ServerSessionId
}