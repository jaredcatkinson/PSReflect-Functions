Contributing

# Functions
- All function defintions must include the following:
    - A comment for each parameter specifying the C type
    - An EntryPoint of the actual function's name

## Function Template
function <API Function Name>
{
    <#
    .SYNOPSIS

    <Function overview from MSDN>

    .DESCRIPTION

    <Remarks Section from MSDN or more detailed remarks from the author>

    .NOTES

    Author: <Author Name and/or (Twitter Handle)>
    License: BSD 3-Clause
    Required Dependencies: <Any required functions, structures, or enumerations> ex. LSA_UNICODE_STRING (Structure)
    Optional Dependencies: <Any optional functions, structures, or enumerations>

    <PSReflect Function Definition>
    Ex:
    (func wtsapi32 WTSFreeMemory ([Int]) @(
        [IntPtr] #_In_ PVOID pMemory
    ) -EntryPoint WTSFreeMemory)
    
    .LINK

    <Functions MSDN page link>

    .EXAMPLE

    <Usage Example>
    #>

   #####
   #
   #  Do Stuff Here
   #
   #####
}

## Adding a function to the project
- Add function in their appropriate directory
- Add any Structures and Enumerations to their appropriate directories
- Update FunctionsDefinitions.ps1 with PSReflect function definition
- Add your function to PSReflect-Functions.psd1

# Structs

# Enumerations