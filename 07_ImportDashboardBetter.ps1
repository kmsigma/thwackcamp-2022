#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

# Import the Modern Dashboard functions
# Download from: https://github.com/solarwinds/OrionSDK/blob/master/Samples/PowerShell/functions/func_ModernDashboards.ps1
if ( -not ( Test-Path -Path '.\functions\' -ErrorAction SilentlyContinue ) ) {
    # We don't have the directory, so let's create it.
    New-Item -Path '.\functions\' -ItemType Directory | Out-Null
}
if ( -not ( Test-Path -Path '.\functions\func_ModernDashboards.ps1' -ErrorAction SilentlyContinue ) ) {
    # We don't have the functions, so let's download them
    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/solarwinds/OrionSDK/master/Samples/PowerShell/functions/func_ModernDashboards.ps1' -OutFile '.\functions\func_ModernDashboards.ps1'
}
    
# Now that we have the functions, let's call them to load them into memory.
. .\functions\func_ModernDashboards.ps1

# Import the modern dashboard
Import-ModernDashboard -SwisConnection $SwisConnection -Path '.\Scratch\ImportThisOtherDashboard.json'

# Import the same modern dashboard again
Import-ModernDashboard -SwisConnection $SwisConnection -Path '.\Scratch\ImportThisOtherDashboard.json'
# returns an error because we don't want to overwrite

# Forcibly import the same modern dashboard again (which will overwrite the existing)
Import-ModernDashboard -SwisConnection $SwisConnection -Path '.\Scratch\ImportThisOtherDashboard.json' -Force