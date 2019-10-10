function LoadResource
{
    <#
    .SYNOPSIS

    Retrieves a handle that can be used to obtain a pointer to the first byte of the specified resource in memory.

    .DESCRIPTION

    To obtain a pointer to the first byte of the resource data, call the LockResource function; 
    to obtain the size of the resource, call SizeofResource.

    .PARAMETER ModuleHandle

    A handle to the module whose executable file contains the resource, like that returned by a successful call to LoadLibrary.
    If hModule is NULL, the system loads the resource from the module that was used to create the current process.

    .PARAMETER ResourceHandle

    A handle to the resource to be loaded. This handle is returned by the FindResource function.

    .NOTES

    Author: Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 LoadResource ([IntPtr]) @(
        [IntPtr], #_In_ HMODULE hModule
        [IntPtr]  #_Out_ HRSRC hResInfo
    ) -EntryPoint LoadResource -SetLastError),

    .LINK

    https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadresource
    
    .EXAMPLE
    #>

    param
    (
       [Parameter(Mandatory = $true)]
       [IntPtr]
       $ModuleHandle,

       [Parameter(Mandatory = $true)]
       [IntPtr]
       $ResourceHandle       
    )

    # https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-findresourcea#remarks
    # We can use the string "#1" as a way to specify the integer identifier 1 for the Resource Name
    # and "#11" for the Resource Type (Message Table)

    $SUCCESS = $kernel32::LoadResource($ModuleHandle, $ResourceHandle); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS)
    {
        throw "[LoadResource]: Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $SUCCESS
}