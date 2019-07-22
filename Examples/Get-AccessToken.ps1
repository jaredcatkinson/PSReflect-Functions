function Get-AccessToken
{
    param
    (
        [Parameter()]
        [System.Diagnostics.Process[]]
        $Process
    )

    begin
    {
        try
        {
            Get-System
        }
        catch
        {
            Write-Error "Unable to Impersonate NT AUTHORITY\SYSTEM token"
        }

        if(-not ($PSBoundParameters.ContainsKey('Process')))
        {
            $Process = Get-Process
        }
    }

    process
    {
        foreach($proc in $Process)
        {
            if($proc.Id -ne 0 -and $proc.Id -ne 4 -and $proc.Id -ne $PID)
            {
                try
                {
                    $hProcess = OpenProcess -ProcessId $proc.Id -DesiredAccess PROCESS_QUERY_LIMITED_INFORMATION
                }
                catch
                {
                    if($_.Exception.Message -ne "OpenProcess Error: The parameter is incorrect")
                    {
                        Write-Verbose "Process Handle: $($proc.Id)"
                        Write-Verbose $_.Exception.Message
                    }
                }

                try
                {
                    $hToken = OpenProcessToken -ProcessHandle $hProcess -DesiredAccess TOKEN_QUERY
                }
                catch
                {
                    Write-Verbose "Process Token Handle: $($proc.Id)"
                    Write-Verbose $_.Exception.Message
                }

                try
                {
                    $PrimaryTokenStatistics = GetTokenInformation -TokenInformationClass TokenStatistics -TokenHandle $hToken
                    $PrimaryTokenUser = GetTokenInformation -TokenInformationClass TokenUser -TokenHandle $hToken
                    $PrimaryTokenOwner = GetTokenInformation -TokenInformationClass TokenOwner -TokenHandle $hToken
                    $PrimaryTokenIntegrityLevel = GetTokenInformation -TokenInformationClass TokenIntegrityLevel -TokenHandle $hToken
                    $PrimaryTokenType = GetTokenInformation -TokenInformationClass TokenType -TokenHandle $hToken
                    $PrimaryTokenSessionId = GetTokenInformation -TokenInformationClass TokenSessionId -TokenHandle $hToken
                    $PrimaryTokenOrigin = GetTokenInformation -TokenInformationClass TokenOrigin -TokenHandle $hToken
                    $PrimaryTokenPrivileges = GetTokenInformation -TokenInformationClass TokenPrivileges -TokenHandle $hToken
                    $PrimaryTokenElevation = GetTokenInformation -TokenInformationClass TokenElevation -TokenHandle $hToken
                    $PrimaryTokenElevationType = GetTokenInformation -TokenInformationClass TokenElevationType -TokenHandle $hToken
                    
                    $obj = [PSCustomObject]@{
                        ProcessName = $proc.Name
                        ProcessId = $proc.Id
                        ThreadId = $null
                        TokenId = [UInt32]$PrimaryTokenStatistics.TokenId
                        ModifiedId = [UInt32]$PrimaryTokenStatistics.ModifiedId
                        AuthenticationId = [UInt32]$PrimaryTokenStatistics.AuthenticationId
                        UserSid = $PrimaryTokenUser.Sid.ToString()
                        UserName = $PrimaryTokenUser.Name.Value
                        OwnerSid = $PrimaryTokenOwner.Sid.ToString()
                        OwnerName = $PrimaryTokenOwner.Name.Value
                        IntegrityLevel = $PrimaryTokenIntegrityLevel.ToString()
                        Type = $PrimaryTokenType.ToString()
                        ImpersonationLevel = 'None'
                        SessionId = [UInt32]$PrimaryTokenSessionId
                        Origin = [UInt32]$PrimaryTokenOrigin
                        EnabledPrivileges = ($PrimaryTokenPrivileges | Where-Object {$_.Attributes -like "*ENABLED*"} | select -ExpandProperty Privilege) -join ';'
                        DefaultEnabledPrivileges = ($PrimaryTokenPrivileges | Where-Object {$_.Attributes -like "*ENABLED_BY_DEFAULT*"} | select -ExpandProperty Privilege) -join ';'
                        DisabledPrivileges = ($PrimaryTokenPrivileges | Where-Object {$_.Attributes -like "*DISABLED*"} | select -ExpandProperty Privilege) -join ';'
                        IsElevated = $PrimaryTokenElevation.ToString()
                        ElevationType = $PrimaryTokenElevationType.ToString()
                        PrimaryTokenId = $PrimaryTokenStatistics.TokenId
                        PrimaryModifiedId = $PrimaryTokenStatistics.ModifiedId
                        PrimaryAuthenticationId = $PrimaryTokenStatistics.AuthenticationId
                        PrimaryUserSid = $PrimaryTokenUser.Sid.ToString()
                        PrimaryUserName = $PrimaryTokenUser.Name.Value
                        PrimaryIntegrityLevel = $PrimaryTokenIntegrityLevel.ToString()
                        PrimaryType = $PrimaryTokenType.ToString()
                        PrimarySessionId = $PrimaryTokenSessionId
                    }

                    Write-Output $obj

                    CloseHandle -Handle $hProcess
                    CloseHandle -Handle $hToken
                }
                catch
                {
                    Write-Verbose "Process Token Query: $($proc.Id)"
                    Write-Verbose $_.Exception.Message
                }

                foreach($thread in $proc.Threads)
                {
                    try
                    {
                        $hThread = OpenThread -ThreadId $thread.Id -DesiredAccess THREAD_QUERY_LIMITED_INFORMATION
                    }
                    catch
                    {
                        Write-Verbose "Thread Handle: [Proc] $($proc.Id) [THREAD] $($thread.Id)"
                        Write-Verbose $_.Exception.Message
                    }

                    try
                    {
                        $hToken = OpenThreadToken -ThreadHandle $hThread -DesiredAccess TOKEN_QUERY

                        $TokenStatistics = GetTokenInformation -TokenInformationClass TokenStatistics -TokenHandle $hToken
                        $TokenUser = GetTokenInformation -TokenInformationClass TokenUser -TokenHandle $hToken
                        $TokenOwner = GetTokenInformation -TokenInformationClass TokenOwner -TokenHandle $hToken
                        $TokenIntegrityLevel = GetTokenInformation -TokenInformationClass TokenIntegrityLevel -TokenHandle $hToken
                        $TokenType = GetTokenInformation -TokenInformationClass TokenType -TokenHandle $hToken
                        $TokenImpersonationLevel = GetTokenInformation -TokenInformationClass TokenImpersonationLevel -TokenHandle $hToken
                        $TokenSessionId = GetTokenInformation -TokenInformationClass TokenSessionId -TokenHandle $hToken
                        $TokenOrigin = GetTokenInformation -TokenInformationClass TokenOrigin -TokenHandle $hToken
                        $TokenPrivileges = GetTokenInformation -TokenInformationClass TokenPrivileges -TokenHandle $hToken
                        $TokenElevation = GetTokenInformation -TokenInformationClass TokenElevation -TokenHandle $hToken
                        $TokenElevationType = GetTokenInformation -TokenInformationClass TokenElevationType -TokenHandle $hToken

                        $obj = [PSCustomObject]@{
                            ProcessName = $proc.Name
                            ProcessId = $proc.Id
                            ThreadId = $thread.Id
                            TokenId = [UInt32]$TokenStatistics.TokenId
                            ModifiedId = [UInt32]$TokenStatistics.ModifiedId
                            AuthenticationId = [UInt32]$TokenStatistics.AuthenticationId
                            UserSid = $TokenUser.Sid.ToString()
                            UserName = $TokenUser.Name.Value
                            OwnerSid = $TokenOwner.Sid.ToString()
                            OwnerName = $TokenOwner.Name.Value
                            IntegrityLevel = $TokenIntegrityLevel.ToString()
                            Type = $TokenType.ToString()
                            ImpersonationLevel = $TokenImpersonationLevel.ToString()
                            SessionId = [UInt32]$TokenSessionId
                            Origin = [UInt32]$TokenOrigin
                            EnabledPrivileges = ($PrimaryTokenPrivileges | Where-Object {$_.Attributes -like "*ENABLED*"} | select -ExpandProperty Privilege) -join ';'
                            DefaultEnabledPrivileges = ($PrimaryTokenPrivileges | Where-Object {$_.Attributes -like "*ENABLED_BY_DEFAULT*"} | select -ExpandProperty Privilege) -join ';'
                            DisabledPrivileges = ($PrimaryTokenPrivileges | Where-Object {$_.Attributes -like "*DISABLED*"} | select -ExpandProperty Privilege) -join ';'
                            IsElevated = $TokenElevation.ToString()
                            ElevationType = $TokenElevationType.ToString()
                            PrimaryTokenId = $PrimaryTokenStatistics.TokenId
                            PrimaryModifiedId = $PrimaryTokenStatistics.ModifiedId
                            PrimaryAuthenticationId = $PrimaryTokenStatistics.AuthenticationId
                            PrimaryUserSid = $PrimaryTokenUser.Sid.ToString()
                            PrimaryUserName = $PrimaryTokenUser.Name.Value
                            PrimaryIntegrityLevel = $PrimaryTokenIntegrityLevel.ToString()
                            PrimaryType = $PrimaryTokenType.ToString()
                            PrimarySessionId = $PrimaryTokenSessionId
                        }

                        Write-Output $obj

                        CloseHandle -Handle $hThread
                        CloseHandle -Handle $hToken
                    }
                    catch
                    {
                        if($_.Exception.Message -ne 'OpenThreadToken Error: An attempt was made to reference a token that does not exist')
                        {
                            Write-Verbose "Thread Token Handle"
                            Write-Verbose $_.Exception.Message
                        }
                    }
                }
            }
        }
    }

    end
    {
        RevertToSelf
    }
}
