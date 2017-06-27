function SamConnect
{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ServerName

    .PARAMETER DesiredAccess

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, UNICODE_STRING (Structure)
    Optional Dependencies: None

    (func samlib SamConnect ([Int32]) @(
        [IntPtr],                 #_Inout_opt_ PUNICODE_STRING    ServerName
        [IntPtr].MakeByRefType(), #_Out_       PSAM_HANDLE        ServerHandle
        [Int32],                  #_In_        ACCESS_MASK        DesiredAccess
        [bool]                    #_In_        POBJECT_ATTRIBUTES ObjectAttributes
    ) -EntryPoint SamConnect)

    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter()]
        [string]
        $ServerName,

        [Parameter()]
        [Int32]
        $DesiredAccess
    )

    $ServerHandle = [IntPtr]::Zero

    if($PSBoundParameters.ContainsKey('ServerName'))
    {
        [Activator]::CreateInstance($UNICODE_STRING)

        $SUCCESS = $samlib::SamConnect($ServerName, [ref]$ServerHandle, $DesiredAccess, $false)
    }
    else
    {
        $SUCCESS = $samlib::SamConnect_IntPtr([IntPtr]::Zero, [ref]$ServerHandle, $DesiredAccess, $false)
    }

    if($SUCCESS -ne 0)
    {
        throw "[SamConnect] error: $($SUCCESS)"
    }

    Write-Output $ServerHandle
}