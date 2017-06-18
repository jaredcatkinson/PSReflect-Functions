<#
typedef enum tagTOKEN_TYPE { 
  TokenPrimary        = 1,
  TokenImpersonation
} TOKEN_TYPE, *PTOKEN_TYPE;
#>

$TOKEN_TYPE = psenum $Module TOKEN_TYPE UInt32 @{
    TokenPrimary       = 1
    TokenImpersonation = 2
}