. "$($PSScriptRoot)\PSReflect.ps1"
$Module = New-InMemoryModule -ModuleName PSReflectFunctions

# Loading Enumerations
Get-ChildItem "$($PSScriptRoot)\Enumerations\*" -Include '*.ps1' |
    % {. $_.FullName}

# Loading Structures
. "$($PSScriptRoot)\Structures\LARGE_INTEGER.ps1"
Get-ChildItem "$($PSScriptRoot)\Structures\*" -Include '*.ps1' |
    ? {$_.Name -ne "FILE_BASIC_INFORMATION.ps1" -and $_.Name -ne "TOKEN_ACCESS_INFORMATION.ps1" -and $_.Name -ne "CLAIM_SECURITY_ATTRIBUTES_INFORMATION.ps1" -and $_.Name -ne "WINTRUST_DATA.ps1" -and $_.Name -ne "OBJECT_ATTRIBUTES.ps1" -and $_.Name -ne "CLAIM_SECURITY_ATTRIBUTE_V1.ps1" -and $_.Name -ne "LUID_AND_ATTRIBUTES.ps1" -and $_.Name -ne "TOKEN_PRIVILEGES.ps1" -and $_.Name -ne "LARGE_INTEGER.ps1" } | % {. $_.FullName}

. "$($PSScriptRoot)\Structures\WINTRUST_DATA.ps1"
. "$($PSScriptRoot)\Structures\OBJECT_ATTRIBUTES.ps1"
. "$($PSScriptRoot)\Structures\LUID_AND_ATTRIBUTES.ps1"
. "$($PSScriptRoot)\Structures\TOKEN_PRIVILEGES.ps1" 
. "$($PSScriptRoot)\Structures\TOKEN_ACCESS_INFORMATION.ps1"
. "$($PSScriptRoot)\Structures\CLAIM_SECURITY_ATTRIBUTE_V1.ps1"
. "$($PSScriptRoot)\Structures\CLAIM_SECURITY_ATTRIBUTES_INFORMATION.ps1"
. "$($PSScriptRoot)\Structures\FILE_BASIC_INFORMATION.ps1"

# Loading API Functions Definitions
. "$($PSScriptRoot)\FunctionDefinitions.ps1"

# Defining API Abstraction Functions
Get-ChildItem $PSScriptRoot | 
    ? {$_.PSIsContainer -and ($_.Name -ne 'Enumerations' -and $_.Name -ne 'Structures')} |
    % {Get-ChildItem "$($_.FullName)\*" -Include '*.ps1'} |
    % {. $_.FullName}