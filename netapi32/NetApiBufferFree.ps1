function NetApiBufferFree
{
    <#
    .SYNOPSIS

    The NetApiBufferFree function frees the memory that the NetApiBufferAllocate function allocates. Applications should also call NetApiBufferFree to free the memory that other network management functions use internally to return information.

    .DESCRIPTION

    The NetApiBufferFree function is used to free memory used by network management functions. This function is used in two cases:
    - To free memory explicitly allocated by calls in an application to the NetApiBufferAllocate function when the memory is no longer needed.
    - To free memory allocated internally by calls in an application to remotable network management functions that return information to the caller. The RPC run-time library internally allocates the buffer containing the return information.
    
    Many network management functions retrieve information and return this information as a buffer that may contain a complex structure, an array of structures, or an array of nested structures. These functions use the RPC run-time library to internally allocate the buffer containing the return information, whether the call is to a local computer or a remote server. For example, the NetServerEnum function retrieves a lists of servers and returns this information as an array of structures pointed to by the bufptr parameter. When the function is successful, memory is allocated internally by the NetServerEnum function to store the array of structures returned in the bufptr parameter to the application. When this array of structures is no longer needed, the NetApiBufferFree function should be called by the application with the Buffer parameter set to the bufptr parameter returned by NetServerEnum to free this internal memory used. In these cases, the NetApiBufferFree function frees all of the internal memory allocated for the buffer including memory for nested structures, pointers to strings, and other data.
    
    No special group membership is required to successfully execute the NetApiBufferFree function or any of the other ApiBuffer functions.

    .PARAMETER Buffer

    A pointer to a buffer returned previously by another network management function or memory allocated by calling the NetApiBufferAllocate function.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func netapi32 NetApiBufferFree ([Int32]) @(
        [IntPtr]    # _In_ LPVOID Buffer
    ) -EntryPoint NetApiBufferFree)

    .LINK
    
    https://msdn.microsoft.com/en-us/library/windows/desktop/aa370304(v=vs.85).aspx

    .EXAMPLE
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $Buffer
    )

    $SUCCESS = $netapi32::NetApiBufferFree($Buffer)

    if($SUCCESS -ne 0)
    {
        throw "NetApiBufferFree Error: $($SUCCESS)"
    }
}