#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

<#
Orion.AlertSuppression.SuppressAlerts arguments
--------------------------
- entityUris [string[]]
- suppressFrom [datetime] (null)
- suppressTo [datetime] (null)
#>

# Get the URI for the Element we want to Mute
$ToBeMuted = Get-SwisData -SwisConnection $SwisConnection -Query "SELECT Uri, Caption FROM Orion.Nodes WHERE Caption LIKE 'NEWY%'"
# You can also suppress alerts on Interfaces (Orion.NPM.Interfaces), Volumes (Orion.Volumes), Applications (Orion.APM.Applications), and Groups (Orion.Groups)
Write-Warning -Message "We'll be muting $( $ToBeMuted.Count ) entities."
For ( $i = 0; $i -lt $ToBeMuted.Count; $i++ ){
    Write-Warning "`t $( $ToBeMuted[$i].Caption )"
}

#region Build Parameters
$EntityUris = $ToBeMuted.Uri
$SuppressFrom = Get-Date
$SuppressTo = $UnmanageTime.AddMinutes(15)
#endregion Build Parameters

Invoke-SwisVerb -SwisConnection $SwisConnection -EntityName 'Orion.AlertSuppression' -Verb 'SuppressAlerts' -Arguments ( @( $EntityUris ), $SuppressFrom, $SuppressTo )
<#                                                                                                                        ^             ^
                                                                                                                          |             |
                                                                                                                          +------+------+
                                                                                                                                 |
                                                                                                          Wrapping a variable in @(...) converts it to an array
                                                                                                          (this verb expects an array as the first parameter)
#>
