function Get-Atom
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [UInt16]
        $AtomIndex
    )

    if($PSBoundParameters.ContainsKey('AtomIndex'))
    {
        GlobalGetAtomName -AtomIndex $AtomIndex
    }
    else
    {
        $atomList = New-Object -TypeName System.Collections.Generic.List['string']

        for($i = 0xC000; $i -lt [UInt16]::MaxValue; $i++)
        {
            try
            {
                $atomname = GlobalGetAtomName -AtomIndex $i -ErrorAction Stop
            
                $props = @{
                    Index = $i
                    Name = $atomname
                }

                $obj = New-Object -TypeName psobject -Property $props

                Write-Output $obj
            }
            catch
            {

            }
        }
    }
}