function CryptCATCatalogInfoFromContext
{
    <#
    .SYNOPSIS

    The CryptCATCatalogInfoFromContext function retrieves catalog information from a specified catalog context. This function has no associated import library.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, CATALOG_INFO (Structure)
    Optional Dependencies: None
    
    (func wintrust CryptCATCatalogInfoFromContext ([bool]) @(
        [IntPtr],                      #_In_    HCATINFO     hCatInfo,
        $CATALOG_INFO.MakeByRefType(), #_Inout_ CATALOG_INFO *psCatInfo,
        [UInt32]                       #_In_    DWORD        dwFlags
    ) -EntryPoint CryptCATCatalogInfoFromContext -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa379898(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $CatInfoHandle
    )

    $psCatInfo = [Activator]::CreateInstance($CATALOG_INFO)
    $psCatInfo.cbStruct = $CATALOG_INFO::GetSize()

    $SUCCESS = $wintrust::CryptCATCatalogInfoFromContext($CatInfoHandle, [ref]$psCatInfo, 0); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS) 
    {
        throw "[CryptCATCatalogInfoFromContext] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $psCatInfo.wszCatalogFile
}