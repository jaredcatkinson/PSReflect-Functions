function CryptCATStoreFromHandle
{
    <#
    .SYNOPSIS

    The CryptCATStoreFromHandle function retrieves a CRYPTCATSTORE structure from a catalog handle.

    .PARAMETER CatalogHandle

    A handle to the catalog obtained from the CryptCATOpen or CryptCATHandleFromStore function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func wintrust CryptCATStoreFromHandle ([IntPtr]) @(
        [IntPtr] #_In_ HANDLE hCatalog
    )

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/bb736354(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $CatalogHandle
    )

    $pCRYPTCATSTORE = $wintrust::CryptCATStoreFromHandle($CatalogHandle)

    Write-Output $pCRYPTCATSTORE

}