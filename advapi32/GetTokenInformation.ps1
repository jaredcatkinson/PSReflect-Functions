function GetTokenInformation
{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER TokenHandle

    .PARAMETER TokenInformationClass

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Function Dependencies: ConvertSidToStringSid
    Required Structure Dependencies: TOKEN_USER, TOKEN_PRIVILEGES, LUID, TOKEN_MANDATORY_LABEL
    Required Enumeration Dependencies: LuidAttributes
    Optional Dependencies: TokenInformationClass (Enum)

    (func advapi32 GetTokenInformation ([bool]) @(
        [IntPtr],                #_In_      HANDLE                  TokenHandle
        [Int32],                 #_In_      TOKEN_INFORMATION_CLASS TokenInformationClass
        [IntPtr],                #_Out_opt_ LPVOID                  TokenInformation
        [UInt32],                #_In_      DWORD                   TokenInformationLength
        [UInt32].MakeByRefType() #_Out_     PDWORD                  ReturnLength
    ) -EntryPoint GetTokenInformation -SetLastError)
        
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle,
        
        [Parameter(Mandatory = $true)]
        $TokenInformationClass
    )
    
    # initial query to determine the necessary buffer size
    $TokenPtrSize = 0
    $Success = $Advapi32::GetTokenInformation($TokenHandle, $TokenInformationClass, 0, $TokenPtrSize, [ref]$TokenPtrSize)
    [IntPtr]$TokenPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TokenPtrSize)
    
    # retrieve the proper buffer value
    $Success = $Advapi32::GetTokenInformation($TokenHandle, $TokenInformationClass, $TokenPtr, $TokenPtrSize, [ref]$TokenPtrSize); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    
    if($Success)
    {
        Write-Output $TokenPtr
    }
    else
    {
        Write-Debug "GetTokenInformation Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }        
}


function GetTokenInformation-TokenUser
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 1
    $TokenUser = $TokenPtr -as $TOKEN_USER
    ConvertSidToStringSid -SidPointer $TokenUser.User.Sid
}

function GetTokenInformation-TokenGroups
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 2
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenPrivileges
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 3

    # query the process token with the TOKEN_INFORMATION_CLASS = 3 enum to retrieve a TOKEN_PRIVILEGES structure
    $TokenPrivileges = $TokenPtr -as $TOKEN_PRIVILEGES
                
    $sb = New-Object System.Text.StringBuilder
                
    for($i=0; $i -lt $TokenPrivileges.PrivilegeCount; $i++) 
    {
        if((($TokenPrivileges.Privileges[$i].Attributes -as $LuidAttributes) -band $LuidAttributes::SE_PRIVILEGE_ENABLED) -eq $LuidAttributes::SE_PRIVILEGE_ENABLED)
        {
            $sb.Append(", $($TokenPrivileges.Privileges[$i].Luid.LowPart.ToString())") | Out-Null  
        }
    }
    Write-Output $sb.ToString().TrimStart(', ')
}

function GetTokenInformation-TokenOwner
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 4
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenPrimaryGroup
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 5
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenDefaultDacl
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 6
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenSource
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 7
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenType
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 8
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenImpersonationLevel
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 9
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenStatistics
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 10
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenRestrictedSids
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 11
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenSessionId
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 12
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenGroupsAndPrivileges
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 13
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenSessionReference
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 14
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenSandBoxInert
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 15
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenAuditPolicy
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 16
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenOrigin
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 17
    $TokenOrigin = $TokenPtr -as $LUID

    Write-Output (Get-LogonSession -LogonId $TokenOrigin.LowPart)
}

function GetTokenInformation-TokenElevationType
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 18
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenLinkedToken
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 19
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenElevation
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 20
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenHasRestrictions
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 21
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenAccessInformation
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 22
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenVirtualizationAllowed
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 23
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenVirtualizationEnabled
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 24
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenIntegrityLevel
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 25
    $TokenIntegrity = $TokenPtr -as $TOKEN_MANDATORY_LABEL
    switch(ConvertSidToStringSid -SidPointer $TokenIntegrity.Label.Sid)
    {
        $UNTRUSTED_MANDATORY_LEVEL
        {
            Write-Output "UNTRUSTED_MANDATORY_LEVEL"
        }
        $LOW_MANDATORY_LEVEL
        {
            Write-Output "LOW_MANDATORY_LEVEL"
        }
        $MEDIUM_MANDATORY_LEVEL
        {
            Write-Output "MEDIUM_MANDATORY_LEVEL"
        }
        $MEDIUM_PLUS_MANDATORY_LEVEL
        {
            Write-Output "MEDIUM_PLUS_MANDATORY_LEVEL"
        }
        $HIGH_MANDATORY_LEVEL
        {
            Write-Output "HIGH_MANDATORY_LEVEL"
        }
        $SYSTEM_MANDATORY_LEVEL
        {
            Write-Output "SYSTEM_MANDATORY_LEVEL"
        }
        $PROTECTED_PROCESS_MANDATORY_LEVEL
        {
            Write-Output "PROTECTED_PROCESS_MANDATORY_LEVEL"
        }
        $SECURE_PROCESS_MANDATORY_LEVEL
        {
            Write-Output "SECURE_PROCESS_MANDATORY_LEVEL"
        }
    }
}

function GetTokenInformation-TokenUIAccess
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 26
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenMandatoryPolicy
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 27
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenLogonSid
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 28
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenIsAppContainer
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 29
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenCapabilities
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 30
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenAppContainerSid
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 31
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenAppContainerName
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 32
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenUserClaimAttributes
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 33
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenDeviceClaimAttributes
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 34
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenRestrictedUserClaimAttributes
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 35
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenRestrictedDeviceClaimAttributes
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 36
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenDeviceGroups
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 37
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenRestrictedDeviceGroups
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 38
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenSecurityAttributes
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 39
    
    Write-Output $TokenPtr
}

function GetTokenInformation-TokenIsRestricted
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 40
    
    Write-Output $TokenPtr
}

function GetTokenInformation-MaxTokenInfoClass
{
    <#
    .SYNOPSIS

    .PARAMETER TokenHandle

    A handle to an access token from which information is retrieved. If TokenInformationClass specifies TokenSource, the handle must have TOKEN_QUERY_SOURCE access. For all other TokenInformationClass values, the handle must have TOKEN_QUERY access.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None
    
    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $TokenHandle
    )

    $TokenPtr = GetTokenInformation -TokenHandle $TokenHandle -TokenInformationClass 41
    
    Write-Output $TokenPtr
}