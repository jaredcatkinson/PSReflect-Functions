<#
typedef struct _MIB_IPNETTABLE {
  DWORD        dwNumEntries;
  MIB_IPNETROW table[ANY_SIZE];
} MIB_IPNETTABLE, *PMIB_IPNETTABLE;
#>

$MIB_IPNETTABLE = struct $Module MIB_IPNETTABLE @{
    dwNumEntries = field 0 UInt32
    table        = field 1 IntPtr
}