function Make-Token
{
    param
    (
        [Parameter(Mandatory = $True)]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential
    )

    $hToken = LogonUser1 -Credential $Credential
    ImpersonateLoggedOnUser -TokenHandle $hToken
}