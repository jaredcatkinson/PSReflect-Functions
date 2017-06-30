$TIMEZONEINFORMATION = struct $Mod _TIME_ZONE_INFORMATION @{
        Bias            =   field 0 Int32 
        StandardName    =   field 1 string
        StandardDate    =   field 2 $SYSTEMTIME
        StandardBias    =   field 3 Int32 
        DaylightName    =   field 4 string 
        DaylightDate    =   field 5 $SYSTEMTIME 
        DaylightBias    =   field 6 Int32
}