#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

<#########################################################################################
This is a completely acceptable way to export modern dashboards, but there's a better way

See '07_ExportDashboardBetter.ps1'
#########################################################################################>

<#
Orion.Dashboards.Instances.Export  arguments
--------------------------
- dashboardId [int32]
#>

#region Build Parameters
$DashboardId = '22'
#endregion Build Parameters

$DashboardContent = Invoke-SwisVerb -SwisConnection $SwisConnection -EntityName 'Orion.Dashboards.Instances' -Verb 'Export' -Arguments $DashboardId
$DashboardContent.InnerText | Out-File -FilePath '.\Scratch\Dashboard_#22.json'