function NtSetEaFile
{
    <#
    .SYNOPSIS

    The NtSetEaFile routine sets extended-attribute (EA) values for a file.

    .DESCRIPTION

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, IO_STATUS_BLOCK (Structure), FILE_FULL_EA_INFORMATION (Structure)
    Optional Dependencies: None

    (func ntdll NtSetEaFile ([UInt32]) @(
        [IntPtr],                         #_In_  HANDLE           FileHandle
        $IO_STATUS_BLOCK.MakeByRefType(), #_Out_ PIO_STATUS_BLOCK IoStatusBlock
        [IntPtr],                         #_In_  PVOID            Buffer
        [UInt32]                          #_In_  ULONG            Length
    ) -EntryPoint NtSetEaFile)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/hardware/ff961908(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $FileHandle,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [byte[]]
        $Value
    )

    # Instantiate an IO_STATUS_BLOCK instance
    $IoStatusBlock = [Activator]::CreateInstance($IO_STATUS_BLOCK)

    # Instatiate a FILE_FULL_EA_INFORMATION instance
    $FileFullEaInformation = [Activator]::CreateInstance($FILE_FULL_EA_INFORMATION)
    $FileFullEaInformation.NextEntryOffset = 0
    $FileFullEaInformation.Flags = 0
    $FileFullEaInformation.EaNameLength = $Name.Length
    $FileFullEaInformation.EaValueLength = $Value.Length

    # Initialize a buffer for the FILE_FULL_EA_INFORMATION struct
    $Size = 8 + $Name.Length + 1 + $Value.Length
    $buffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Size)
    [System.Runtime.InteropServices.Marshal]::StructureToPtr($FileFullEaInformation, $buffer, $true)

    $NameBytes = [System.Text.Encoding]::ASCII.GetBytes($Name)
    $NameOffset = [IntPtr]::Add($buffer, 8)
    [System.Runtime.InteropServices.Marshal]::Copy($NameBytes, 0, $NameOffset, $Name.Length)
    
    $ValueOffset = [IntPtr]::Add($buffer, 8 + $Name.Length + 1)
    [System.Runtime.InteropServices.Marshal]::Copy($Value, 0, $ValueOffset, $Value.Length)

    $SUCCESS = $Ntdll::NtSetEaFile($FileHandle, [ref]$IoStatusBlock, $buffer, $Size); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($buffer)

    if($SUCCESS -ne 0) # NT_SUCCESS
    {
        throw "[NtSetEaFile] Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }
}