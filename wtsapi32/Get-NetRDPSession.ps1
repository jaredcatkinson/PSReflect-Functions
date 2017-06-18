function Get-NetRDPSession {
<#
.SYNOPSIS

Returns remote desktop/session information for the local (or a remote) machine.

Note: only members of the Administrators or Account Operators local group
can successfully execute this functionality on a remote target.

Author: Will Schroeder (@harmj0y)  
License: BSD 3-Clause  
Required Dependencies: PSReflect

.DESCRIPTION

This function will execute the WTSEnumerateSessionsEx and WTSQuerySessionInformation
Win32API calls to query a given RDP remote service for active sessions and originating
IPs. This is a replacement for qwinsta.

.PARAMETER ComputerName

Specifies the hostname to query for active sessions (also accepts IP addresses).
Defaults to 'localhost'.

.EXAMPLE

Get-NetRDPSession

Returns active RDP/terminal sessions on the local host.

.EXAMPLE

Get-NetRDPSession -ComputerName "sqlserver"

Returns active RDP/terminal sessions on the 'sqlserver' host.

.OUTPUTS

RDPSessionInfo

A PSCustomObject representing a combined WTS_SESSION_INFO_1 and WTS_CLIENT_ADDRESS structure,
with the ComputerName added.

.LINK

https://msdn.microsoft.com/en-us/library/aa383861(v=vs.85).aspx
#>

    [OutputType('RDPSessionInfo')]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = 'localhost'
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {

            # open up a handle to the Remote Desktop Session host
            $Handle = $Wtsapi32::WTSOpenServerEx($Computer)

            # if we get a non-zero handle back, everything was successful
            if ($Handle -ne 0) {

                # arguments for WTSEnumerateSessionsEx
                $ppSessionInfo = [IntPtr]::Zero
                $pCount = 0

                # get information on all current sessions
                $Result = $Wtsapi32::WTSEnumerateSessionsEx($Handle, [ref]1, 0, [ref]$ppSessionInfo, [ref]$pCount);$LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

                # locate the offset of the initial intPtr
                $Offset = $ppSessionInfo.ToInt64()

                if (($Result -ne 0) -and ($Offset -gt 0)) {

                    # work out how much to increment the pointer by finding out the size of the structure
                    $Increment = $WTS_SESSION_INFO_1::GetSize()

                    # parse all the result structures
                    for ($i = 0; ($i -lt $pCount); $i++) {

                        # create a new int ptr at the given offset and cast the pointer as our result structure
                        $NewIntPtr = New-Object System.Intptr -ArgumentList $Offset
                        $Info = $NewIntPtr -as $WTS_SESSION_INFO_1

                        $RDPSession = New-Object PSObject

                        if ($Info.pHostName) {
                            $RDPSession | Add-Member Noteproperty 'ComputerName' $Info.pHostName
                        }
                        else {
                            # if no hostname returned, use the specified hostname
                            $RDPSession | Add-Member Noteproperty 'ComputerName' $Computer
                        }

                        $RDPSession | Add-Member Noteproperty 'SessionName' $Info.pSessionName

                        if ($(-not $Info.pDomainName) -or ($Info.pDomainName -eq '')) {
                            # if a domain isn't returned just use the username
                            $RDPSession | Add-Member Noteproperty 'UserName' "$($Info.pUserName)"
                        }
                        else {
                            $RDPSession | Add-Member Noteproperty 'UserName' "$($Info.pDomainName)\$($Info.pUserName)"
                        }

                        $RDPSession | Add-Member Noteproperty 'ID' $Info.SessionID
                        $RDPSession | Add-Member Noteproperty 'State' $Info.State

                        $ppBuffer = [IntPtr]::Zero
                        $pBytesReturned = 0

                        # query for the source client IP with WTSQuerySessionInformation
                        #   https://msdn.microsoft.com/en-us/library/aa383861(v=vs.85).aspx
                        $Result2 = $Wtsapi32::WTSQuerySessionInformation($Handle, $Info.SessionID, 14, [ref]$ppBuffer, [ref]$pBytesReturned);$LastError2 = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

                        if ($Result2 -eq 0) {
                            Write-Verbose "[Get-NetRDPSession] Error: $(([ComponentModel.Win32Exception] $LastError2).Message)"
                        }
                        else {
                            $Offset2 = $ppBuffer.ToInt64()
                            $NewIntPtr2 = New-Object System.Intptr -ArgumentList $Offset2
                            $Info2 = $NewIntPtr2 -as $WTS_CLIENT_ADDRESS

                            $SourceIP = $Info2.Address
                            if ($SourceIP[2] -ne 0) {
                                $SourceIP = [String]$SourceIP[2]+'.'+[String]$SourceIP[3]+'.'+[String]$SourceIP[4]+'.'+[String]$SourceIP[5]
                            }
                            else {
                                $SourceIP = $Null
                            }

                            $RDPSession | Add-Member Noteproperty 'SourceIP' $SourceIP
                            $RDPSession.PSObject.TypeNames.Insert(0, 'PowerView.RDPSessionInfo')
                            $RDPSession

                            # free up the memory buffer
                            $Null = $Wtsapi32::WTSFreeMemory($ppBuffer)

                            $Offset += $Increment
                        }
                    }
                    # free up the memory result buffer
                    $Null = $Wtsapi32::WTSFreeMemoryEx(2, $ppSessionInfo, $pCount)
                }
                else {
                    Write-Verbose "[Get-NetRDPSession] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
                }
                # close off the service handle
                $Null = $Wtsapi32::WTSCloseServer($Handle)
            }
            else {
                Write-Verbose "[Get-NetRDPSession] Error opening the Remote Desktop Session Host (RD Session Host) server for: $ComputerName"
            }
        }
    }
}