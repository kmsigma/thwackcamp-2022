#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

# Export the Modern Dashboard functions
# Download from: https://github.com/solarwinds/OrionSDK/blob/master/Samples/PowerShell/functions/func_ModernDashboards.ps1
# and save on your local machine.
. .\func_ModernDashboards.ps1

# Export the Modern Dashboard
Export-ModernDashboard -SwisConnection $SwisConnection -DashboardId 22 -OutputFolder '.\Scratch'

# Export all the Modern Dashboard (including "system" ones)
Export-ModernDashboard -SwisConnection $SwisConnection -IncludeSystem -IncludeId -OutputFolder '.\Scratch'