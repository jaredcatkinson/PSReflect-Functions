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

    $HashLength = 100

    $HashBytes = New-Object -TypeName byte[]($HashLength)

    $SUCCESS = $wintrust::CryptCATAdminCalcHashFromFileHandle($FileHandle, [ref]$HashLength, $HashBytes, 0); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS)
    {
        throw "[CryptCATAdminCalcHashFromFileHandle]: Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
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