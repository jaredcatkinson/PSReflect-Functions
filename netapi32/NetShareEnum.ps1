function NetShareEnum {
    <#
    .SYNOPSIS

    Returns open shares on the local (or a remote) machine.
    Note: anything above level 2 requires admin rights on a remote system.

    .DESCRIPTION

    This function will execute the NetShareEnum Win32API call to query
    a given host for open shares. This is a replacement for "net share \\hostname".

    .PARAMETER ComputerName

    Specifies the hostname to query for shares (also accepts IP addresses).
    Defaults to 'localhost'.

    .PARAMETER Level

    Specifies the level of information to query from NetShareEnum.
    Default of 1. Affects the result structure returned.

    .NOTES

    Author: Will Schroeder (@harmj0y) & Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause  
    Required Dependencies: PSReflect, IsValidSecurityDescriptor (Function), ConvertSecurityDescriptorToStringSecurityDescriptor (Function), NetApiBufferFree (Function), SHARE_INFO_0, SHARE_INFO_1, SHARE_INFO_2, SHARE_INFO_502, SHARE_INFO_503, SHARE_TYPE 
    Optional Dependencies: None

    (func netapi32 NetShareEnum ([Int]) @(
        [String],                                   # _In_    LPWSTR  servername
        [Int32],                                    # _In_    DWORD   level
        [IntPtr].MakeByRefType(),                   # _Out_   LPBYTE  *bufptr
        [Int32],                                    # _In_    DWORD   prefmaxlen
        [Int32].MakeByRefType(),                    # _Out_   LPDWORD entriesread
        [Int32].MakeByRefType(),                    # _Out_   LPDWORD totalentries
        [Int32].MakeByRefType()                     # _Inout_ LPDWORD resume_handle
    ) -EntryPoint NetShareEnum)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/bb525387(v=vs.85).aspx

    .EXAMPLE
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = 'localhost',

        [ValidateSet(0, 1, 2, 502, 503)]
        [String]
        $Level = 1
    )

    BEGIN {
        # Get Share Security Descriptor (This will have to be updated to grab this value from the remote system if possible using WMI)
        $DefaultSddlBytes = (Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\DefaultSecurity -Name SrvsvcShareAdminConnect).SrvsvcShareAdminConnect
        $DefaultSD = [System.Security.AccessControl.RawSecurityDescriptor]::new($DefaultSddlBytes,0)
        $DefaultSddl = $DefaultSD.GetSddlForm([System.Security.AccessControl.AccessControlSections]::All)

    }

    PROCESS {
        ForEach ($Computer in $ComputerName) {
            $PtrInfo = [IntPtr]::Zero
            $EntriesRead = 0
            $TotalRead = 0
            $ResumeHandle = 0

            # get the raw share information
            $Result = $Netapi32::NetShareEnum($Computer, $Level, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle)

            # locate the offset of the initial intPtr
            $Offset = $PtrInfo.ToInt64()

            # work out how much to increment the pointer by finding out the size of the structure
            $Increment = Switch ($Level) {
                0   { $SHARE_INFO_0::GetSize() }
                1   { $SHARE_INFO_1::GetSize() }
                2   { $SHARE_INFO_2::GetSize() }
                502 { $SHARE_INFO_502::GetSize() }
                503 { $SHARE_INFO_503::GetSize() }
            }

            # 0 = success
            if (($Result -eq 0) -and ($Offset -gt 0)) {

                # parse all the result structures
                for ($i = 0; ($i -lt $EntriesRead); $i++) {
                    # create a new int ptr at the given offset and cast the pointer as our result structure
                    $NewIntPtr = New-Object System.Intptr -ArgumentList $Offset

                    # grab the appropriate result structure
                    Switch ($Level) {
                        0
                        {
                            $ShareInfo = $NewIntPtr -as $SHARE_INFO_0
                            $obj = New-Object -TypeName psobject

                            $obj | Add-Member -MemberType NoteProperty -Name Name -Value $ShareInfo.shi0_netname

                            Write-Output $obj
                        }
                        1
                        {
                            $ShareInfo = $NewIntPtr -as $SHARE_INFO_1
                            $obj = New-Object -TypeName psobject

                            $obj | Add-Member -MemberType NoteProperty -Name Name -Value $ShareInfo.shi1_netname
                            
                            $obj | Add-Member -MemberType NoteProperty -Name IsSpecial -Value (($ShareInfo.shi1_type -band 0x80000000) -eq 2147483648)
                            $obj | Add-Member -MemberType NoteProperty -Name IsTemporary -Value (($ShareInfo.shi1_type -band 0x40000000) -eq 0x40000000)
                            $type = $ShareInfo.shi1_type -band 0x0FFFFFFF
                            $obj | Add-Member -MemberType NoteProperty -Name Type -Value ([SHARE_TYPE]$type)
                            
                            $obj | Add-Member -MemberType NoteProperty -Name Remark -Value $ShareInfo.shi1_remark

                            Write-Output $obj
                        }
                        2
                        {
                            $ShareInfo = $NewIntPtr -as $SHARE_INFO_2
                            $obj = New-Object -TypeName psobject

                            $obj | Add-Member -MemberType NoteProperty -Name Name -Value $ShareInfo.shi2_netname
                            
                            $obj | Add-Member -MemberType NoteProperty -Name IsSpecial -Value (($ShareInfo.shi2_type -band 0x80000000) -eq 2147483648)
                            $obj | Add-Member -MemberType NoteProperty -Name IsTemporary -Value (($ShareInfo.shi2_type -band 0x40000000) -eq 0x40000000)
                            $type = $ShareInfo.shi2_type -band 0x0FFFFFFF
                            $obj | Add-Member -MemberType NoteProperty -Name Type -Value ([SHARE_TYPE]$type)
                            
                            $obj | Add-Member -MemberType NoteProperty -Name Remark -Value $ShareInfo.shi2_remark
                            #$obj | Add-Member -MemberType NoteProperty -Name Permissions -Value $ShareInfo.shi2_permissions
                            $obj | Add-Member -MemberType NoteProperty -Name MaxUses -Value $ShareInfo.shi2_max_uses
                            $obj | Add-Member -MemberType NoteProperty -Name CurrentUses -Value $ShareInfo.shi2_current_uses
                            $obj | Add-Member -MemberType NoteProperty -Name Path -Value $ShareInfo.shi2_path
                            #$obj | Add-Member -MemberType NoteProperty -Name Password -Value $ShareInfo.shi2_passwd

                            Write-Output $obj
                        }
                        502
                        {
                            $ShareInfo = $NewIntPtr -as $SHARE_INFO_502

                            $obj = New-Object -TypeName psobject

                            $obj | Add-Member -MemberType NoteProperty -Name Name -Value $ShareInfo.shi502_netname
                            
                            $obj | Add-Member -MemberType NoteProperty -Name IsSpecial -Value (($ShareInfo.shi502_type -band 0x80000000) -eq 2147483648)
                            $obj | Add-Member -MemberType NoteProperty -Name IsTemporary -Value (($ShareInfo.shi502_type -band 0x40000000) -eq 0x40000000)
                            $type = $ShareInfo.shi502_type -band 0x0FFFFFFF
                            $obj | Add-Member -MemberType NoteProperty -Name Type -Value ([SHARE_TYPE]$type)
                            
                            $obj | Add-Member -MemberType NoteProperty -Name Remark -Value $ShareInfo.shi502_remark
                            #$obj | Add-Member -MemberType NoteProperty -Name Permissions -Value $ShareInfo.shi502_permissions
                            $obj | Add-Member -MemberType NoteProperty -Name MaxUses -Value $ShareInfo.shi502_max_uses
                            $obj | Add-Member -MemberType NoteProperty -Name CurrentUses -Value $ShareInfo.shi502_current_uses
                            $obj | Add-Member -MemberType NoteProperty -Name Path -Value $ShareInfo.shi502_path
                            #$obj | Add-Member -MemberType NoteProperty -Name Password -Value $ShareInfo.shi502_passwd
                            #$obj | Add-Member -MemberType NoteProperty -Name Reserved -Value $ShareInfo.shi502_reserved
                            
                            if(IsValidSecurityDescriptor -SecurityDescriptor $ShareInfo.shi502_security_descriptor)
                            {
                                $obj | Add-Member -MemberType NoteProperty -Name SecurityDescriptor -Value (ConvertSecurityDescriptorToStringSecurityDescriptor -SecurityDescriptor $ShareInfo.shi502_security_descriptor)
                            }
                            else
                            {
                                $obj | Add-Member -MemberType NoteProperty -Name SecurityDescriptor -Value $DefaultSddl
                            }
                            
                            Write-Output $obj
                        }
                        503
                        {
                            $ShareInfo = $NewIntPtr -as $SHARE_INFO_503

                            $obj = New-Object -TypeName psobject

                            $obj | Add-Member -MemberType NoteProperty -Name Name -Value $ShareInfo.shi503_netname
                            
                            $obj | Add-Member -MemberType NoteProperty -Name IsSpecial -Value (($ShareInfo.shi503_type -band 0x80000000) -eq 2147483648)
                            $obj | Add-Member -MemberType NoteProperty -Name IsTemporary -Value (($ShareInfo.shi503_type -band 0x40000000) -eq 0x40000000)
                            $type = $ShareInfo.shi503_type -band 0x0FFFFFFF
                            $obj | Add-Member -MemberType NoteProperty -Name Type -Value ([SHARE_TYPE]$type)

                            $obj | Add-Member -MemberType NoteProperty -Name Remark -Value $ShareInfo.shi503_remark
                            #$obj | Add-Member -MemberType NoteProperty -Name Permissions -Value $ShareInfo.shi503_permissions
                            $obj | Add-Member -MemberType NoteProperty -Name MaxUses -Value $ShareInfo.shi503_max_uses
                            $obj | Add-Member -MemberType NoteProperty -Name CurrentUses -Value $ShareInfo.shi503_current_uses
                            $obj | Add-Member -MemberType NoteProperty -Name Path -Value $ShareInfo.shi503_path
                            #$obj | Add-Member -MemberType NoteProperty -Name Password -Value $ShareInfo.shi503_passwd
                            $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $ShareInfo.shi503_servername
                            $obj | Add-Member -MemberType NoteProperty -Name Reserved -Value $ShareInfo.shi503_reserved
                            
                            if(IsValidSecurityDescriptor -SecurityDescriptor $ShareInfo.shi503_security_descriptor)
                            {
                                $obj | Add-Member -MemberType NoteProperty -Name SecurityDescriptor -Value (ConvertSecurityDescriptorToStringSecurityDescriptor -SecurityDescriptor $ShareInfo.shi503_security_descriptor)
                            }
                            else
                            {
                                $obj | Add-Member -MemberType NoteProperty -Name SecurityDescriptor -Value $DefaultSddl
                            }
                            
                            Write-Output $obj
                        }
                    }

                    # return all the sections of the structure - have to do it this way for V2
                    $Offset = $NewIntPtr.ToInt64()
                    $Offset += $Increment
                }

                # free up the result buffer
                NetApiBufferFree -Buffer $PtrInfo
            }
            else {
                Write-Verbose "[NetShareEnum] Error: $(([ComponentModel.Win32Exception] $Result).Message)"
            }
        }
    }
}