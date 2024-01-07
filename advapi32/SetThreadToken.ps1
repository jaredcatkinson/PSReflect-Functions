function SetThreadToken
{
    <#
    .SYNOPSIS

    The SetThreadToken function assigns an impersonation token to a thread. The function can also cause a thread to stop using an impersonation token.

    .DESCRIPTION

    .PARAMETER Thread

    A pointer to a handle to the thread to which the function assigns the impersonation token.

    If Thread is NULL, the function assigns the impersonation token to the calling thread.

    .PARAMETER Token

    A handle to the impersonation token to assign to the thread. This handle must have been opened with TOKEN_IMPERSONATE access rights. For more information, see Access Rights for Access-Token Objects.

    If Token is NULL, the function causes the thread to stop using an impersonation token.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func advapi32 SetThreadToken ([bool]) @(
        [IntPtr], # _In_ PHANDLE Thread,
        [IntPtr]  # _In_ HANDLE  Token
    ) -EntryPoint SetThreadToken -SetLastError)

    .LINK

    https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-setthreadtoken

    .EXAMPLE

    #>

    param
    (
        [Parameter()]
        [IntPtr]
        $Thread = [IntPtr]::Zero,

        [Parameter(Mandatory = $true)]
        [IntPtr]
        $Token
    )

    $SUCCESS = $Advapi32::SetThreadToken($Thread, $Token); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    
    if(-not $SUCCESS)
    {
        throw "SetThreadToken Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}