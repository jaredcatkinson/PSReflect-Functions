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
        # Get a Handle to the requested file
        $hFile = [IO.File]::OpenRead($FilePath).SafeFileHandle.DangerousGetHandle()

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
        }
        # Looks like CryptCATAdminAcquireContext2 is not available, so we can just use CryptCATAdminAcquireContext because we know we are dealing with SHA1 hashes
        catch
        {
            $hCatAdmin = CryptCATAdminAcquireContext -Subsystem DRIVER_ACTION_VERIFY
            $Hash = CryptCATAdminCalcHashFromFileHandle -FileHandle $hFile
            $hCatInfo = CryptCATAdminEnumCatalogFromHash -CatAdminHandle $hCatAdmin -HashPointer $Hash -HashSize $hashSize -PreviousCatInfoHandle ([IntPtr]::Zero)
        }

        # If ProcAddr does not equal 0, then we know that CryptCATAdminAcquireContext2 is available on this system
        if($ProcAddr -ne 0)
        {
            # Newer versions of Windows have two versions of Catalogs (V1 and V2)
            # Catalog V1 uses SHA1 hashes as MemberTags, while Catalog V2 uses SHA256 hashes as MemberTags
            # We are going to first try to lookup using the SHA256 hash and then fail back to a SHA1 hash if needed           
            $hCatAdmin = CryptCATAdminAcquireContext2 -Subsystem DRIVER_ACTION_VERIFY -HashAlgorithm SHA256
            $Hash = CryptCATAdminCalcHashFromFileHandle2 -CatalogHandle $hCatAdmin -FileHandle $hFile
            $hCatInfo = CryptCATAdminEnumCatalogFromHash -CatAdminHandle $hCatAdmin -HashPointer $Hash.HashBytes -HashSize $Hash.HashLength -PreviousCatInfoHandle ([IntPtr]::Zero)

            # If hCatInfo is 0, then we know that we could not find the SHA256 hash in any catalog
            # We can now fall back to SHA1 as our algorithm
            if($hCatInfo -eq 0)
            {
                # Release the Context from the first call to CryptCATAdminAcquireContext2
                CryptCATAdminReleaseContext -CatAdminHandle $hCatAdmin 
                
                # Attempt to lookup the file based on the SHA1 hash
                $hCatAdmin = CryptCATAdminAcquireContext2 -Subsystem DRIVER_ACTION_VERIFY -HashAlgorithm SHA1
                $Hash,$hashSize,$MemberTag = CryptCATAdminCalcHashFromFileHandle2 -CatalogHandle $hCatAdmin -FileHandle $hFile
                $hCatInfo = CryptCATAdminEnumCatalogFromHash -CatAdminHandle $hCatAdmin -HashPointer $Hash.HashBytes -HashSize $Hash.HashLength -PreviousCatInfoHandle ([IntPtr]::Zero)

                if($hCatInfo -eq 0)
                {
                    $isCatalogSigned = $false
                }
            }
            
            if($hCatInfo -ne 0)
            {
                $CatalogFile = CryptCATCatalogInfoFromContext -CatInfoHandle $hCatInfo
                $isCatalogSigned = WinVerifyTrust -Action WINTRUST_ACTION_GENERIC_VERIFY_V2 -CatalogFilePath $CatalogFile -MemberFilePath $FilePath -MemberTag $Hash.MemberTag
            }
            
            # Release the Context from the most recent call to CryptCATAdminAcquireContext2
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