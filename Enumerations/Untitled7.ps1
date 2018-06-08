function Get-StructureOffset
{
    <#
    .SYNOPSIS

    Returns the field offset of the unmanaged form of the managed structure.

    .DESCRIPTION

    Wraps the Marshal class' OffsetOf method to return the offset for all fields in the specified Structure.

    .NOTES

    Author: Jared Atkinson (@jaredcatkinson)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    .LINK

    https://msdn.microsoft.com/en-us/library/y8ewk18b(v=vs.110).aspx

    .EXAMPLE

    PS> Get-StructureOffset -Type $KERB_RETRIEVE_TKT_REQUEST

    Offset Name              Type
    ------ ----              ----
    0x0000 MessageType       KERB_PROTOCOL_MESSAGE_TYPE
    0x0004 LogonId           LUID
    0x000c TargetName        LSA_UNICODE_STRING
    0x001c TicketFlags       System.UInt32
    0x0020 CacheOptions      KERB_CACHE_OPTIONS
    0x0028 EncryptionType    System.Int64
    0x0030 CredentialsHandle SecHandle
    #>

    param
    (
        [Parameter(Mandatory = $true)]
        [type]
        $Type
    )

    if($Type.IsValueType -and !($Type.IsEnum))
    {
        foreach($field in $Type.DeclaredFields)
        {
            $offset = [System.Runtime.InteropServices.Marshal]::OffsetOf($Type, $field.Name)
            $hexoffset = [String]::Format("0x{0:x3}", [Int]$offset)

            $obj = New-Object -TypeName psobject

            $obj | Add-Member -MemberType NoteProperty -Name Offset -Value $hexoffset
            $obj | Add-Member -MemberType NoteProperty -Name Name -Value $field.Name
            $obj | Add-Member -MemberType NoteProperty -Name Type -Value $field.FieldType
        
            Write-Output $obj
        }
    }
    else
    {
        throw "Type $($Type.FullName) is not a valid Structure"
    }
}