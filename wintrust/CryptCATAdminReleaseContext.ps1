function CryptCATAdminReleaseContext
{
    <#
    .SYNOPSIS

    The CryptCATAdminReleaseContext function releases the handle previously assigned by the CryptCATAdminAcquireContext function. 

    .PARAMETER CatAdminHandle

    Catalog administrator context handle previously assigned by a call to the CryptCATAdminAcquireContext function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func wintrust CryptCATAdminReleaseContext ([bool]) @(
        [IntPtr], #_In_ HCATADMIN hCatAdmin
        [UInt32]  #_In_ DWORD     dwFlags
    ) -EntryPoint CryptCATAdminReleaseContext)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa379894(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $CatAdminHandle
    )

    $SUCCESS = $wintrust::CryptCATAdminReleaseContext($CatAdminHandle, 0)

    if(-not $SUCCESS)
    {
        throw "[CryptCATAdminReleaseContext]: Unable to release Catalog Admin Handle $($CatAdminHandle)"
    }
}