function DeleteSecurityPackage
{
    <#
    .SYNOPSIS

    Deletes a security support provider from the list of providers supported by Microsoft Negotiate.

    .PARAMETER PackageName

    The name of the security provider to delete.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func secur32 DeleteSecurityPackage ([UInt32]) @(
        [string] #_In_ LPTSTR pszPackageName
    ) -EntryPoint DeleteSecurityPackage)

    .LINK
    
    https://msdn.microsoft.com/en-us/library/windows/desktop/dd401610(v=vs.85).aspx
    
    .EXAMPLE

    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $PackageName
    )

    $SUCCESS = $Secur32::DeleteSecurityPackages($PackageName)

    if($SUCCESS -eq 0)
    {
        throw "DeleteSecurityPackage Error: $($SUCCESS)"
    }
}