function SamOpenDomain
{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ServerHandle

    .PARAMETER DesiredAccess

    .PARAMETER DomainId

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func samlib SamOpenDomain ([Int32]) @(
        [IntPtr],                #_In_  SAM_HANDLE  ServerHandle
        [Int32],                 #_In_  ACCESS_MASK DesiredAccess
        [byte[]],                #_In_  PSID        DomainId
        [IntPtr].MakeByRefType() #_Out_ PSAM_HANDLE DomainHandle
    ) -EntryPoint SamOpenDomain)
    
    .LINK

    .EXAMPLE
    #>
    
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $ServerHandle,

        [Parameter()]
        [Int32]
        $DesiredAccess,

        [Parameter(Mandatory = $true)]
        [byte[]]
        $DomainId
    )

    $DomainHandle = [IntPtr]::Zero

    $SUCCESS = $samlib::SamOpenDomain($ServerHandle, $DesiredAccess, $DomainId, [ref]$DomainHandle)

    if($SUCCESS -ne 0)
    {
        throw "[SamOpenDomain] error: $($SUCCESS)"
    }

    Write-Output $DomainHandle
}