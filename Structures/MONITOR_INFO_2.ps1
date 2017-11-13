<#typedef struct _MONITOR_INFO_2 {
  LPTSTR pName;
  LPTSTR pEnvironment;
  LPTSTR pDLLName;
} MONITOR_INFO_2, *PMONITOR_INFO_2;
#>

$MONITOR_INFO_2 = struct $Module MONITOR_INFO_2 @{
    pName        = field 0 string -MarshalAs @('LPTStr', 260)
    pEnvironment = field 1 string -MarshalAs @('LPTStr', 260)
    pDLLName     = field 2 string -MarshalAs @('LPTStr', 260)
}