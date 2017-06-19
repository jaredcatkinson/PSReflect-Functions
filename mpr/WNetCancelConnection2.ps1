function WNetCancelConnection2 {
    <#
    .SYNOPSIS

    Destroys a connection created by WNetAddConnection2W.  

    .DESCRIPTION

    This function uses WNetCancelConnection2 to destroy a connection created by
    WNetAddConnection2W. If a -Path isn't specified, a -ComputerName is required to
    'unmount' \\$ComputerName\IPC$.

    .PARAMETER ComputerName

    Specifies the system to remove a \\ComputerName\IPC$ connection for.

    .PARAMETER Path

    Specifies the remote \\UNC\path to remove the connection for.

    .NOTES

    Author: Will Schroeder (@harmj0y)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func Mpr WNetCancelConnection2 ([Int]) @(
        [String],       # _In_ LPCTSTR lpName,
        [Int],          # _In_ DWORD   dwFlags
        [Bool]          # _In_ BOOL    fForce
    ) -EntryPoint WNetCancelConnection2)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa385427(v=vs.85).aspx

    .EXAMPLE

    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding(DefaultParameterSetName = 'ComputerName')]
    Param(
        [Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'ComputerName', ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName,

        [Parameter(Position = 0, ParameterSetName = 'Path', Mandatory = $True)]
        [ValidatePattern('\\\\.*\\.*')]
        [String[]]
        $Path
    )

    PROCESS {
        $Paths = @()
        if ($PSBoundParameters['ComputerName']) {
            ForEach ($TargetComputerName in $ComputerName) {
                $TargetComputerName = $TargetComputerName.Trim('\')
                $Paths += ,"\\$TargetComputerName\IPC$"
            }
        }
        else {
            $Paths += ,$Path
        }

        ForEach ($TargetPath in $Paths) {
            Write-Verbose "[WNetCancelConnection2] Attempting to unmount: $TargetPath"
            $Result = $Mpr::WNetCancelConnection2($TargetPath, 0, $True)

            if ($Result -eq 0) {
                Write-Verbose "[WNetCancelConnection2] '$TargetPath' successfully ummounted"
            }
            else {
                Throw "[WNetCancelConnection2] error unmounting $TargetPath : $(([ComponentModel.Win32Exception]$Result).Message)"
            }
        }
    }
}