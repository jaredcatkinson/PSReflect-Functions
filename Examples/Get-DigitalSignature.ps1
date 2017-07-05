function Get-DigitalSignature
{
    param
    (
        [Parameter()]
        [string]
        $FilePath
    )

    # Check if the requested file exists
    if(Test-Path -Path $FilePath)
    {
        # Check for Authenticode Signature (These are embedded signatures)
        try
        {
            $isAuthenticodeSigned = WinVerifyTrust -FilePath $FilePath -Action WINTRUST_ACTION_GENERIC_VERIFY_V2
        }
        catch
        {
            
        }

        # Check for Catalog Signature
        try
        {
            # We will first check to see if this system has CryptCATAdminAcquireContext2
            # If this function does not exist, then we can assume we are dealing with an older OS version and Catalog V1
            $hModule = LoadLibrary -ModuleName wintrust
            $ProcAddr = GetProcAddress -ModuleHandle $hModule -FunctionName CryptCATAdminAcquireContext2

            # Newer versions of Windows have two versions of Catalogs (V1 and V2)
            # Catalog V1 uses SHA1 hashes as MemberTags, while Catalog V2 uses SHA256 hashes as MemberTags
            # We are going to first try to use SHA256 hash and then fail back to a SHA1 hash            
            try
            {
                $hCatAdmin = CryptCATAdminAcquireContext2 -Subsystem DRIVER_ACTION_VERIFY -HashAlgorithm SHA256
                $hFile = [IO.File]::OpenRead($FilePath).SafeFileHandle.DangerousGetHandle()
                $Hash,$hashSize,$MemberTag = CryptCATAdminCalcHashFromFileHandle2 -CatalogHandle $hCatAdmin -FileHandle $hFile
                $hCatInfo = CryptCATAdminEnumCatalogFromHash -CatAdminHandle $hCatAdmin -HashPointer $Hash -HashSize $hashSize -PreviousCatInfoHandle ([IntPtr]::Zero)
                $CatalogFile = CryptCATCatalogInfoFromContext -CatInfoHandle $hCatInfo
                $isCatalogSigned = WinVerifyTrust -Action WINTRUST_ACTION_GENERIC_VERIFY_V2 -CatalogFilePath $CatalogFile -MemberFilePath $FilePath -MemberTag $MemberTag
            
                CryptCATAdminReleaseContext -CatAdminHandle $hCatAdmin
            }
            # Now we can fall back to check if the file is signed in a V1 Catalog (SHA1)
            catch
            {
                if(-not $isCatalogSigned)
                {
                    $hCatAdmin = CryptCATAdminAcquireContext2 -Subsystem DRIVER_ACTION_VERIFY -HashAlgorithm SHA1
                    $hFile = [IO.File]::OpenRead($FilePath).SafeFileHandle.DangerousGetHandle()
                    $Hash,$hashSize,$MemberTag = CryptCATAdminCalcHashFromFileHandle2 -CatalogHandle $hCatAdmin -FileHandle $hFile
                    $hCatInfo = CryptCATAdminEnumCatalogFromHash -CatAdminHandle $hCatAdmin -HashPointer $Hash -HashSize $hashSize -PreviousCatInfoHandle ([IntPtr]::Zero)
                    $CatalogFile = CryptCATCatalogInfoFromContext -CatInfoHandle $hCatInfo
                    $isCatalogSigned = WinVerifyTrust -Action WINTRUST_ACTION_GENERIC_VERIFY_V2 -CatalogFilePath $CatalogFile -MemberFilePath $FilePath -MemberTag $MemberTag                

                    CryptCATAdminReleaseContext -CatAdminHandle $hCatAdmin
                }
            }
        }
        # Looks like CryptCATAdminAcquireContext2 is not available, so we can just use CryptCATAdminAcquireContext because we know we are dealing with SHA1 hashes
        catch
        {
            $hCatAdmin = CryptCATAdminAcquireContext -Subsystem DRIVER_ACTION_VERIFY
            $hFile = [IO.File]::OpenRead($FilePath).SafeFileHandle.DangerousGetHandle()
            $Hash,$hashSize,$MemberTag = CryptCATAdminCalcHashFromFileHandle -FileHandle $hFile
            $hCatInfo = CryptCATAdminEnumCatalogFromHash -CatAdminHandle $hCatAdmin -HashPointer $Hash -HashSize $hashSize -PreviousCatInfoHandle ([IntPtr]::Zero)
            $CatalogFile = CryptCATCatalogInfoFromContext -CatInfoHandle $hCatInfo
            $isCatalogSigned = WinVerifyTrust -Action WINTRUST_ACTION_GENERIC_VERIFY_V2 -CatalogFilePath $CatalogFile -MemberFilePath $FilePath -MemberTag $MemberTag

            CryptCATAdminReleaseContext -CatAdminHandle $hCatAdmin
        }
        
        # Return the results
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name isAuthenticodeSigned -Value $isAuthenticodeSigned
        $obj | Add-Member -MemberType NoteProperty -Name isCatalogSigned -Value $isCatalogSigned
        
        Write-Output $obj
    }
    # The file does not exist, so throw an error
    else
    {
        throw [System.IO.FileNotFoundException]
    }
}