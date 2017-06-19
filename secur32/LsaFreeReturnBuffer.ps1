function LsaFreeReturnBuffer
{
    <#
    .SYNOPSIS

    The LsaFreeReturnBuffer function frees the memory used by a buffer previously allocated by the LSA.

    .DESCRIPTION

    Some of the LSA authentication functions allocate memory buffers to hold returned information, for example, LsaLogonUser and LsaCallAuthenticationPackage. Your application should call LsaFreeReturnBuffer to free these buffers when they are no longer needed.

    .PARAMETER Buffer

    Pointer to the buffer to be freed.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, LsaNtStatusToWinError (Function)
    Optional Dependencies: None

    (func secur32 LsaFreeReturnBuffer ([UInt32]) @(
        [IntPtr] #_In_ PVOID Buffer
    ) -EntryPoint LsaFreeReturnBuffer)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa378279(v=vs.85).aspx

    .EXAMPLE

    LsaFreeReturnBuffer -Buffer $Buffer
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $Buffer
    )

    $SUCCESS = $Secur32::LsaFreeReturnBuffer($Buffer)

    if($SUCCESS -ne 0)
    {
        $WinErrorCode = LsaNtStatusToWinError -NtStatus $success
        $LastError = [ComponentModel.Win32Exception]$WinErrorCode
        throw "LsaFreeReturnBuffer Error: $($LastError.Message)"
    }
}