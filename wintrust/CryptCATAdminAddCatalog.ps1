function CryptCATAdminAddCatalog
{
    <#
    .SYNOPSIS

    The CryptCATAdminAddCatalog function adds a catalog to the catalog database. The catalog database is an index that associates file hashes with the catalogs that contain them. It is used to speed the identification of the catalogs when verifying the file signature. This function is the only supported way to programmatically add catalogs to the Windows catalog database.

    .PARAMETER CatAdmin

    Handle previously assigned by the CryptCATAdminAcquireContext function.

    .PARAMETER CatalogFile

    Specifies the fully qualified path of the catalog to be added.

    .PARAMETER SelectBaseName

    Specifies the name of the catalog when it is stored. If this parameter is not specified, then a unique name will be generated for the catalog.

    .PARAMETER Hardlink

    Specifies that the catalog specified in the call will be hard-linked to rather than copied. Hard-linking instead of copying a catalog reduces the amount of disk space required by Windows. Hardlinking is supported in Win8+.
    
    .NOTES

    Author: Matt Graeber (@mattifestation)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func wintrust CryptCATAdminAddCatalog ([IntPtr]) @(
        [IntPtr],               # _In_ HCATADMIN hCatAdmin,
        [String],               # _In_ WCHAR     *pwszCatalogFile,
        [IntPtr],               # _In_ WCHAR     *pwszSelectBaseName,
        [UInt32]                # _In_ DWORD     dwFlags
    ) -EntryPoint CryptCATAdminAddCatalog -SetLastError -Charset Unicode)

    Call CryptCATAdminReleaseCatalogContext to free the memory associated with the Catalog Context returned if not NULL.

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa379890(v=vs.85).aspx

    .EXAMPLE

    $CATContext = CryptCATAdminAcquireContext -Subsystem DRIVER_ACTION_VERIFY
    $CATInfo = CryptCATAdminAddCatalog -CatAdmin $CATContext -CatalogFile .\Test.cat -SelectBaseName Foo.cat
    CryptCATAdminReleaseCatalogContext -CatAdminHandle $CATContext -CatInfoHandle $CATInfo

    Description
    -----------
    Adds Test.cat to the catalog store as Foo.cat.

    .EXAMPLE

    $CATContext = CryptCATAdminAcquireContext -Subsystem DRIVER_ACTION_VERIFY
    $CATInfo = CryptCATAdminAddCatalog -CatAdmin $CATContext -CatalogFile .\Test.cat
    CryptCATAdminReleaseCatalogContext -CatAdminHandle $CATContext -CatInfoHandle $CATInfo

    Description
    -----------
    Adds Test.cat to the catalog store. A unique name will be generated for the catalog file in the catalog store.

    .EXAMPLE

    $CATContext = CryptCATAdminAcquireContext -Subsystem DRIVER_ACTION_VERIFY
    $CATInfo = CryptCATAdminAddCatalog -CatAdmin $CATContext -CatalogFile .\Test.cat -Hardlink
    CryptCATAdminReleaseCatalogContext -CatAdminHandle $CATContext -CatInfoHandle $CATInfo

    Description
    -----------
    Creates a hardlink to Test.cat in the catalog store. A unique name will be generated for the catalog file in the catalog store.
    #>

    [OutputType([IntPtr])]
    param
    (
        [Parameter(Mandatory = $True)]
        [IntPtr]
        $CatAdmin,

        [Parameter(Mandatory = $True)]
        [String]
        [ValidateNotNullOrEmpty()]
        $CatalogFile,

        [String]
        [ValidateNotNullOrEmpty()]
        $SelectBaseName,

        [Switch]
        $Hardlink
    )

    $CatalogFileFullPath = Resolve-Path $CatalogFile -ErrorAction Stop

    if ($CatAdmin -eq [IntPtr]::Zero) { throw 'Invalid handle received' }

    if ($SelectBaseName -and (-not $SelectBaseName.EndsWith('.cat'))) {
        throw 'The specified catalog basename must end with .cat.'
    }

    if ($SelectBaseName) {
        $BaseName = [Runtime.InteropServices.Marshal]::StringToHGlobalUni($SelectBaseName)
    } else { 
        $BaseName = [IntPtr]::Zero
    }

    # mscat.h
    $CRYPTCAT_ADDCATALOG_NONE = 0
    $CRYPTCAT_ADDCATALOG_HARDLINK = 1

    if ($Hardlink) { $Flags = $CRYPTCAT_ADDCATALOG_HARDLINK } else { $Flags = $CRYPTCAT_ADDCATALOG_NONE }

    $HCatInfo = $wintrust::CryptCATAdminAddCatalog($CatAdmin, $CatalogFileFullPath.Path, $BaseName, $Flags); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if ($BaseName -ne [IntPtr]::Zero) { [Runtime.InteropServices.Marshal]::FreeHGlobal($BaseName) }

    if($HCatInfo -eq [IntPtr]::Zero)
    {
        throw "[CryptCATAdminAddCatalog] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $HCatInfo
}