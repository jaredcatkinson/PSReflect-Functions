. "$($PSScriptRoot)\PSReflect.ps1"

$Module = New-InMemoryModule -ModuleName PSReflectFunctions

# Loading Enumerations
Get-ChildItem "$($PSScriptRoot)\Enumerations\*" -Include '*.ps1' |
    % {. $_.FullName}

# Loading Structures
Get-ChildItem "$($PSScriptRoot)\Structures\*" -Include '*.ps1' |
    ? {$_.Name -ne "TOKEN_ACCESS_INFORMATION.ps1" -and $_.Name -ne "CLAIM_SECURITY_ATTRIBUTES_INFORMATION.ps1" -and $_.Name -ne "WINTRUST_DATA.ps1"} |
    % {. $_.FullName}

. "$($PSScriptRoot)\Structures\TOKEN_ACCESS_INFORMATION.ps1"
. "$($PSScriptRoot)\Structures\CLAIM_SECURITY_ATTRIBUTES_INFORMATION.ps1"
. "$($PSScriptRoot)\Structures\WINTRUST_DATA.ps1"

# Loading API Functions Definitions
. "$($PSScriptRoot)\FunctionDefinitions.ps1"

# Defining API Abstraction Functions
Get-ChildItem $PSScriptRoot | 
    ? {$_.PSIsContainer -and ($_.Name -ne 'Enumerations' -and $_.Name -ne 'Structures')} |
    % {Get-ChildItem "$($_.FullName)\*" -Include '*.ps1'} |
    % {. $_.FullName}