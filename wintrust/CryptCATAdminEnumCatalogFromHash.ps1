function CryptCATAdminEnumCatalogFromHash
{
    <#
    .SYNOPSIS

    The CryptCATAdminEnumCatalogFromHash function enumerates the catalogs that contain a specified hash. The hash is typically returned from the CryptCATAdminCalcHashFromFileHandle function. This function has no associated import library. You must use the LoadLibrary and GetProcAddress functions to dynamically link to Wintrust.dll. After the final call to this function, call CryptCATAdminReleaseCatalogContext to release allocated memory.

    .PARAMETER CatAdminHandle

    A handle to a catalog administrator context previously assigned by the CryptCATAdminAcquireContext function.

    .PARAMETER HashPointer

    A pointer to the buffer that contains the hash retrieved by calling CryptCATAdminCalcHashFromFileHandle.

    .PARAMETER HashSize

    Number of bytes in the buffer allocated for pbHash.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    IntPtr hCatAdmin, byte[] pbHash, UInt32 cbHash, UInt32 dwFlags, IntPtr phPrevCatInfo
    (func wintrust CryptCATAdminEnumCatalogFromHash ([IntPtr]) @(
        [IntPtr], #_In_ HCATADMIN hCatAdmin
        [byte[]], #_In_ BYTE      *pbHash
        [UInt32], #_In_ DWORD     cbHash
        [UInt32], #_In_ DWORD     dwFlags
        [IntPtr]  #_In_ HCATINFO  *phPrevCatInfo
    ) -EntryPoint CryptCATAdminEnumCatalogFromHash -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa379892(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $CatAdminHandle,

        [Parameter(Mandatory = $true)]
        [byte[]]
        $HashPointer,

        [Parameter(Mandatory = $true)]
        [UInt32]
        $HashSize,

        [Parameter()]
        [IntPtr]
        $PreviousCatInfoHandle = [IntPtr]::Zero
    )

    $hCatInfo = $wintrust::CryptCATAdminEnumCatalogFromHash($CatAdminHandle, $HashPointer, $HashSize, 0, $PreviousCatInfoHandle); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($hCatInfo -eq $null) 
    {
        throw "[CryptCATAdminEnumCatalogFromHash] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $hCatInfo
}