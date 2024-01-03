<#
typedef enum {
  NameUnknown = 0,
  NameFullyQualifiedDN = 1,
  NameSamCompatible = 2,
  NameDisplay = 3,
  NameUniqueId = 6,
  NameCanonical = 7,
  NameUserPrincipal = 8,
  NameCanonicalEx = 9,
  NameServicePrincipal = 10,
  NameDnsDomain = 12,
  NameGivenName = 13,
  NameSurname = 14
} EXTENDED_NAME_FORMAT, *PEXTENDED_NAME_FORMAT;
#>

$EXTENDED_NAME_FORMAT = psenum $Module EXTENDED_NAME_FORMAT UInt32 @{
    NameUnknown       = 0
    NameFullyQualifiedDN = 1
    NameSamCompatible = 2
    NameDisplay = 3
    NameUniqueId = 6
    NameCanonical = 7
    NameUserPrincipal = 8
    NameCanonicalPrincipal = 10
    NameDnsDomain = 12
    NameGivenName = 13
    NameSurname = 14
}