#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

# Import the Modern Dashboard functions
# Download from: https://github.com/solarwinds/OrionSDK/blob/master/Samples/PowerShell/functions/func_ModernDashboards.ps1
# and save on your local machine.
. .\func_ModernDashboards.ps1

# Import the modern dashboard
Import-ModernDashboard -SwisConnection $SwisConnection -Path '.\Scratch\ImportThisOtherDashboard.json'

# Import the same modern dashboard again
Import-ModernDashboard -SwisConnection $SwisConnection -Path '.\Scratch\ImportThisOtherDashboard.json'
# returns an error because we don't want to overwrite

# Forcibly import the same modern dashboard again (which will overwrite the existing)
Import-ModernDashboard -SwisConnection $SwisConnection -Path '.\Scratch\ImportThisOtherDashboard.json' -Force