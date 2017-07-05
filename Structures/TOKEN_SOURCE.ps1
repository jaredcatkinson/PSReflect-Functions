<#
typedef struct _TOKEN_SOURCE {
  CHAR SourceName[TOKEN_SOURCE_LENGTH];
  LUID SourceIdentifier;
} TOKEN_SOURCE, *PTOKEN_SOURCE;
#>

$TOKEN_SOURCE = struct $Module TOKEN_SOURCE @{
    SourceName       = field 0 string
    SourceIdentifier = field 1 $LUID
}