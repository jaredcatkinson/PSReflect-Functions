function WNetAddConnection2W {
<#
.SYNOPSIS

Pseudo "mounts" a connection to a remote path using the specified
credential object, allowing for access of remote resources. If a -Path isn't
specified, a -ComputerName is required to pseudo-mount IPC$.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect  

.DESCRIPTION

This function uses WNetAddConnection2W to make a 'temporary' (i.e. not saved) connection
to the specified remote -Path (\\UNC\share) with the alternate credentials specified in the
-Credential object. If a -Path isn't specified, a -ComputerName is required to pseudo-mount IPC$.

To destroy the connection, use Remove-RemoteConnection with the same specified \\UNC\share path
or -ComputerName.

.PARAMETER ComputerName

Specifies the system to add a \\ComputerName\IPC$ connection for.

.PARAMETER Path

Specifies the remote \\UNC\path to add the connection for.

.PARAMETER Credential

A [Management.Automation.PSCredential] object of alternate credentials
for connection to the remote system.

.NOTES

(func Mpr WNetAddConnection2W ([Int]) @(
    $NETRESOURCEW,      # _In_ LPNETRESOURCE lpNetResource
    [String],           # _In_ LPCTSTR       lpPassword
    [String],           # _In_ LPCTSTR       lpUsername
    [UInt32]            # _In_ DWORD         dwFlags
))

.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/aa385413(v=vs.85).aspx

.EXAMPLE

$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('TESTLAB\dfm.a', $SecPassword)
WNetAddConnection2W -ComputerName "PRIMARY" -Credential $Cred -Verbose
#>

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
        $Path,

        [Parameter(Mandatory = $True)]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential,

        [ValidateSet('UPDATE_PROFILE', 'UPDATE_RECENT', 'TEMPORARY', 'INTERACTIVE', 'PROMPT', 'REDIRECT', 'CURRENT_MEDIA', 'COMMANDLINE', 'CMD_SAVECRED', 'CRED_RESET')]
        [String]
        $Flags  = 'TEMPORARY'
    )

    BEGIN {
        $NetResourceInstance = [Activator]::CreateInstance($NETRESOURCEW)
        $NetResourceInstance.dwType = 1

        $FlagValue = Switch ($LogonType) {
            'UPDATE_PROFILE' { 0x00000001 }
            'UPDATE_RECENT' { 0x00000002 }
            'TEMPORARY' { 0x00000004 }
            'INTERACTIVE' { 0x00000008 }
            'PROMPT' { 0x00000010 }
            'REDIRECT' { 0x00000080 }
            'CURRENT_MEDIA' { 0x00000200 }
            'COMMANDLINE' { 0x00000800 }
            'CMD_SAVECRED' { 0x00001000 }
            'CRED_RESET' { 0x00002000 }
        }
    }

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
            $NetResourceInstance.lpRemoteName = $TargetPath
            Write-Verbose "[WNetAddConnection2W] Attempting to mount: $TargetPath"

            # https://msdn.microsoft.com/en-us/library/windows/desktop/aa385413(v=vs.85).aspx
            #   CONNECT_TEMPORARY = 4
            $Result = $Mpr::WNetAddConnection2W($NetResourceInstance, $Credential.GetNetworkCredential().Password, $Credential.UserName, $FlagValue)

            if ($Result -eq 0) {
                Write-Verbose "$TargetPath successfully mounted"
            }
            else {
                Throw "[WNetAddConnection2W] error mounting $TargetPath : $(([ComponentModel.Win32Exception]$Result).Message)"
            }
        }
    }
}

$Module = New-InMemoryModule -ModuleName Win32

$NETRESOURCEW = struct $Module NETRESOURCEW @{
    dwScope =         field 0 UInt32
    dwType =          field 1 UInt32
    dwDisplayType =   field 2 UInt32
    dwUsage =         field 3 UInt32
    lpLocalName =     field 4 String -MarshalAs @('LPWStr')
    lpRemoteName =    field 5 String -MarshalAs @('LPWStr')
    lpComment =       field 6 String -MarshalAs @('LPWStr')
    lpProvider =      field 7 String -MarshalAs @('LPWStr')
}


$FunctionDefinitions = @(
    (func Mpr WNetAddConnection2W ([Int]) @($NETRESOURCEW, [String], [String], [UInt32]))
)

$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Mpr = $Types['Mpr']
