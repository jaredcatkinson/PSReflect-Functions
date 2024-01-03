function IsValidSecurityDescriptor
{
    <#
    .SYNOPSIS

    The IsValidSecurityDescriptor function determines whether the components of a security descriptor are valid.

    .DESCRIPTION

    The IsValidSecurityDescriptor function checks the validity of the components that are present in the security descriptor. It does not verify whether certain components are present nor does it verify the contents of the individual ACE or ACL.

    .PARAMETER SecurityDescriptor

    A pointer to a SECURITY_DESCRIPTOR structure that the function validates.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func advapi32 IsValidSecurityDescriptor ([Bool]) @(
        [IntPtr] #[in] PSECURITY_DESCRIPTOR pSecurityDescriptor
    ) -EntryPoint IsValidSecurityDescriptor)

    .LINK

    https://learn.microsoft.com/en-us/windows/win32/api/securitybaseapi/nf-securitybaseapi-isvalidsecuritydescriptor

    .EXAMPLE
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [IntPtr]
        $SecurityDescriptor
    )

    $Result = $Advapi32::IsValidSecurityDescriptor($SecurityDescriptor)

    return $Result
}