function Get-LogonSessionImproved
{
    foreach($logonsession in (Get-LogonSession))
    {
        foreach($securitypackage in (EnumerateSecurityPackages))
        {
            try
            {
                switch($securitypackage.Name)
                {
                    "Digest SSP" {$package = 'WDIGEST_SP_NAME'; break}
                    "Schannel SSP" {$package = 'UNISP_NAME'; break}
                    default {$package = $_; break}
                }
            
                $hCredential = AcquireCredentialsHandle -Package $package -CredentialUse BOTH -LogonId $logonsession.LogonId -ErrorAction Stop
                $CredentialName = QueryCredentialsAttributes -CredentialHandle $hCredential
                FreeCredentialsHandle -CredentialHandle $hCredential

                $props = @{
                    LogonId = $logonsession.LogonId
                    LogonType = $logonsession.LogonType
                    LogonTime = $logonsession.LogonTime
                    AuthenticationPackage = $logonsession.AuthenticationPackage
                    SecurityPackage = $securitypackage.Name
                    Username = $logonsession.Username
                    DnsDomainName = $logonsession.DnsDomainName
                    Upn = $logonsession.Upn
                    CredentialUsername = $CredentialName
                }

                New-Object -TypeName psobject -Property $props
            }
            catch
            {
           
            }
        }
    }
}