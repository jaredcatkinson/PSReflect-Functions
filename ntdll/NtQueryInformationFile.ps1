function NtQueryInformationFile
{
    <#
    (func ntdll NtQueryInformationFile ([UInt32]) @(
        [IntPtr],                 #_In_  HANDLE                 FileHandle,
        [IntPtr].MakeByRefType(), #_Out_ PIO_STATUS_BLOCK       IoStatusBlock,
        [IntPtr],                 #_Out_ PVOID                  FileInformation,
        [UInt32],                 #_In_  ULONG                  Length,
        [UInt32]                  #_In_  FILE_INFORMATION_CLASS FileInformationClass
    ) -EntryPoint NtQueryInformationFile)
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $FileHandle,

        [Parameter(Mandatory = $true)]
        [ValidateSet('FileDirectoryInformation','FileFullDirectoryInformation','FileBothDirectoryInformation','FileBasicInformation','FileStandardInformation','FileInternalInformation','FileEaInformation','FileAccessInformation','FileNameInformation','FileRenameInformation','FileLinkInformation','FileNamesInformation','FileDispositionInformation','FilePositionInformation','FileFullEaInformation','FileModeInformation','FileAlignmentInformation','FileAllInformation','FileAllocationInformation','FileEndOfFileInformation','FileAlternateNameInformation','FileStreamInformation','FilePipeInformation','FilePipeLocalInformation','FilePipeRemoteInformation','FileMailslotQueryInformation','FileMailslotSetInformation','FileCompressionInformation','FileObjectIdInformation','FileCompletionInformation','FileMoveClusterInformation','FileQuotaInformation','FileReparsePointInformation','FileNetworkOpenInformation','FileAttributeTagInformation','FileTrackingInformation','FileIdBothDirectoryInformation','FileIdFullDirectoryInformation','FileValidDataLengthInformation','FileShortNameInformation','FileIoCompletionNotificationInformation','FileIoStatusBlockRangeInformation','FileIoPriorityHintInformation','FileSfioReserveInformation','FileSfioVolumeInformation','FileHardLinkInformation','FileProcessIdsUsingFileInformation','FileNormalizedNameInformation','FileNetworkPhysicalNameInformation','FileIdGlobalTxDirectoryInformation','FileIsRemoteDeviceInformation','FileUnusedInformation','FileNumaNodeInformation','FileStandardLinkInformation','FileRemoteProtocolInformation','FileRenameInformationBypassAccessCheck','FileLinkInformationBypassAccessCheck','FileVolumeNameInformation','FileIdInformation','FileIdExtdDirectoryInformation','FileReplaceCompletionInformation','FileHardLinkFullIdInformation','FileIdExtdBothDirectoryInformation','FileDispositionInformationEx','FileRenameInformationEx','FileRenameInformationExBypassAccessCheck','FileDesiredStorageClassInformation','FileStatInformation','FileMaximumInformation')]
        [string]
        $FileInformationClass
    )

    $IoStatusBlock = [Activator]::CreateInstance($IO_STATUS_BLOCK)
    $Length = 0x68
    $FileInformationPtr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Length)
    
    $SUCCESS = $ntdll::NtQueryInformationFile($FileHandle, [ref]$IoStatusBlock, $FileInformationPtr, $Length, $FILE_INFORMATION_CLASS::$FileInformationClass)

    switch($FileInformationClass)
    {
        FileDirectoryInformation
        {
            <#

            #>
            
            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileFullDirectoryInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileBothDirectoryInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileBasicInformation
        {
            <#
            A FILE_BASIC_INFORMATION structure. The caller must have opened the file with the FILE_READ_ATTRIBUTES flag specified in the DesiredAccess parameter.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileStandardInformation
        {
            <#
            A FILE_STANDARD_INFORMATION structure. The caller can query this information as long as the file is open, without any particular requirements for DesiredAccess.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileInternalInformation
        {
            <#
            A FILE_INTERNAL_INFORMATION structure. This structure specifies a 64-bit file ID that uniquely identifies a file in NTFS. On other file systems, this file ID is not guaranteed to be unique.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileEaInformation
        {
            <#
            A FILE_EA_INFORMATION structure. This structure specifies the size of the extended attributes block that is associated with the file.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileAccessInformation
        {
            <#
            A FILE_ACCESS_INFORMATION structure. This structure contains an access mask. For more information about access masks, see ACCESS_MASK.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileNameInformation
        {
            <#
            A FILE_NAME_INFORMATION structure. The structure can contain the file's full path or only a portion of it. The caller can query this information as long as the file is open, without any particular requirements for DesiredAccess.
            #>

            Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([IntPtr]::Add($FileInformationPtr, 4)))
        }
        FileRenameInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileLinkInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileNamesInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileDispositionInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FilePositionInformation
        {
            <#
            A FILE_POSITION_INFORMATION structure. The caller must have opened the file with the DesiredAccess FILE_READ_DATA or FILE_WRITE_DATA flag specified in the DesiredAccess parameter, and with the FILE_SYNCHRONOUS_IO_ALERT or FILE_SYNCHRONOUS_IO_NONALERT flag specified in the CreateOptions parameter.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileFullEaInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileModeInformation
        {
            <#
            A FILE_MODE_INFORMATION structure. This structure contains a set of flags that specify the mode in which the file can be accessed. These flags are a subset of the options that can be specified in the CreateOptions parameter of the IoCreateFile routine.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileAlignmentInformation
        {
            <#
            A FILE_ALIGNMENT_INFORMATION structure. The caller can query this information as long as the file is open, without any particular requirements for DesiredAccess. This information is useful if the file was opened with the FILE_NO_INTERMEDIATE_BUFFERING flag specified in the CreateOptions parameter.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileAllInformation
        {
            <#

            #>

            Write-Output ($FileInformationPtr -as $FILE_ALL_INFORMATION)
        }
        FileAllocationInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileEndOfFileInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileAlternateNameInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileStreamInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FilePipeInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FilePipeLocalInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FilePipeRemoteInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileMailslotQueryInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileMailslotSetInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileCompressionInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileObjectIdInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileCompletionInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileMoveClusterInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileQuotaInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileReparsePointInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileNetworkOpenInformation
        {
            <#
            A FILE_NETWORK_OPEN_INFORMATION structure. The caller must have opened the file with the FILE_READ_ATTRIBUTES flag specified in the DesiredAccess parameter.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileAttributeTagInformation
        {
            <#
            A FILE_ATTRIBUTE_TAG_INFORMATION structure. The caller must have opened the file with the FILE_READ_ATTRIBUTES flag specified in the DesiredAccess parameter.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileTrackingInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileIdBothDirectoryInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileIdFullDirectoryInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileValidDataLengthInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileShortNameInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileIoCompletionNotificationInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileIoStatusBlockRangeInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileIoPriorityHintInformation
        {
            <#
            A FILE_IO_PRIORITY_HINT_INFORMATION structure. The caller must have opened the file with the FILE_READ_DATA flag specified in the DesiredAccess parameter.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileSfioReserveInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileSfioVolumeInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileHardLinkInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileProcessIdsUsingFileInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileNormalizedNameInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileNetworkPhysicalNameInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileIdGlobalTxDirectoryInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileIsRemoteDeviceInformation
        {
            <#
            A FILE_IS_REMOTE_DEVICE_INFORMATION structure. The caller can query this information as long as the file is open, without any particular requirements for DesiredAccess.
            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileUnusedInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileNumaNodeInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileStandardLinkInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileRemoteProtocolInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileRenameInformationBypassAccessCheck
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileLinkInformationBypassAccessCheck
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileVolumeNameInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileIdInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileIdExtdDirectoryInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileReplaceCompletionInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileHardLinkFullIdInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileIdExtdBothDirectoryInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileDispositionInformationEx
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileRenameInformationEx
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileRenameInformationExBypassAccessCheck
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileDesiredStorageClassInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileStatInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
        FileMaximumInformation
        {
            <#

            #>

            throw [System.NotImplementedException]"The $($FileInformationClass) class is not implemented yet."
        }
    }
}