#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

# Export the Modern Dashboard functions
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

# Export the Modern Dashboard
Export-ModernDashboard -SwisConnection $SwisConnection -DashboardId 22 -OutputFolder '.\Scratch'

# Export all the Modern Dashboard (including "system" ones)
Export-ModernDashboard -SwisConnection $SwisConnection -IncludeSystem -IncludeId -OutputFolder '.\Scratch'