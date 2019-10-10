function LockResource
{
    <#
    .SYNOPSIS

    Retrieves a pointer to the specified resource in memory.

    .DESCRIPTION

    The pointer returned by LockResource is valid until the module containing the resource is unloaded. It is not necessary to unlock resources because the system automatically deletes them when the process that created them terminates.

    Do not try to lock a resource by using the handle returned by the FindResource or FindResourceEx function. 

    .PARAMETER ResourceHandle

    A handle to the resource to be locked. This handle is returned by the LoadResource function.

    .NOTES

    Author: Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 LockResource ([IntPtr]) @(
        [IntPtr]  #_In_ HGLOBAL hResData
    ) -EntryPoint LockResource -SetLastError),

    .LINK

    https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-lockresource
    
    .EXAMPLE
    #>

    param
    (
       [Parameter(Mandatory = $true)]
       [IntPtr]
       $ResourceHandle       
    )

    # https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-findresourcea#remarks
    # We can use the string "#1" as a way to specify the integer identifier 1 for the Resource Name
    # and "#11" for the Resource Type (Message Table)

    $SUCCESS = $kernel32::LockResource($ResourceHandle); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS)
    {
        throw "[LockResource]: Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $SUCCESS
}