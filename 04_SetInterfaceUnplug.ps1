#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one


# Query to pull the things we want to change
$Swql = @'
SELECT [Interfaces].Uri
     , [Interfaces].Caption AS [InterfaceCaption]
     , [Interfaces].Node.Caption AS [NodeCaption]
FROM Orion.NPM.Interfaces AS [Interfaces]
WHERE [Interfaces].Unpluggable = False
  AND [Interfaces].Node.VendorInfo.DisplayName = 'Cisco'
  AND [Interfaces].TypeName = 'ethernetCsmacd'
  AND [Interfaces].Caption LIKE 'mgmt%'
'@


# Build a list of interfaces to update to an 'unplugged' status
$ListOfInterfaces = Get-SwisData -SwisConnection $SwisConnection -Query $Swql

ForEach ( $Interface in $ListOfInterfaces ) {
    Write-Warning -Message "Updating $( $Interface.InterfaceCaption ) on $( $Interface.NodeCaption ) to be Unpluggable"
    Set-SwisObject -SwisConnection $SwisConnection -Uri $Interface.Uri -Properties @{ 
        'Unpluggable' = $true
    }
}