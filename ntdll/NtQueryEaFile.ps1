function NtQueryEaFile
{
    <#
    .SYNOPSIS

    The NtQueryEaFile routine returns information about extended-attribute (EA) values for a file.

    .NOTES
    
    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, IO_STATUS_BLOCK (Structure)
    Optional Dependencies: None

    (func ntdll NtQueryEaFile ([UInt32]) @(
        [IntPtr],                         #_In_     HANDLE           FileHandle
        $IO_STATUS_BLOCK.MakeByRefType(), #_Out_    PIO_STATUS_BLOCK IoStatusBlock
        [IntPtr],                         #_Out_    PVOID            Buffer
        [UInt32],                         #_In_     ULONG            Length
        [bool],                           #_In_     BOOLEAN          ReturnSingleEntry
        [IntPtr],                         #_In_opt_ PVOID            EaList
        [UInt32],                         #_In_     ULONG            EaListLength
        [IntPtr],                         #_In_opt_ PULONG           EaIndex
        [bool]                            #_In_     BOOLEAN          RestartScan
    ) -EntryPoint NtQueryEaFile)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff961907(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $FileHandle
    )

    # Create an Instance of the IO_STATUS_BLOCK structure
    $IoStatusBlock = [Activator]::CreateInstance($IO_STATUS_BLOCK)

    # Make the return buffer max size
    $Buffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(0xFFFF)

    # Call NtQueryEaFile
    $SUCCESS = $Ntdll::NtQueryEaFile($FileHandle, [ref]$IoStatusBlock, $Buffer, 0xFFFF, $true, [IntPtr]::Zero, 0, [IntPtr]::Zero, $false); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($SUCCESS -eq 0) # NT_SUCCESS
    {
        # We found an extended Attribute
        # Cast the buffer to an instance of the FILE_FULL_EA_INFORMATION structure
        $FileFullEaInformation = $Buffer -as $FILE_FULL_EA_INFORMATION
        
        # Retrieve the name of the Extended Attribute
        $NameOffset = [IntPtr]::Add($buffer, 8)
        $Name = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($NameOffset, $FileFullEaInformation.EaNameLength)

        # Retrieve the contents of the Extended Attribute from the EaValueLength Pointer
        $ValueOffset = [IntPtr]::Add($NameOffset, $FileFullEaInformation.EaNameLength + 1)
        $Value = New-Object -TypeName byte[]($FileFullEaInformation.EaValueLength)
        [System.Runtime.InteropServices.Marshal]::Copy($ValueOffset, $Value, 0, $Value.Length)

        $obj = New-Object -TypeName psobject

        $obj | Add-Member -MemberType NoteProperty -Name Name -Value $Name
        $obj | Add-Member -MemberType NoteProperty -Name Value -Value $Value
        $obj | Add-Member -MemberType NoteProperty -Name ValueAsString -Value ([System.Text.Encoding]::ASCII.GetString($Value))
        $obj | Add-Member -MemberType NoteProperty -Name NextEntryOffset -Value $FileFullEaInformation.NextEntryOffset
        $obj | Add-Member -MemberType NoteProperty -Name Flags -Value $FileFullEaInformation.Flags

        Write-Output $obj
    }
    elseif($SUCCESS -eq 3221225554) # STATUS_NO_EAS_ON_FILE
    {
        # File has no Extended Attribute   
    }
    else # There was an error
    {
        throw "[NtQueryEaFile] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    # Free the memory page allocated for our return buffer
    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($Buffer)
}