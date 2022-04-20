#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

<#########################################################################################
This is a completely acceptable way to import modern dashboards, but there's a better way

See '07_ImportDashboardBetter.ps1'
#########################################################################################>

<#
Orion.Dashboards.Instances.Import  arguments
--------------------------
- definition [string]
#>

#region Build Parameters
$Definition = Get-Content -Path '.\Scratch\ImportThisDashboard.json' -Raw
#endregion Build Parameters

Invoke-SwisVerb -SwisConnection $SwisConnection -EntityName 'Orion.Dashboards.Instances' -Verb 'Import' -Arguments $Definition
