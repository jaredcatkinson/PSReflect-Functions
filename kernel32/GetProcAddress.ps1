function GetProcAddress
{
    <#
    .SYNOPSIS

    Retrieves the address of an exported function or variable from the specified dynamic-link library (DLL).

    .DESCRIPTION

    The spelling and case of a function name pointed to by lpProcName must be identical to that in the EXPORTS statement of the source DLL's module-definition (.def) file. The exported names of functions may differ from the names you use when calling these functions in your code. This difference is hidden by macros used in the SDK header files. For more information, see Conventions for Function Prototypes.
    
    The lpProcName parameter can identify the DLL function by specifying an ordinal value associated with the function in the EXPORTS statement. GetProcAddress verifies that the specified ordinal is in the range 1 through the highest ordinal value exported in the .def file. The function then uses the ordinal as an index to read the function's address from a function table.
    
    If the .def file does not number the functions consecutively from 1 to N (where N is the number of exported functions), an error can occur where GetProcAddress returns an invalid, non-NULL address, even though there is no function with the specified ordinal.
    
    If the function might not exist in the DLL module—for example, if the function is available only on Windows Vista but the application might be running on Windows XP—specify the function by name rather than by ordinal value and design your application to handle the case when the function is not available, as shown in the following code fragment.

    .PARAMETER ModuleHandle

    A handle to the DLL module that contains the function or variable. The LoadLibrary, LoadLibraryEx, LoadPackagedLibrary, or GetModuleHandle function returns this handle.
    
    The GetProcAddress function does not retrieve addresses from modules that were loaded using the LOAD_LIBRARY_AS_DATAFILE flag. For more information, see LoadLibraryEx.

    .PARAMETER FunctionName

    The function or variable name, or the function's ordinal value. If this parameter is an ordinal value, it must be in the low-order word; the high-order word must be zero.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func kernel32 GetProcAddress ([IntPtr]) @(
        [IntPtr], #_In_ HMODULE hModule
        [string]  #_In_ LPCSTR  lpProcName
    ) -EntryPoint GetProcAddress -SetLastError)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/ms683212(v=vs.85).aspx
    
    .EXAMPLE
    #>

    param
    (
       [Parameter(Mandatory = $true)]
       [IntPtr]
       $ModuleHandle,
       
       [Parameter(Mandatory = $true)]
       [string]
       $FunctionName 
    )

    $SUCCESS = $kernel32::GetProcAddress($ModuleHandle, $FunctionName); $LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

    if($SUCCESS -eq 0)
    {
        throw "[GetProcAddress]: Error: $(([ComponentModel.Win32Exception] $LastError).Message)"
    }

    Write-Output $SUCCESS
}