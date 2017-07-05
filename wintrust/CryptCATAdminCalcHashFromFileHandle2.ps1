function CryptCATAdminCalcHashFromFileHandle2
{
    <#
    .SYNOPSIS

    The CryptCATAdminCalcHashFromFileHandle2 function calculates the hash for a file by using the specified algorithm.
    
    .PARAMETER CatalogHandle

    Handle of an open catalog administrator context. For more information, see CryptCATAdminAcquireContext2.

    .PARAMETER FileHandle

    A handle to the file whose hash is being calculated. This parameter cannot be NULL and must be a valid file handle.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func wintrust CryptCATAdminCalcHashFromFileHandle2 ([bool]) @(
        [IntPtr],                 #_In_    HCATADMIN hCatAdmin
        [IntPtr],                 #_In_    HANDLE    hFile
        [UInt32].MakeByRefType(), #_Inout_ DWORD     *pcbHash
        [byte[]],                 #_In_    BYTE      *pbHash
        [UInt32]                  #_In_    DWORD     dwFlags
    ) -EntryPoint CryptCATAdminCalcHashFromFileHandle2)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/hh968151(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $CatalogHandle,

        [Parameter(Mandatory = $true)]
        [IntPtr]
        $FileHandle
    )

    <#
    $HashLength = 0

    $SUCCESS = $wintrust::CryptCATAdminCalcHashFromFileHandle2($CatalogHandle, $FileHandle, [ref]$HashLength, @(), 0); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    Write-Host "SUCCESS: $($SUCCESS)"
    Write-Host "LastError: $($LastError)"

    if((-not $SUCCESS) -and ($LastError -ne 122))
    {
        throw "[CryptCATAdminCalcHashFromFileHandle2]: Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Host $HashLength
    #>

    $HashLength = 64
    $HashBytes = New-Object -TypeName Byte[]($HashLength)

    $SUCCESS = $wintrust::CryptCATAdminCalcHashFromFileHandle2($CatalogHandle, $FileHandle, [ref]$HashLength, $HashBytes, 0); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS)
    {
        throw "[CryptCATAdminCalcHashFromFileHandle2]: Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    $MemberTag = New-Object -TypeName System.Text.StringBuilder
    for($i = 0; $i -lt $HashLength; $i++)
    {	
        $MemberTag.AppendFormat("{0:X2}", $HashBytes[$i]) | Out-Null
    }

    $obj = New-Object -TypeName psobject

    $obj | Add-Member -MemberType NoteProperty -Name HashBytes -Value $HashBytes
    $obj | Add-Member -MemberType NoteProperty -Name HashLength -Value $HashLength
    $obj | Add-Member -MemberType NoteProperty -Name MemberTag -Value $MemberTag.ToString()
    
    Write-Output $obj
}