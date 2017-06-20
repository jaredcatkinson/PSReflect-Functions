. "$($PSScriptRoot)\PSReflect.ps1"

$Module = New-InMemoryModule -ModuleName PSReflectFunctions

Write-Host "Loading Enumerations"
Get-ChildItem "$($PSScriptRoot)\Enumerations\*" -Include '*.ps1' |
    % {. $_.FullName}

Write-Host "Loading Structures"
Get-ChildItem "$($PSScriptRoot)\Structures\*" -Include '*.ps1' |
    ? {$_.Name -ne "TOKEN_ACCESS_INFORMATION.ps1"} |
    % {. $_.FullName}

. "$($PSScriptRoot)\Structures\TOKEN_ACCESS_INFORMATION.ps1"

Write-Host "Loading API Functions Definitions"
. "$($PSScriptRoot)\FunctionDefinitions.ps1"

Write-Host "Defining API Abstraction Functions"
Get-ChildItem $PSScriptRoot | 
    ? {$_.PSIsContainer -and ($_.Name -ne 'Enumerations' -and $_.Name -ne 'Structures')} |
    % {Get-ChildItem "$($_.FullName)\*" -Include '*.ps1'} |
    % {. $_.FullName}