$FunctionDefinitions = @(
    #region advapi32
    (func advapi32 ChangeServiceConfig ([Bool]) @(
        [IntPtr],       # _In_      SC_HANDLE hService
        [UInt32],       # _In_      DWORD     dwServiceType
        [UInt32],       # _In_      DWORD     dwStartType
        [UInt32],       # _In_      DWORD     dwErrorControl
        [String],       # _In_opt_  LPCTSTR   lpBinaryPathName
        [String],       # _In_opt_  LPCTSTR   lpLoadOrderGroup
        [IntPtr],       # _Out_opt_ LPDWORD   lpdwTagId
        [String],       # _In_opt_  LPCTSTR   lpDependencies
        [String],       # _In_opt_  LPCTSTR   lpServiceStartName
        [String],       # _In_opt_  LPCTSTR   lpPassword
        [String]        # _In_opt_  LPCTSTR   lpDisplayName
    ) -SetLastError -Charset Unicode),

    (func advapi32 CloseServiceHandle ([Int]) @(
        [IntPtr]        # _In_ SC_HANDLE hSCObject
    )),

    (func advapi32 ConvertSidToStringSid ([bool]) @(
        [IntPtr],                #_In_  PSID   Sid,
        [IntPtr].MakeByRefType() #_Out_ LPTSTR *StringSid
    ) -EntryPoint ConvertSidToStringSid -SetLastError),

    (func advapi32 DuplicateToken ([bool]) @(
        [IntPtr],                #_In_  HANDLE                       ExistingTokenHandle,
        [UInt32],                #_In_  SECURITY_IMPERSONATION_LEVEL ImpersonationLevel,
        [IntPtr].MakeByRefType() #_Out_ PHANDLE                      DuplicateTokenHandle
    ) -EntryPoint DuplicateToken -SetLastError),

    (func advapi32 GetTokenInformation ([bool]) @(
      [IntPtr],                #_In_      HANDLE                  TokenHandle
      [Int32],                 #_In_      TOKEN_INFORMATION_CLASS TokenInformationClass
      [IntPtr],                #_Out_opt_ LPVOID                  TokenInformation
      [UInt32],                #_In_      DWORD                   TokenInformationLength
      [UInt32].MakeByRefType() #_Out_     PDWORD                  ReturnLength
    ) -EntryPoint GetTokenInformation -SetLastError),

    (func advapi32 ImpersonateLoggedOnUser ([bool]) @(
        [IntPtr] #_In_ HANDLE hToken
    ) -EntryPoint ImpersonateLoggedOnUser -SetLastError),

    (func advapi32 LogonUser ([Bool]) @(
        [String],                   # _In_     LPTSTR  lpszUsername
        [String],                   # _In_opt_ LPTSTR  lpszDomain
        [String],                   # _In_opt_ LPTSTR  lpszPassword
        [UInt32],                   # _In_     DWORD   dwLogonType
        [UInt32],                   # _In_     DWORD   dwLogonProvider
        [IntPtr].MakeByRefType()    # _Out_    PHANDLE phToken
    ) -EntryPoint LogonUser -SetLastError),

    (func advapi32 LsaNtStatusToWinError ([UInt64]) @(
        [UInt32] #_In_ NTSTATUS Status
    ) -EntryPoint LsaNtStatusToWinError),

    (func advapi32 OpenProcessToken ([bool]) @(
      [IntPtr],                #_In_  HANDLE  ProcessHandle
      [UInt32],                #_In_  DWORD   DesiredAccess
      [IntPtr].MakeByRefType() #_Out_ PHANDLE TokenHandle
    ) -EntryPoint OpenProcessToken -SetLastError),

    (func advapi32 OpenSCManagerW ([IntPtr]) @(
        [String],       # _In_opt_ LPCTSTR lpMachineName
        [String],       # _In_opt_ LPCTSTR lpDatabaseName
        [Int32]         # _In_     DWORD   dwDesiredAccess
    ) -EntryPoint OpenSCManagerW -SetLastError),

    (func advapi32 OpenThreadToken ([bool]) @(
      [IntPtr],                #_In_  HANDLE  ThreadHandle
      [UInt32],                #_In_  DWORD   DesiredAccess
      [bool],                  #_In_  BOOL    OpenAsSelf
      [IntPtr].MakeByRefType() #_Out_ PHANDLE TokenHandle
    ) -EntryPoint OpenThreadToken -SetLastError),

    (func advapi32 RevertToSelf ([bool]) @(
        # No Parameters
    ) -EntryPoint RevertToSelf -SetLastError),
    #endregion advapi32
    #region iphlpapi
    (func iphlpapi GetIpNetTable ([Int32]) @(
        [IntPtr],                 #_Out_   PMIB_IPNETTABLE pIpNetTable
        [Int32].MakeByRefType(),  #_Inout_ PULONG          pdwSize
        [bool]                    #_In_    BOOL            bOrder
    ) -EntryPoint GetIpNetTable),
    #endregion iphlpapi
    #region kernel32
    (func kernel32 CloseHandle ([bool]) @(
        [IntPtr] #_In_ HANDLE hObject
    ) -EntryPoint CloseHandle -SetLastError),

    (func kernel32 CreateFile ([IntPtr]) @(
        [string], #_In_     LPCTSTR               lpFileName
        [UInt32], #_In_     DWORD                 dwDesiredAccess
        [UInt32], #_In_     DWORD                 dwShareMode
        [IntPtr], #_In_opt_ LPSECURITY_ATTRIBUTES lpSecurityAttributes
        [UInt32], #_In_     DWORD                 dwCreationDisposition
        [UInt32], #_In_     DWORD                 dwFlagsAndAttributes
        [IntPtr]  #_In_opt_ HANDLE                hTemplateFile
    ) -EntryPoint CreateFile -SetLastError),

    (func kernel32 CreateToolhelp32Snapshot ([IntPtr]) @(
        [UInt32],                                 #_In_ DWORD dwFlags,
        [UInt32]                                  #_In_ DWORD th32ProcessID
    ) -EntryPoint CreateToolhelp32Snapshot -SetLastError),

    (func kernel32 GetCurrentProcess ([IntPtr]) @() -EntryPoint GetCurrentProcess),

    (func kernel32 GetThreadContextx64 ([bool]) @(
        [IntPtr],                  #_In_    HANDLE    hThread
        $CONTEXT64.MakeByRefType() #_Inout_ LPCONTEXT lpContext
    ) -EntryPoint GetThreadContext -SetLastError),
    
    (func kernel32 OpenProcess ([IntPtr]) @(
        [UInt32], #_In_ DWORD dwDesiredAccess
        [bool],   #_In_ BOOL  bInheritHandle
        [UInt32]  #_In_ DWORD dwProcessId
    ) -EntryPoint OpenProcess -SetLastError),

    (func kernel32 OpenThread ([IntPtr]) @(
        [UInt32], #_In_ DWORD dwDesiredAccess
        [bool],   #_In_ BOOL  bInheritHandle
        [UInt32]  #_In_ DWORD dwThreadId
    ) -EntryPoint OpenThread -SetLastError),

    (func kernel32 QueryFullProcessImageName ([bool]) @(
      [IntPtr],                    #_In_    HANDLE hProcess
      [UInt32],                    #_In_    DWORD  dwFlags,
      [System.Text.StringBuilder], #_Out_   LPTSTR lpExeName,
      [UInt32].MakeByRefType()     #_Inout_ PDWORD lpdwSize
    ) -EntryPoint QueryFullProcessImageName -SetLastError),

    (func kernel32 ReadProcessMemory ([Bool]) @(
        [IntPtr],                                  # _In_ HANDLE hProcess
        [IntPtr],                                  # _In_ LPCVOID lpBaseAddress
        [Byte[]],                                  # _Out_ LPVOID  lpBuffer
        [Int32],                                   # _In_ SIZE_T nSize
        [Int32].MakeByRefType()                    # _Out_ SIZE_T *lpNumberOfBytesRead
    ) -EntryPoint ReadProcessMemory -SetLastError),

    (func kernel32 ResumeThread ([UInt32]) @(
        [IntPtr] #_In_ HANDLE hThread
    ) -EntryPoint ResumeThread -SetLastError),

    (func kernel32 TerminateThread ([bool]) @(
        [IntPtr],                                  # _InOut_ HANDLE hThread
        [UInt32]                                   # _In_ DWORD dwExitCode
    ) -EntryPoint TerminateThread -SetLastError),

    (func kernel32 Thread32First ([bool]) @(
        [IntPtr],                                  #_In_    HANDLE          hSnapshot,
        $THREADENTRY32.MakeByRefType()             #_Inout_ LPTHREADENTRY32 lpte
    ) -EntryPoint Thread32First -SetLastError),
        
    (func kernel32 VirtualAllocEx ([IntPtr]) @(
        [IntPtr],                                  # _In_ HANDLE hProcess
        [IntPtr],                                  # _In_opt_ LPVOID lpAddress
        [UInt32],                                  # _In_ SIZE_T dwSize
        [UInt32],                                  # _In_ DWORD  flAllocationType
        [UInt32]                                   # _In_ DWORD  flProtect
    ) -EntryPoint VirtualAllocEx -SetLastError),

    (func kernel32 VirtualFreeEx ([Bool]) @(
        [IntPtr],                                    # _In_ HANDLE hProcess
        [IntPtr],                                    # _In_ LPVOID lpAddress
        [UInt32],                                    # _In_ SIZE_T dwSize
        [UInt32]                                     # _In_ DWORD  dwFreeType
    ) -EntryPoint VirtualFreeEx -SetLastError),
    
    (func kernel32 VirtualProtectEx ([bool]) @(
        [IntPtr],                #_In_  HANDLE hProcess
        [IntPtr],                #_In_  LPVOID lpAddress
        [UInt32],                #_In_  SIZE_T dwSize
        [UInt32],                #_In_  DWORD  flNewProtect
        [IntPtr].MakeByRefType() #_Out_ PDWORD lpflOldProtect
    ) -EntryPoint VirtualProtectEx -SetLastError),

    (func kernel32 VirtualQueryEx ([Int32]) @(
        [IntPtr],                                  #_In_     HANDLE                    hProcess,
        [IntPtr],                                  #_In_opt_ LPCVOID                   lpAddress,
        $MEMORY_BASIC_INFORMATION.MakeByRefType(),   #_Out_    PMEMORY_BASIC_INFORMATION lpBuffer,
        [UInt32]                                   #_In_     SIZE_T                    dwLength
    ) -EntryPoint VirtualQueryEx -SetLastError),

    (func kernel32 WriteProcessMemory ([Bool]) @(
        [IntPtr],                                  # _In_ HANDLE hProcess
        [IntPtr],                                  # _In_ LPVOID lpBaseAddress
        [Byte[]],                                  # _In_ LPCVOID lpBuffer
        [UInt32],                                  # _In_ SIZE_T nSize
        [UInt32].MakeByRefType()                   # _Out_ SIZE_T *lpNumberOfBytesWritten
    ) -EntryPoint WriteProcessMemory -SetLastError),
    #endregion kernel32
    #region Mpr
    (func Mpr WNetAddConnection2W ([Int32]) @(
        $NETRESOURCEW,      # _In_ LPNETRESOURCE lpNetResource
        [String],           # _In_ LPCTSTR       lpPassword
        [String],           # _In_ LPCTSTR       lpUsername
        [UInt32]            # _In_ DWORD         dwFlags
    ) -EntryPoint WNetAddConnection2W),

    (func Mpr WNetCancelConnection2 ([Int32]) @(
        [String],       # _In_ LPCTSTR lpName,
        [Int32],        # _In_ DWORD   dwFlags
        [Bool]          # _In_ BOOL    fForce
    ) -EntryPoint WNetCancelConnection2),
    #endregion Mpr
    #region netapi32
    (func netapi32 DsEnumerateDomainTrusts ([Int32]) @(
        [String],                   # _In_opt_ LPTSTR            ServerName
        [UInt32],                   # _In_     ULONG             Flags
        [IntPtr].MakeByRefType(),   # _Out_    PDS_DOMAIN_TRUSTS *Domains
        [IntPtr].MakeByRefType()    # _Out_    PULONG            DomainCount
    ) -EntryPoint DsEnumerateDomainTrusts),

    (func netapi32 DsGetSiteName ([Int32]) @(
        [String],                   # _In_  LPCTSTR ComputerName
        [IntPtr].MakeByRefType()    # _Out_ LPTSTR  *SiteName
    ) -EntryPoint DsGetSiteName),

    (func netapi32 NetApiBufferFree ([Int32]) @(
        [IntPtr]    # _In_ LPVOID Buffer
    ) -EntryPoint NetApiBufferFree),

    (func netapi32 NetConnectionEnum ([Int32]) @(
        [String],                   # _In_    LMSTR   servername
        [String],                   # _In_    LMSTR   qualifier
        [Int32],                    # _In_    LMSTR   qualifier
        [IntPtr].MakeByRefType(),   # _Out_   LPBYTE  *bufptr
        [Int32],                    # _In_    DWORD   prefmaxlen
        [Int32].MakeByRefType(),    # _Out_   LPDWORD entriesread
        [Int32].MakeByRefType(),    # _Out_   LPDWORD totalentries
        [Int32].MakeByRefType()     # _Inout_ LPDWORD resume_handle
    ) -EntryPoint NetConnectionEnum),

    (func netapi32 NetFileEnum ([Int32]) @(
        [String],                   # _In_    LMSTR      servername
        [String],                   # _In_    LMSTR      basepath
        [String],                   # _In_    LMSTR      username
        [Int32],                    # _In_    DWORD      level
        [IntPtr].MakeByRefType(),   # _Out_   LPBYTE     *bufptr
        [Int32],                    # _In_    DWORD      prefmaxlen
        [Int32].MakeByRefType(),    # _Out_   LPDWORD    entriesread
        [Int32].MakeByRefType(),    # _Out_   LPDWORD    totalentries
        [Int32].MakeByRefType()     # _Inout_ PDWORD_PTR resume_handle
    ) -EntryPoint NetFileEnum),

    (func netapi32 NetGetAnyDCName ([Int32]) @(
        [String],                   # _In_  LPCWSTR servername
        [String],                   # _In_  LPCWSTR domainname
        [IntPtr].MakeByRefType()    # _Out_ LPBYTE  *bufptr
    ) -EntryPoint NetGetAnyDCName),

    (func netapi32 NetGetDCName ([Int32]) @(
        [String],                   # _In_  LPCWSTR servername
        [String],                   # _In_  LPCWSTR domainname
        [IntPtr].MakeByRefType()    # _Out_ LPBYTE  *bufptr
    ) -EntryPoint NetGetDCName),

    (func netapi32 NetLocalGroupAddMembers ([Int32]) @(
        [String],                   # _In_ LPCWSTR servername
        [String],                   # _In_ LPCWSTR groupname
        [Int32],                    # _In_ DWORD   level
        [IntPtr].MakeByRefType(),   # _In_ LPBYTE  buf
        [Int32]                     # _In_ DWORD   totalentries
    ) -EntryPoint NetLocalGroupAddMembers),

    (func netapi32 NetLocalGroupDelMembers ([Int32]) @(
        [String],                   # _In_ LPCWSTR servername
        [String],                   # _In_ LPCWSTR groupname
        [Int32],                    # _In_ DWORD   level
        [IntPtr],                   # _In_ LPBYTE  buf
        [Int32]                     # _In_ DWORD   totalentries
    ) -EntryPoint NetLocalGroupDelMembers),

    (func netapi32 NetLocalGroupEnum ([Int32]) @(
        [String],                   # _In_    LPCWSTR    servername
        [Int32],                    # _In_    DWORD      level
        [IntPtr].MakeByRefType(),   # _Out_   LPBYTE     *bufptr
        [Int32],                    # _In_    DWORD      prefmaxlen
        [Int32].MakeByRefType(),    # _Out_   LPDWORD    entriesread
        [Int32].MakeByRefType(),    # _Out_   LPDWORD    totalentries
        [Int32].MakeByRefType()     # _Inout_ PDWORD_PTR resumehandle
    ) -EntryPoint NetLocalGroupEnum),

    (func netapi32 NetLocalGroupGetMembers ([Int32]) @(
        [String],
        [String],
        [Int32],
        [IntPtr].MakeByRefType(),
        [Int32], 
        [Int32].MakeByRefType(),
        [Int32].MakeByRefType(),
        [Int32].MakeByRefType()
    ) -EntryPoint NetLocalGroupGetMembers),

    (func netapi32 NetSessionEnum ([Int32]) @(
        [String],                   # _In_    LPWSTR  servername
        [String],                   # _In_    LPWSTR  UncClientName
        [String],                   # _In_    LPWSTR  username
        [Int32],                    # _In_    DWORD   level
        [IntPtr].MakeByRefType(),   # _Out_   LPBYTE  *bufptr
        [Int32],                    # _In_    DWORD   prefmaxlen
        [Int32].MakeByRefType(),    # _Out_   LPDWORD entriesread
        [Int32].MakeByRefType(),    # _Out_   LPDWORD totalentries
        [Int32].MakeByRefType()     # _Inout_ LPDWORD resume_handle
    ) -EntryPoint NetSessionEnum),

    (func netapi32 NetShareAdd ([Int32]) @(
        [String],                   # _In_  LPWSTR  servername
        [Int32],                    # _In_  DWORD   level
        [IntPtr],                   # _In_  LPBYTE  buf
        [Int32].MakeByRefType()     # _Out_ LPDWORD parm_err
    ) -EntryPoint NetShareAdd),

    (func netapi32 NetShareDel ([Int32]) @(
        [String],                   # _In_  LPWSTR  servername
        [String],                   # _In_  LPWSTR  netname
        [Int32]                     # _In_  DWORD   reserved
    ) -EntryPoint NetShareDel),

    (func netapi32 NetShareEnum ([Int32]) @(
        [String],                                   # _In_    LPWSTR  servername
        [Int32],                                    # _In_    DWORD   level
        [IntPtr].MakeByRefType(),                   # _Out_   LPBYTE  *bufptr
        [Int32],                                    # _In_    DWORD   prefmaxlen
        [Int32].MakeByRefType(),                    # _Out_   LPDWORD entriesread
        [Int32].MakeByRefType(),                    # _Out_   LPDWORD totalentries
        [Int32].MakeByRefType()                     # _Inout_ LPDWORD resume_handle
    ) -EntryPoint NetShareEnum),

    (func netapi32 NetWkstaUserEnum ([Int32]) @(
        [String],                   # _In_    LPWSTR  servername
        [Int32],                    # _In_    DWORD   level
        [IntPtr].MakeByRefType(),   # _Out_   LPBYTE  *bufptr
        [Int32],                    # _In_    DWORD   prefmaxlen
        [Int32].MakeByRefType(),    # _Out_   LPDWORD entriesread
        [Int32].MakeByRefType(),    # _Out_   LPDWORD totalentries
        [Int32].MakeByRefType()     # _Inout_ LPDWORD resumehandle
    ) -EntryPoint NetWkstaUserEnum),
    #endregion netapi32
    #region ntdll
    (func ntdll NtQueryInformationThread ([Int32]) @(
        [IntPtr], #_In_      HANDLE          ThreadHandle,
        [Int32],  #_In_      THREADINFOCLASS ThreadInformationClass,
        [IntPtr], #_Inout_   PVOID           ThreadInformation,
        [Int32],  #_In_      ULONG           ThreadInformationLength,
        [IntPtr]  #_Out_opt_ PULONG          ReturnLength
    ) -EntryPoint NtQueryInformationThread),

    (func ntdll RtlAdjustPrivilege ([UInt32]) @(
        [Int32],                # int Privilege,
        [Bool],                 # bool bEnablePrivilege
        [Bool],                 # bool IsThreadPrivilege
        [Int32].MakeByRefType() # out bool PreviousValue
    ) -EntryPoint RtlAdjustPrivilege),
    #endregion ntdll
    #region samlib
    (func samlib SamCloseHandle ([Int32]) @(
        [IntPtr] #_In_ SAM_HANDLE SamHandle
    ) -EntryPoint SamCloseHandle),

    (func samlib SamConnect ([Int32]) @(
        $UNICODE_STRING.MakeByRefType(), #_Inout_opt_ PUNICODE_STRING    ServerName
        [IntPtr].MakeByRefType(),        #_Out_       PSAM_HANDLE        ServerHandle
        [Int32],                         #_In_        ACCESS_MASK        DesiredAccess
        [bool]                           #_In_        POBJECT_ATTRIBUTES ObjectAttributes
    ) -EntryPoint SamConnect),

    (func samlib SamOpenDomain ([Int32]) @(
        [IntPtr],                #_In_ SAM_HANDLE  ServerHandle
        [Int32],                 #_In_ ACCESS_MASK DesiredAccess
        [byte[]],                #_In_ PSID        DomainId
        [IntPtr].MakeByRefType() #_Out_ PSAM_HANDLE DomainHandle
    ) -EntryPoint SamOpenDomain),

    (func samlib SamOpenUser ([Int32]) @(
        [IntPtr],                #_In_  SAM_HANDLE  DomainHandle
        [Int32],                 #_In_  ACCESS_MASK DesiredAccess
        [Int32],                 #_In_  ULONG       UserId
        [IntPtr].MakeByRefType() #_Out_ PSAM_HANDLE UserHandle
    ) -EntryPoint SamOpenUser),

    (func samlib SamSetInformationUser ([Int32]) @(
        [IntPtr], #_In_ SAM_HANDLE             UserHandle
        [Int32],  #_In_ USER_INFORMATION_CLASS UserInformationClass
        [IntPtr]  #_In_ PVOID                  Buffer
    ) -EntryPoint SamSetInformationUser)
    #endregion samlib    
    #region secur32
    (func secur32 LsaCallAuthenticationPackage ([UInt32]) @(
        [IntPtr],                 #_In_  HANDLE    LsaHandle
        [UInt64],                 #_In_  ULONG     AuthenticationPackage
        [IntPtr],                 #_In_  PVOID     ProtocolSubmitBuffer
        [UInt64],                 #_In_  ULONG     SubmitBufferLength
        [IntPtr].MakeByRefType(), #_Out_ PVOID     *ProtocolReturnBuffer
        [UInt64].MakeByRefType(), #_Out_ PULONG    *ReturnBufferLength
        [UInt32].MakeByRefType()  #_Out_ PNTSTATUS ProtocolStatus
    ) -EntryPoint LsaCallAuthenticationPackage),

    (func secur32 LsaConnectUntrusted ([UInt32]) @(
        [IntPtr].MakeByRefType() #_Out_ PHANDLE LsaHandle
    ) -EntryPoint LsaConnectUntrusted),

    (func secur32 LsaDeregisterLogonProcess ([UInt32]) @(
        [IntPtr] #_In_ HANDLE LsaHandle
    ) -EntryPoint LsaDeregisterLogonProcess),

    (func secur32 LsaEnumerateLogonSessions ([UInt32]) @(
        [UInt64].MakeByRefType(), #_Out_ PULONG LogonSessionCount,
        [IntPtr].MakeByRefType()  #_Out_ PLUID  *LogonSessionList
    ) -EntryPoint LsaEnumerateLogonSessions),
    
    (func secur32 LsaFreeReturnBuffer ([UInt32]) @(
        [IntPtr] #_In_ PVOID Buffer
    ) -EntryPoint LsaFreeReturnBuffer),
    
    (func secur32 LsaGetLogonSessionData ([UInt32]) @(
        [IntPtr],                #_In_  PLUID                        LogonId,
        [IntPtr].MakeByRefType() #_Out_ PSECURITY_LOGON_SESSION_DATA *ppLogonSessionData
    ) -EntryPoint LsaGetLogonSessionData)#,
    
    (func secur32 LsaLookupAuthenticationPackage ([UInt32]) @(
        [IntPtr],                            #_In_  HANDLE      LsaHandle,
        $LSA_UNICODE_STRING.MakeByRefType(), #_In_  PLSA_STRING PackageName,
        [UInt64].MakeByRefType()             #_Out_ PULONG      AuthenticationPackage
    ) -EntryPoint LsaLookupAuthenticationPackage),

    (func secur32 LsaRegisterLogonProcess ([UInt32]) @(
        $LSA_STRING.MakeByRefType(), #_In_  PLSA_STRING           LogonProcessName,
        [IntPtr].MakeByRefType(),    #_Out_ PHANDLE               LsaHandle,
        [UInt64].MakeByRefType()     #_Out_ PLSA_OPERATIONAL_MODE SecurityMode
    ) -EntryPoint LsaRegisterLogonProcess),
    #endregion secur32
    #region wintrust
    (func wintrust CryptCATAdminAcquireContext ([bool]) @(
      [IntPtr].MakeByRefType(), #_Out_       HCATADMIN *phCatAdmin
      [Guid].MakeByRefType(),   #_In_  const GUID      *pgSubsystem
      [UInt32]                  #_In_        DWORD     dwFlags        
    ) -EntryPoint CryptCATAdminAcquireContext -SetLastError),

    (func wintrust CryptCATAdminAddCatalog ([IntPtr]) @(
        [IntPtr],               # _In_ HCATADMIN hCatAdmin,
        [String],               # _In_ WCHAR     *pwszCatalogFile,
        [IntPtr],               # _In_ WCHAR     *pwszSelectBaseName,
        [UInt32]                # _In_ DWORD     dwFlags
    ) -EntryPoint CryptCATAdminAddCatalog -SetLastError -Charset Unicode),

    (func wintrust CryptCATAdminCalcHashFromFileHandle ([bool]) @(
        [IntPtr],                 #_In_    HANDLE hFile
        [UInt32].MakeByRefType(), #_Inout_ DWORD  *pcbHash
        [byte[]],                 #_In_    BYTE   *pbHash
        [UInt32]                  #_In_    DWORD  dwFlags
    ) -EntryPoint CryptCATAdminCalcHashFromFileHandle),

    (func wintrust CryptCATAdminEnumCatalogFromHash ([IntPtr]) @(
        [IntPtr], #_In_ HCATADMIN hCatAdmin
        [byte[]], #_In_ BYTE      *pbHash
        [UInt32], #_In_ DWORD     cbHash
        [UInt32], #_In_ DWORD     dwFlags
        [IntPtr]  #_In_ HCATINFO  *phPrevCatInfo
    ) -EntryPoint CryptCATAdminEnumCatalogFromHash -SetLastError),

    (func wintrust CryptCATAdminReleaseCatalogContext ([bool]) @(
        [IntPtr], #_In_ HCATADMIN hCatAdmin
        [IntPtr], #_In_ HCATINFO  hCatInfo
        [UInt32]  #_In_ DWORD     dwFlags
    ) -EntryPoint CryptCATAdminReleaseCatalogContext),

    (func wintrust CryptCATAdminReleaseContext ([bool]) @(
        [IntPtr], #_In_ HCATADMIN hCatAdmin
        [UInt32]  #_In_ DWORD     dwFlags
    ) -EntryPoint CryptCATAdminReleaseContext),

    (func wintrust CryptCATCatalogInfoFromContext ([bool]) @(
        [IntPtr],                      #_In_    HCATINFO     hCatInfo,
        $CATALOG_INFO.MakeByRefType(), #_Inout_ CATALOG_INFO *psCatInfo,
        [UInt32]                       #_In_    DWORD        dwFlags
    ) -EntryPoint CryptCATCatalogInfoFromContext -SetLastError -CharSet Unicode),

    (func wintrust WinVerifyTrust ([Int32]) @(
        [IntPtr], #_In_ HWND   hWnd,
        [Guid],   #_In_ GUID   *pgActionID,
        $WINTRUST_DATA.MakeByRefType()  #_In_ LPVOID pWVTData
    ) -EntryPoint WinVerifyTrust -Charset Unicode),
    #endregion wintrust
    #region wtsapi32
    (func wtsapi32 WTSCloseServer ([Int32]) @(
        [IntPtr]    # _In_ HANDLE hServer
    ) -EntryPoint WTSCloseServer),

    (func wtsapi32 WTSEnumerateSessionsEx ([Int32]) @(
        [IntPtr],                   # _In_    HANDLE              hServer
        [Int32].MakeByRefType(),    # _Inout_ DWORD               *pLevel
        [Int32],                    # _In_    DWORD               Filter
        [IntPtr].MakeByRefType(),   # _Out_   PWTS_SESSION_INFO_1 *ppSessionInfo
        [Int32].MakeByRefType()     # _Out_   DWORD               *pCount
    ) -EntryPoint WTSEnumerateSessionsEx -SetLastError),

    (func wtsapi32 WTSFreeMemory ([void]) @(
        [IntPtr] #_In_ PVOID pMemory
    ) -EntryPoint WTSFreeMemory),

    (func wtsapi32 WTSFreeMemoryEx ([Int32]) @(
        [Int32],  #_In_ WTS_TYPE_CLASS WTSTypeClass
        [IntPtr], #_In_ PVOID          pMemory
        [Int32]   #_In_ ULONG          NumberOfEntries
    ) -EntryPoint WTSFreeMemoryEx -SetLastError),

    (func wtsapi32 WTSOpenServerEx ([IntPtr]) @(
        [String] #_In_ LPTSTR pServerName
    ) -EntryPoint WTSOpenServerEx),

    (func wtsapi32 WTSQuerySessionInformation ([Int32]) @(
        [IntPtr]                 #_In_  HANDLE         hServer
        [Int32]                  #_In_  DWORD          SessionId
        [Int32]                  #_In_  WTS_INFO_CLASS WTSInfoClass
        [IntPtr].MakeByRefType() #_Out_ LPTSTR         *ppBuffer
        [Int32].MakeByRefType()  #_Out_ DWORD          *pBytesReturned
    ) -EntryPoint WTSQuerySessionInformation -SetLastError)
    #endregion wtsapi32
)

$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace PSReflectFunctions

$advapi32 = $Types['advapi32']
$iphlpapi = $Types['iphlpapi']
$kernel32 = $Types['kernel32']
$mpr = $Types['Mpr']
$netapi32 = $Types['netapi32']
$ntdll = $Types['ntdll']
$samlib = $Types['samlib']
$secur32 = $Types['secur32']
$wintrust = $Types['wintrust']
$wtsapi32 = $Types['wtsapi32']