function NetShareAdd {
<#
.SYNOPSIS

Creates a new share on the local (or a remote) machine.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the NetShareAdd Win32API call to create
a new share on the specified host given at specified path.

.PARAMETER ComputerName

Specifies the hostname to add the share to (also accepts IP addresses).
Defaults to 'localhost'.

.PARAMETER ShareName

The name of the share to create.

.PARAMETER SharePath

The name of the local path to create the share with.

.PARAMETER ShareComment

An optional comment/remark to set for the newly created share.

.NOTES

    (func netapi32 NetShareAdd ([Int]) @(
        [String],                   # _In_  LPWSTR  servername
        [Int],                      # _In_  DWORD   level
        [IntPtr],                   # _In_  LPBYTE  buf
        [Int32].MakeByRefType()     # _Out_ LPDWORD parm_err
    )

.EXAMPLE


.LINK

https://msdn.microsoft.com/en-us/library/windows/desktop/bb525384(v=vs.85).aspx
#>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = 'localhost',

        [Parameter(Position = 1, Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ShareName,

        [Parameter(Position = 2, Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [ValidatePattern('.*\\.*')]
        $SharePath,

        [ValidateNotNullOrEmpty()]
        [String]
        $ShareComment = ''
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {

            $ShareStruct = [Activator]::CreateInstance($SHARE_INFO_2)
            $ShareStruct.shi2_netname = $ShareName
            $ShareStruct.shi2_path = $SharePath
            $ShareStruct.shi2_remark = $ShareComment
            $ShareStruct.shi2_type = 0 # DiskTree

            [IntPtr]$ShareStructPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($SHARE_INFO_2::GetSize())
            [Runtime.InteropServices.Marshal]::StructureToPtr($ShareStruct, $ShareStructPtr, $False)

            $Result = $Netapi32::NetShareAdd($Computer, 2, $ShareStructPtr, 0)

            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($ShareStructPtr)

            if ($Result -eq 0) {
                Write-Verbose "Share '$ShareName' with path '$SharePath' successfully created on server '$Computer'"
            }
            else {
                Throw "[NetShareAdd] Error creating share '$ShareName' with path '$SharePath' on server '$Computer' : $(([ComponentModel.Win32Exception]$Result).Message)"
            }
        }
    }
}


$FunctionDefinitions = @(
    (func netapi32 NetShareAdd ([Int]) @([String], [Int], [IntPtr], [Int32]))
)

$Module = New-InMemoryModule -ModuleName Win32
$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Netapi32 = $Types['netapi32']


$SHARE_INFO_2                 = struct $Module SHARE_INFO_2 @{
    shi2_netname              = field 0 String -MarshalAs @('LPWStr')
    shi2_type                 = field 1 UInt32
    shi2_remark               = field 2 String -MarshalAs @('LPWStr')
    shi2_permissions          = field 3 UInt32
    shi2_max_uses             = field 4 UInt32
    shi2_current_uses         = field 5 UInt32
    shi2_path                 = field 6 String -MarshalAs @('LPWStr')
    shi2_passwd               = field 7 String -MarshalAs @('LPWStr')
}
