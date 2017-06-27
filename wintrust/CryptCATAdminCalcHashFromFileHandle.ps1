function CryptCATAdminCalcHashFromFileHandle
{
    <#
    .SYNOPSIS

    The CryptCATAdminCalcHashFromFileHandle function calculates the hash for a file. 
    
    .PARAMETER FileHandle

    A handle to the file whose hash is being calculated. This parameter cannot be NULL and must be a valid file handle.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    (func wintrust CryptCATAdminCalcHashFromFileHandle ([bool]) @(
        [IntPtr],                 #_In_    HANDLE hFile
        [UInt32].MakeByRefType(), #_Inout_ DWORD  *pcbHash
        [IntPtr],                 #_In_    BYTE   *pbHash
        [UInt32]                  #_In_    DWORD  dwFlags
    ) -EntryPoint CryptCATAdminCalcHashFromFileHandle)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa379891(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $FileHandle
    )

    $pcbHash = 100

    $pbHash = New-Object -TypeName byte[]($pcbHash)

    $SUCCESS = $wintrust::CryptCATAdminCalcHashFromFileHandle($FileHandle, [ref]$pcbHash, $pbHash, 0)

    if(-not $SUCCESS)
    {
        throw "[CryptCATAdminCalcHashFromFileHandle]: Unable to release Catalog Admin Handle $($CatAdminHandle)"
    }

    $hex = New-Object -TypeName System.Text.StringBuilder
    for($i = 0; $i -lt $pcbHash; $i++)
    {	
        $hex.AppendFormat("{0:X2}", $pbHash[$i]) | Out-Null
    }

    Write-Output $pbHash, $pcbHash, $hex.ToString()
}