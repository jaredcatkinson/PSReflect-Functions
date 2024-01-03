function ConvertSecurityDescriptorToStringSecurityDescriptor
{
    <#
    .SYNOPSIS

    The ConvertSecurityDescriptorToStringSecurityDescriptor function converts a security descriptor to a string format. You can use the string format to store or transmit the security descriptor.

    .DESCRIPTION

    If the DACL is NULL, and the SE_DACL_PRESENT control bit is set in the input security descriptor, the function fails.

    If the DACL is NULL, and the SE_DACL_PRESENT control bit is not set in the input security descriptor, the resulting security descriptor string does not have a D: component. For more information, see Security Descriptor String Format.

    .PARAMETER SecurityDescriptor

    A pointer to the security descriptor to convert. The security descriptor can be in absolute or self-relative format.

    .PARAMETER SecurityInformation

    Specifies a combination of the SECURITY_INFORMATION bit flags to indicate the components of the security descriptor to include in the output string.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func advapi32 ConvertSecurityDescriptorToStringSecurityDescriptor ([Bool]) @(
        [IntPtr],                 # [in]  PSECURITY_DESCRIPTOR SecurityDescriptor
        [UInt32],                 # [in]  DWORD                RequestedStringSDRevision
        [UInt32],                 # [in]  SECURITY_INFORMATION SecurityInformation
        [IntPtr].MakeByRefType(), # [out] LPSTR                *StringSecurityDescriptor
        [UInt32].MakeByRefType()  # [out] PULONG               StringSecurityDescriptorLen
    ) -EntryPoint ConvertSecurityDescriptorToStringSecurityDescriptor)

    .LINK

    https://learn.microsoft.com/en-us/windows/win32/api/securitybaseapi/nf-securitybaseapi-isvalidsecuritydescriptor

    .EXAMPLE
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [IntPtr]
        $SecurityDescriptor,

        [Parameter()]
        [UInt32]
        $SecurityInformation = 1
    )

    $StringSecurityDescriptor = [IntPtr]::Zero
    $StringSecurityDescriptorLen = 0

    $SUCCESS = $Advapi32::ConvertSecurityDescriptorToStringSecurityDescriptor($SecurityDescriptor, 1, 15, [ref]$StringSecurityDescriptor, [ref]$StringSecurityDescriptorLen); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($SUCCESS -eq 0)
    {
        throw "Error: $(([ComponentModel.Win32Exception]$LastError).Message)"
    }

    Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($StringSecurityDescriptor))
}