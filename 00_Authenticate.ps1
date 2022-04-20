$Hostname = 'orionserver.domain.local' # <-- Put your Orion Server IP or DNS Name here

#region Authenticate with "Orion" Credentials
# Prompt for username & password
$SwisCreds = Get-Credential -Message "Enter Orion Credentials for '$Hostname'"
$SwisConnection = Connect-Swis -Hostname $Hostname -Credential ( $SwisCreds )
#endregion Authenticate with "Orion" Credentials

#region Authenticate with "Trusted" credentials
# the -Trusted parameter indicates that we will pass through the current user's Windows Credentials to the Orion Server

# Uncomment the following line to authenticate with native Windows Credentials
#$SwisConnection = Connect-Swis -Hostname $Hostname -Trusted
#endregion Authenticate with "Trusted" credentials

#region Authenticate with "Certificate" credentials
# the -Certificate parameter indicates that we will authenticate with the local SolarWinds-Orion certificate
# This is useful when working directly on an Orion server (as they have a matching trusted certificate
# WARNING: All actions under this connection will appear to be from the "_system" account.

# Uncomment the following line to authenticate with certificate
#$SwisConnection = Connect-Swis -Hostname $Hostname -Certificate
#endregion Authenticate with "Certificate" credentials

if ( Get-SwisData -SwisConnection $SwisConnection -Query "SELECT TOP 1 HostName FROM Orion.OrionServers" -ErrorAction SilentlyContinue ) {
    $OrionHost = Get-SwisData -SwisConnection $SwisConnection -Query "SELECT TOP 1 HostName FROM Orion.OrionServers"
    Write-Warning -Message "We're successfully connected to '$OrionHost' using PowerShell $( $PSVersionTable.PSVersion.ToString() ) and $( Get-Module -ListAvailable -Name 'SwisPowerShell' | Select-Object -Property @{ Name = 'ModuleVersion'; Expression = { "$( $_.Name ) $( $_.Version )" } } -Unique | Select-Object -ExpandProperty ModuleVersion )"
    # We don't need the credentials, hostname, or the Orion host anymore, so we can delete them.
    Remove-Variable -Name Hostname, SwisCreds, OrionHost
}
else {
    Write-Error -Message "We're not connected to an Orion server." -RecommendedAction "Validate that the SolarWinds Information Services are running on $Hostname and your credentials are valid."
    # None of our variables work, so delete them all
    Remove-Variable -Name SwisConnection, Hostname, SwisCreds
}
