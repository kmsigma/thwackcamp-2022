#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

<#
Orion.AlertConfigurations.Import  arguments
--------------------------
- alertXml [string]
- stripSensitiveData [bool]
- protectionPassword [string]
#>

#region Build Parameters
$AlertXml = Get-Content -Path '.\Scratch\ImportThisAlert.xml' -Raw
$StripSensitiveInformation = $false
$ProtectionPassword = '' # empty string
#endregion Build Parameters

Invoke-SwisVerb -SwisConnection $SwisConnection -EntityName 'Orion.AlertConfigurations' -Verb 'Import' -Arguments ( $AlertXml, $StripSensitiveInformation, $ProtectionPassword )