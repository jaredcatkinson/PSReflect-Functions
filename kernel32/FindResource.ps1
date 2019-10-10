function FindResource
{
    <#
    .SYNOPSIS

    Determines the location of a resource with the specified type and name in the specified module.

    .DESCRIPTION

    http://vec3.ca/working-with-win32-resources-in-dot-net/
    "Most native applications make extensive use of Win32 resources. 
    While the .NET Framework provides a far more useful resource API, 
    it’s sometimes necessary to access the old style Win32 resources. 
    Fortunately, this isn’t very difficult.

    Win32 resources are identified by their type and ID. 
    These parameters can be specified either as a string or as an integer. 
    They are located using FindResource.

    If necessary, it’s always possible to pass an integer ID as a string 
    by prepending its string representation with a hash sign (#).



    .PARAMETER ModuleHandle

    A handle to the module (DLL or EXE) where the resource should be found, likely the output of a successful call to LoadLibrary.
    A handle to the module whose portable executable file or an accompanying MUI file contains the resource. If this parameter is NULL, the function searches the module used to create the current process.

    .PARAMETER ResourceName

    The name of the resource, or an integer identifier to a resource.

    .PARAMETER ResourceType

    The resource type, or an integer identifier to a resource type. 

    .NOTES

    Author: Brian Reitz (@brian_psu)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 FindResource ([IntPtr]) @(
        [IntPtr], #_Out_    HMODULE hmodule,
        [string], #_In_     LPCTSTR lpName,
        [string]  #_In_     LPCTSTR lpType,       
    ) -EntryPoint FindResource -SetLastError)
    .LINK

    https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-findresourcea
    
    .EXAMPLE
    #>

    param
    (
       [Parameter(Mandatory = $true)]
       [IntPtr]
       $ModuleHandle,

       [Parameter(Mandatory = $true)]
       [string]
       $ResourceName,

       [Parameter(Mandatory = $true)]
       [string]
       $ResourceType       
    )

    # https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-findresourcea#remarks
    # We can use the string "#1" as a way to specify the integer identifier 1 for the Resource Name
    # and "#11" for the Resource Type

    $SUCCESS = $kernel32::FindResource($ModuleHandle, $ResourceName, $ResourceType); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if(-not $SUCCESS)
    {
        throw "[FindResource]: Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $SUCCESS
}