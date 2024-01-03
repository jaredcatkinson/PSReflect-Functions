function whoami
{
    $hProcess = GetCurrentProcess
    $hToken = OpenProcessToken -ProcessHandle $hProcess -DesiredAccess TOKEN_QUERY
    $User = GetTokenInformation -TokenHandle $hToken -TokenInformationClass TokenUser
    Write-Output $User.Name
}