<#
typedef enum _SECURITY_IMPERSONATION_LEVEL { 
  SecurityAnonymous,
  SecurityIdentification,
  SecurityImpersonation,
  SecurityDelegation
} SECURITY_IMPERSONATION_LEVEL, *PSECURITY_IMPERSONATION_LEVEL;
#>

$SECURITY_IMPERSONATION_LEVEL = psenum $Mod SECURITY_IMPERSONATION_LEVEL UInt32 @{
    SecurityAnonymous      = 1
    SecurityIdentification = 2
    SecurityImpersonation  = 3
    SecurityDelegation     = 4
}