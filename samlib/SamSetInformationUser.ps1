function SamSetInformationUser
{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER UserHandle

    .PARAMETER UserInformationClass

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect, USER_INFORMATION_CLASS, 
    Optional Dependencies: None

    (func samlib SamSetInformationUser ([Int32]) @(
        [IntPtr], #_In_ SAM_HANDLE             UserHandle
        [Int32],  #_In_ USER_INFORMATION_CLASS UserInformationClass
        [IntPtr]  #_In_ PVOID                  Buffer
    ) -EntryPoint SamSetInformationUser)

    .LINK

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $UserHandle,

        [Parameter(Mandatory = $true)]
        [ValidateSet('UserGeneralInformation','UserPreferencesInformation','UserLogonInformation','UserLogonHoursInformation','UserAccountInformation','UserNameInformation','UserAccountNameInformation','UserFullNameInformation','UserPrimaryGroupInformation','UserHomeInformation','UserScriptInformation','UserProfileInformation','UserAdminCommentInformation','UserWorkStationsInformation','UserSetPasswordInformation','UserControlInformation','UserExpiresInformation','UserInternal1Information','UserInternal2Information','UserParametersInformation','UserAllInformation','UserInternal3Information','UserInternal4Information','UserInternal5Information','UserInternal4InformationNew','UserInternal5InformationNew','UserInternal6Information','UserExtendedInformation','UserLogonUIInformation')]
        [string]
        $UserInformationClass,

        [Parameter()]
        [byte[]]
        $LM,

        [Parameter()]
        [byte[]]
        $NTLM
    )

    switch($UserInformationClass)
    {
        UserGeneralInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserPreferencesInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserLogonInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserLogonHoursInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserAccountInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserNameInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserAccountNameInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserFullNameInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserPrimaryGroupInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserHomeInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserScriptInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserProfileInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserAdminCommentInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserWorkStationsInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserSetPasswordInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserControlInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserExpiresInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserInternal1Information
        {
            <#
                SAMPR_USER_INTERNAL1_INFORMATION
            #>

            $UserInternalInformation = [Activator]::CreateInstance($SAMPR_USER_INTERNAL1_INFORMATION)
            $UserInternalInformation.EncryptedLmOwfPassword = $LM
            if($LM -eq $null)
            {
                $UserInternalInformation.LmPasswordPresent = [byte]0x00
            }
            else
            {
                $UserInternalInformation.LmPasswordPresent = [byte]0x01
            }

            $UserInternalInformation.EncryptedNtOwfPassword = $NTLM
            if($NTLM -eq $null)
            {
                $UserInternalInformation.NtPasswordPresent = [byte]0x00
            }
            else
            {
                $UserInternalInformation.NtPasswordPresent = [byte]0x01
            }

            $UserInternalInformation.PasswordExpired = 0;

            $Buffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($SAMPR_USER_INTERNAL1_INFORMATION::GetSize())
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($SAMPR_USER_INTERNAL1_INFORMATION, $Buffer, $true)
        }
        UserInternal2Information
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserParametersInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserAllInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserInternal3Information
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserInternal4Information
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserInternal5Information
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserInternal4InformationNew
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserInternal5InformationNew
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserInternal6Information
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserExtendedInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
        UserLogonUIInformation
        {
            throw [System.NotImplementedException]"The $($UserInformationClass) Class is not implemented yet."
        }
    }

    $SUCCESS = $samlib::SamSetInformationUser($UserHandle, $USER_INFORMATION_CLASS::$UserInformationClass, [ref]$Buffer)

    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($Buffer)

    if($SUCCESS -ne 0)
    {
        throw "[SamSetInformationUser] error: $($SUCCESS)"
    }
}