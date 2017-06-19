function SamOpenUser
{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER DomainHandle

    .PARAMETER DesiredAccess

    .PARAMETER UserId

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func samlib SamOpenUser ([Int32]) @(
        [IntPtr],                #_In_  SAM_HANDLE  DomainHandle
        [Int32],                 #_In_  ACCESS_MASK DesiredAccess
        [Int32],                 #_In_  ULONG       UserId
        [IntPtr].MakeByRefType() #_Out_ PSAM_HANDLE UserHandle
    ) -EntryPoint SamOpenUser)
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $DomainHandle,

        [Parameter()]
        [Int32]
        $DesiredAccess,

        [Parameter(Mandatory = $true)]
        [Int32]
        $UserId
    )

    $UserHandle = [IntPtr]::Zero

    $SUCCESS = $samlib::SamOpenUser($DomainHandle, $DesiredAccess, $UserId, [ref]$UserHandle)

    if($SUCCESS -ne 0)
    {
        throw "[SamOpenUser] error: $($SUCCESS)"
    }

    Write-Output $UserHandle
}