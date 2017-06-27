function CryptCATAdminReleaseCatalogContext
{
    <#
    .SYNOPSIS

    The CryptCATAdminReleaseCatalogContext function releases a handle to a catalog context previously returned by the CryptCATAdminAddCatalog function.

    .PARAMETER CatAdminHandle

    Handle previously assigned by the CryptCATAdminAcquireContext function.

    .PARAMETER CatInfoHandle

    Handle previously assigned by the CryptCATAdminAddCatalog function or the CryptCATAdminEnumCatalogFromHash function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func wintrust CryptCATAdminReleaseCatalogContext ([bool]) @(
        [IntPtr], #_In_ HCATADMIN hCatAdmin
        [IntPtr], #_In_ HCATINFO  hCatInfo
        [UInt32]  #_In_ DWORD     dwFlags
    ) -EntryPoint CryptCATAdminReleaseCatalogContext)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa379893(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $CatAdminHandle,

        [Parameter(Mandatory = $true)]
        [IntPtr]
        $CatInfoHandle
    )

    $SUCCESS = $wintrust::CryptCATAdminReleaseCatalogContext($CatAdminHandle, $CatInfoHandle, 0)

    if(-not $SUCCESS)
    {
        throw "[CryptCATAdminReleaseCatalogContext]: Unable to release Catalog Handle $($CatInfoHandle)"
    }
}