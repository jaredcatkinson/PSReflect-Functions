function RevertToSelf
{
    <#
    .SYNOPSIS

    The RevertToSelf function terminates the impersonation of a client application.

    .DESCRIPTION

    A process should call the RevertToSelf function after finishing any impersonation begun by using the DdeImpersonateClient, ImpersonateDdeClientWindow, ImpersonateLoggedOnUser, ImpersonateNamedPipeClient, ImpersonateSelf, ImpersonateAnonymousToken or SetThreadToken function.
    
    An RPC server that used the RpcImpersonateClient function to impersonate a client must call the RpcRevertToSelf or RpcRevertToSelfEx to end the impersonation.
    
    If RevertToSelf fails, your application continues to run in the context of the client, which is not appropriate. You should shut down the process if RevertToSelf fails.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func advapi32 RevertToSelf ([bool]) @() -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa379317(v=vs.85).aspx

    .EXAMPLE

        RevertToSelf
    #>

    $SUCCESS = $Advapi32::RevertToSelf(); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    
    if(-not $SUCCESS)
    {
        throw "RevertToSelf Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}