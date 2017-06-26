function Test-DigitalSignature
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $FilePath
    )

    # Check if the requested file even exists
    if(Test-Path -Path $FilePath)
    {
        # Try to get the Authenticode Signature with Get-AuthenticodeSignature
        $signature = Get-AuthenticodeSignature -FilePath $FilePath
        
        # Get-AuthenticodeSignature does not check Catalog Signatures on Windows 7 and older OS's
        # We will supplement Get-AuthenticodeSignature by checking for a Catalog Signature
        if($signature.Status -eq 'NotSigned')
        {
            # The file does not have an embedded signature, lets check if it is catalog signed
            $hFile = CreateFile -FileName $FilePath -DesiredAccess 2147483648 -ShareMode 3 -SecurityAttributes ([IntPtr]::Zero) -CreationDisposition 3 -FlagsAndAttributes 0x80 -TemplateHandle ([IntPtr]::Zero)
            $Hash,$hashSize,$MemberTag = CryptCATAdminCalcHashFromFileHandle -FileHandle $hFile
            $hCatAdmin = CryptCATAdminAcquireContext -Subsystem NONE
            $hCatInfo = CryptCATAdminEnumCatalogFromHash -CatAdminHandle $hCatAdmin -HashPointer $Hash -HashSize $hashSize -PreviousCatInfoHandle ([IntPtr]::Zero)
            $CatalogFile = CryptCATCatalogInfoFromContext -CatInfoHandle $hCatInfo
            $Trusted = WinVerifyTrust -Action WINTRUST_ACTION_GENERIC_VERIFY_V2 -CatalogFilePath $CatalogFile -MemberFilePath $FilePath -MemberTag $MemberTag
            if($Trusted)
            {
                $s = Get-AuthenticodeSignature -FilePath $CatalogFile
                
                $obj = New-Object -TypeName psobject
                
                $obj | Add-Member -MemberType NoteProperty -Name SignerCertificate -Value $s.SignerCertificate
                $obj | Add-Member -MemberType NoteProperty -Name TimeStamperCertificate -Value $s.TimeStamperCertificate
                $obj | Add-Member -MemberType NoteProperty -Name Status -Value $s.Status
                $obj | Add-Member -MemberType NoteProperty -Name StatusMessage -Value $s.StatusMessage
                $obj | Add-Member -MemberType NoteProperty -Name Path -Value $FilePath
                
                Write-Output $obj
                
            }
            else
            {
                Write-Output $signature
            }
            CryptCATAdminReleaseContext -CatAdminHandle $hCatAdmin
        }
        else
        {
           Write-Output $signature 
        }
    }
    else
    {
        throw [System.IO.FileNotFoundException]
    }
}