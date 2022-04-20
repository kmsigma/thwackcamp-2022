#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

<#
Orion.AlertActive.Acknowledge arguments
--------------------------
- alertObjectIds [int32[]]
- notes [string]
#>

# The note to add
$Notes = "We're ack-ing via a PowerShell script"

# Get the fields for the needed parameters for the alert we want to acknowledge
$Swql = @"
SELECT [AA].AlertObjectID
     , [AA].AlertObjects.EntityCaption
FROM Orion.AlertActive AS [AA]
WHERE IsNull([AA].Acknowledged, False) = False
  AND [AA].AlertObjects.EntityCaption = 'NOCSQL01v'
"@

$AlertsToBeAckd = Get-SwisData -SwisConnection $SwisConnection -Query $Swql
Write-Warning -Message "We'll be ack-ing $( $AlertsToBeAckd.Count ) alerts."

#region Build Parameters
$AlertObjectIds = $AlertsToBeAckd.AlertObjectId

# Note is from above, since it doesn't change
#endregion Build Parameters

Invoke-SwisVerb -SwisConnection $SwisConnection -EntityName 'Orion.AlertActive' -Verb 'Acknowledge' -Arguments ( @( $AlertObjectIds ), $Notes )




