. "$($PSScriptRoot)\PSReflect.ps1"

$Module = New-InMemoryModule -ModuleName PSReflectFunctions

Write-Host "Loading Enumerations"
Get-ChildItem "$($PSScriptRoot)\Enumerations\*" -Include '*.ps1' |
    % {. $_.FullName}

Write-Host "Loading Structures"
# Loading Structures
Get-ChildItem "$($PSScriptRoot)\Structures\*" -Include '*.ps1' |
    ? {$_.Name -ne "TOKEN_ACCESS_INFORMATION.ps1" -and $_.Name -ne "CLAIM_SECURITY_ATTRIBUTES_INFORMATION.ps1" -and $_.Name -ne "WINTRUST_DATA.ps1" -and $_.Name -ne "OBJECT_ATTRIBUTES.ps1"} |
    % {. $_.FullName}

. "$($PSScriptRoot)\Structures\TOKEN_ACCESS_INFORMATION.ps1"
. "$($PSScriptRoot)\Structures\CLAIM_SECURITY_ATTRIBUTES_INFORMATION.ps1"
. "$($PSScriptRoot)\Structures\WINTRUST_DATA.ps1"
. "$($PSScriptRoot)\Structures\OBJECT_ATTRIBUTES.ps1"
. "$($PSScriptRoot)\Structures\TOKEN_ACCESS_INFORMATION.ps1"

Write-Host "Loading API Functions Definitions"
. "$($PSScriptRoot)\FunctionDefinitions.ps1"

Write-Host "Defining API Abstraction Functions"
Get-ChildItem $PSScriptRoot | 
    ? {$_.PSIsContainer -and ($_.Name -ne 'Enumerations' -and $_.Name -ne 'Structures')} |
    % {Get-ChildItem "$($_.FullName)\*" -Include '*.ps1'} |
    % {. $_.FullName}