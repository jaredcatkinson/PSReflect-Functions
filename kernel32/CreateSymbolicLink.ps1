function CreateSymbolicLink
{
<#
    .SYNOPSIS
    Creates a symbolic link in the filesystem.

    .DESCRIPTION
    Creates a symbolic link in the filesystem. Requires Vista or higher. Requires administrator access.

    .NOTES
    (func kernel32 CreateSymbolicLink ([bool]) @(
        [String],                 #_Out_    LPCTSTR   lpSymlinkPath,
        [String],                 #_In_     LPCTSTR   lpTargetPath,
        [UInt32]                  #_In_     DWORD     SYMBOLIC_LINK_FLAG
        ) -EntryPoint CreateSymbolicLink -SetLastError)
    )


    Author: Matt Green (@mgreen27)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, SYMBOLIC_LINK_FLAG (enums)
    Optional Dependencies: None
#>
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $lpSymlinkPath,
        
        [Parameter(Mandatory = $true)]
        [String]
        $lpTargetPath,
        
        [Parameter(Mandatory = $true)]
        [UInt32]
        $dwFlags
    )

    $SUCCESS = $kernel32::CreateSymbolicLink($lpSymlinkPath, $lpTargetPath, $dwFlags); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS)
    {
        throw "[CreateSymbolicLink] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}