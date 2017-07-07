function FreeContextBuffer
{
    <#
    .SYNOPSIS

    The FreeContextBuffer function enables callers of security package functions to free memory buffers allocated by the security package.

    .DESCRIPTION

    Memory buffers are typically allocated by the InitializeSecurityContext (General) and AcceptSecurityContext (General) functions.
    
    The FreeContextBuffer function can free any memory allocated by a security package.

    .PARAMETER Buffer

    A pointer to memory to be freed.

    .NOTES
    
    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    (func secur32 FreeContextBuffer ([UInt32]) @(
          [IntPtr] #_In_ PVOID pvContextBuffer
    ) -EntryPoint FreeContextBuffer)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/aa375416(v=vs.85).aspx

    .EXAMPLE

    PS > $PackageCount = 0
    PS > $PackageInfo = [IntPtr]::Zero

    PS > $SUCCESS = $Secur32::EnumerateSecurityPackages([ref]$PackageCount, [ref]$PackageInfo)

    #
    # Do Stuff ...
    #

    PS > FreeContextBuffer -Buffer $PackageInfo
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [IntPtr]
        $Buffer
    )

    $SUCCESS = $Secur32::FreeContextBuffer($Buffer)

    if($SUCCESS -ne 0)
    {
        throw "FreeContextBuffer Error: $($SUCCESS)"
    }
}