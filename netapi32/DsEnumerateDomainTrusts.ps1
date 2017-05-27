function DsEnumerateDomainTrusts {
<#
.SYNOPSIS

Returns domain trust data for a specified server or domain.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the DsEnumerateDomainTrusts Win32API call
to enumerate trusts for the current or specified domain.

.PARAMETER ComputerName

Specifies the hostname or domain to query current domain trusts for.

.NOTES

    (func netapi32 DsEnumerateDomainTrusts ([Int]) @(
        [String],                   # _In_opt_ LPTSTR            ServerName
        [UInt32],                   # _In_     ULONG             Flags
        [IntPtr].MakeByRefType(),   # _Out_    PDS_DOMAIN_TRUSTS *Domains
        [IntPtr].MakeByRefType()    # _Out_    PULONG            DomainCount
    )

    (func netapi32 NetApiBufferFree ([Int]) @(
        [IntPtr]    # _In_ LPVOID Buffer
    )

    (func advapi32 ConvertSidToStringSid ([Int]) @(
        [IntPtr],
        [String].MakeByRefType()
    ) -SetLastError)

.EXAMPLE


.LINK

https://msdn.microsoft.com/en-us/library/ms675976(v=vs.85).aspx
#>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name', 'Domain', 'DomainName')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ComputerName
    )

    PROCESS {
        $PtrInfo = [IntPtr]::Zero

        # 63 = DS_DOMAIN_IN_FOREST + DS_DOMAIN_DIRECT_OUTBOUND + DS_DOMAIN_TREE_ROOT + DS_DOMAIN_PRIMARY + DS_DOMAIN_NATIVE_MODE + DS_DOMAIN_DIRECT_INBOUND
        $Flags = 63
        $DomainCount = 0

        # get the trust information from the target server/domain
        $Result = $Netapi32::DsEnumerateDomainTrusts($ComputerName, $Flags, [ref]$PtrInfo, [ref]$DomainCount)

        # locate the offset of the initial intPtr
        $Offset = $PtrInfo.ToInt64()

        # work out how much to increment the pointer by finding out the size of the structure
        $Increment = $DS_DOMAIN_TRUSTS::GetSize()

        # 0 = success
        if (($Result -eq 0) -and ($Offset -gt 0)) {

            # parse all the result structures
            for ($i = 0; ($i -lt $DomainCount); $i++) {
                # create a new int ptr at the given offset and cast the pointer as our result structure
                $NewIntPtr = New-Object System.Intptr -ArgumentList $Offset

                # grab the appropriate result structure
                $Info = $NewIntPtr -as $DS_DOMAIN_TRUSTS

                # return all the sections of the structure - have to do it this way for V2
                $Object = $Info | Select-Object *

                $SidString = ''
                $Result2 = $Advapi32::ConvertSidToStringSid($Info.DomainSid, [ref]$SidString)

                $Object.DomainSid = $SidString

                # return all the sections of the structure - have to do it this way for V2
                $Offset = $NewIntPtr.ToInt64()
                $Offset += $Increment
                $Object
            }

            # free up the result buffer
            $Null = $Netapi32::NetApiBufferFree($PtrInfo)
        }
        else {
            Write-Verbose "[DsEnumerateDomainTrusts] Error: $(([ComponentModel.Win32Exception] $Result).Message)"
        }
    }
    
}


$FunctionDefinitions = @(
    (func netapi32 DsEnumerateDomainTrusts ([Int]) @([String], [UInt32], [IntPtr].MakeByRefType(), [IntPtr].MakeByRefType())),
    (func netapi32 NetApiBufferFree ([Int]) @([IntPtr])),
    (func advapi32 ConvertSidToStringSid ([Int]) @([IntPtr], [String].MakeByRefType()) -SetLastError)
)

$Module = New-InMemoryModule -ModuleName Win32
$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Netapi32 = $Types['netapi32']
$Advapi32 = $Types['advapi32']


# enums used in DS_DOMAIN_TRUSTS
$DsDomainFlag = psenum $Module DsDomainFlag UInt32 @{
    IN_FOREST       = 1
    DIRECT_OUTBOUND = 2
    TREE_ROOT       = 4
    PRIMARY         = 8
    NATIVE_MODE     = 16
    DIRECT_INBOUND  = 32
} -Bitfield
$DsDomainTrustType = psenum $Module DsDomainTrustType UInt32 @{
    DOWNLEVEL   = 1
    UPLEVEL     = 2
    MIT         = 3
    DCE         = 4
}
$DsDomainTrustAttributes = psenum $Module DsDomainTrustAttributes UInt32 @{
    NON_TRANSITIVE      = 1
    UPLEVEL_ONLY        = 2
    FILTER_SIDS         = 4
    FOREST_TRANSITIVE   = 8
    CROSS_ORGANIZATION  = 16
    WITHIN_FOREST       = 32
    TREAT_AS_EXTERNAL   = 64
}

# the DsEnumerateDomainTrusts result structure
$DS_DOMAIN_TRUSTS = struct $Module DS_DOMAIN_TRUSTS @{
    NetbiosDomainName = field 0 String -MarshalAs @('LPWStr')
    DnsDomainName = field 1 String -MarshalAs @('LPWStr')
    Flags = field 2 $DsDomainFlag
    ParentIndex = field 3 UInt32
    TrustType = field 4 $DsDomainTrustType
    TrustAttributes = field 5 $DsDomainTrustAttributes
    DomainSid = field 6 IntPtr
    DomainGuid = field 7 Guid
}
