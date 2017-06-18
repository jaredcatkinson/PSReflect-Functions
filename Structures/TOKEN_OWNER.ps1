<#
typedef struct _TOKEN_OWNER {
  PSID Owner;
} TOKEN_OWNER, *PTOKEN_OWNER;
#>

$TOKEN_OWNER = struct $Module TOKEN_OWNER @{
    Owner = field 0 IntPtr
}