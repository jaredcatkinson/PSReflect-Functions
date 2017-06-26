function WinVerifyTrust
{
    <#
    .SYNOPSIS

    The WinVerifyTrust function performs a trust verification action on a specified object. The function passes the inquiry to a trust provider that supports the action identifier, if one exists.

    .DESCRIPTION

    The WinVerifyTrust function enables applications to invoke a trust provider to verify that a specified object satisfies the criteria of a specified verification operation. The pgActionID parameter identifies the verification operation, and the pWinTrustData parameter identifies the object whose trust is to be verified. A trust provider is a DLL registered with the operating system. A call to WinVerifyTrust forwards that call to the registered trust provider, if there is one, that supports that specified action identifier.
    
    For example, the Software Publisher Trust Provider can verify that an executable image file comes from a trusted software publisher and that the file has not been modified since it was published. In this case, the pWinTrustData parameter specifies the name of the file and the type of file, such as a Microsoft Portable Executable image file.
    
    Each trust provider supports a specific set of actions that it can evaluate. Each action has a GUID that identifies it. A trust provider can support any number of action identifiers, but two trust providers cannot support the same action identifier.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, WINTRUST_DATA (Structure)
    Optional Dependencies: None
    
    (func wintrust WinVerifyTrust ([Int32]) @(
        [IntPtr], #_In_ HWND   hWnd,
        [Guid].MakeByRefType(),   #_In_ GUID   *pgActionID,
        $WINTRUST_DATA.MakeByRefType()  #_In_ LPVOID pWVTData
    ) -EntryPoint WinVerifyTrust)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa388208(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter()]
        [IntPtr]
        $WindowHandle,

        [Parameter(Mandatory = $true)]
        [ValidateSet('DRIVER_ACTION_VERIFY','HTTPSPROV_ACTION','OFFICESIGN_ACTION_VERIFY','WINTRUST_ACTION_GENERIC_CHAIN_VERIFY','WINTRUST_ACTION_GENERIC_VERIFY_V2','WINTRUST_ACTION_TRUSTPROVIDER_TEST')]
        [string]
        $Action,

        [Parameter(Mandatory = $true, ParameterSetName = 'Catalog')]
        [string]
        $CatalogFilePath,

        [Parameter(Mandatory = $true, ParameterSetName = 'Catalog')]
        [string]
        $MemberFilePath,

        [Parameter(Mandatory = $true, ParameterSetName = 'Catalog')]
        [string]
        $MemberTag,

        [Parameter(Mandatory = $true, ParameterSetName = 'File')]
        [string]
        $FilePath
    )

    if(-not $PSBoundParameters.ContainsKey('WindowHandle'))
    {
        $WindowHandle = New-Object IntPtr(-1)
    }

    switch($Action)
    {
        DRIVER_ACTION_VERIFY { $ActionID = New-Object -TypeName Guid('F750E6C3-38EE-11d1-85E5-00C04FC295EE'); break }
        HTTPSPROV_ACTION { $ActionID = New-Object -TypeName Guid('573E31F8-AABA-11d0-8CCB-00C04FC295EE'); break }
        OFFICESIGN_ACTION_VERIFY { $ActionID = New-Object -TypeName Guid('5555C2CD-17FB-11d1-85C4-00C04FC295EE'); break }
        WINTRUST_ACTION_GENERIC_CHAIN_VERIFY { $ActionID = New-Object -TypeName Guid('fc451c16-ac75-11d1-b4b8-00c04fb66ea0'); break }
        WINTRUST_ACTION_GENERIC_VERIFY_V2 { $ActionID = New-Object -TypeName Guid('00AAC56B-CD44-11d0-8CC2-00C04FC295EE'); break }
        WINTRUST_ACTION_TRUSTPROVIDER_TEST { $ActionID = New-Object -TypeName Guid('573E31F8-DDBA-11d0-8CCB-00C04FC295EE'); break }
    }

    $Data = [Activator]::CreateInstance($WINTRUST_DATA)

    switch($PSCmdlet.ParameterSetName)
    {
        Blob
        {

        }
        Catalog
        {
            $Size = $WINTRUST_CATALOG_INFO::GetSize()
            $Info = [Activator]::CreateInstance($WINTRUST_CATALOG_INFO)
            $Info.cbStruct = $Size
            $Info.dwCatalogVersion = 0
            $Info.pcwszCatalogFilePath = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemAuto($CatalogFilePath)
            $Info.pcwszMemberTag = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemAuto($MemberTag)
            $Info.pcwszMemberFilePath = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemAuto($MemberFilePath)
            $Data.dwUnionChoice = $WTD_CHOICE::Catalog
            $Data.fdwRevocationChecks = $WTD_REVOKE::NONE
            $Data.dwProvFlags = 0x2080
            $Data.dwUIContext = $WTD_UICONTEXT::EXECUTE
        }
        Cert
        {

        }
        File
        {
            $Size = $WINTRUST_FILE_INFO::GetSize()
            $Info = [Activator]::CreateInstance($WINTRUST_FILE_INFO)
            $Info.cbStruct = $Size
            $Info.pcwszFilePath = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemAuto($FilePath)
            $Data.dwUnionChoice = $WTD_CHOICE::File
        }
        Sgnr
        {

        }
    }

    $Data.cbStruct = $WINTRUST_DATA::GetSize()
    $Data.pData = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Size)
    $Data.dwUIChoice = $WTD_UI::None
    [System.Runtime.InteropServices.Marshal]::StructureToPtr($Info, $Data.pData, $false)

    $SUCCESS = $wintrust::WinVerifyTrust($WindowHandle, [ref]$ActionID, [ref]$Data)

    if($SUCCESS -eq 0)
    {
        Write-Output $true
    }
    else
    {
        if($SUCCESS -eq 0x80096010)
        {
            Write-Output $false
        }
        else
        {
            throw ([ComponentModel.Win32Exception]$SUCCESS).Message
        }
    }
    
    switch($PSCmdlet.ParameterSetName)
    {
        Blob
        {

        }
        Catalog
        {

        }
        Cert
        {

        }
        File
        {
            [System.Runtime.InteropServices.Marshal]::FreeCoTaskMem($Info.pcwszFilePath)
        }
        Sgnr
        {

        }
    }
}