#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

<#
Orion.Nodes.Unmanage arguments
--------------------------
- netObjectId [string] - formatted as 'N:<NodeID>'
- unmanageTime [datetime]
- remanageTime [datetime]
- isRelative [bool]
#>

#region Build Parameters
$NetObjectId = 'N:95'
$UnmanageTime = Get-Date
$RemanageTime = $UnmanageTime.AddHours(1)
$IsRelative = $false
#endregion Build Parameters

Invoke-SwisVerb -SwisConnection $SwisConnection -EntityName 'Orion.Nodes' -Verb 'Unmanage' -Arguments ( $NetObjectId, $UnmanageTime, $RemanageTime, $IsRelative )
<#
       ^                               ^                         ^                   ^                                           ^
       |                               |                         |                   |                                           |
       +-- Function                    |                         |                   |                                           |
                                       +-- Connection from Authentication script     |                                           |
                                                                 |                   |                                           |
                                                                 + -- Entity on which to operate                                 |
                                                                      (they look like 'tables' in SWQL Studio)                   |
                                                                                     |                                           |
                                                                                     +-- Verb to call from the entity            |
                                                                                                                                 +-- Arguments to send the verb (order is important)
       
#>                     

