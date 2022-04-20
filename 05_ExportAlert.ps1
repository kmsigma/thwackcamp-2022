#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

<#
Orion.AlertConfigurations.Export  arguments
--------------------------
- alertId [int32]
- stripSensitiveData [bool]
- protectionPassword [string]
#>

#region Build Parameters
$AlertId = '42'
$StripSensitiveData = $false
$ProtectionPassword = '' # empty string
#endregion Build Parameters

$AlertContent = Invoke-SwisVerb -SwisConnection $SwisConnection -EntityName 'Orion.AlertConfigurations' -Verb 'Export' -Arguments ( $AlertId, $StripSensitiveData, $ProtectionPassword )
# Either $AlertContent.InnerText | Out-File -FilePath '.\Scratch\Alert_#42.xml'
# Or the below two lines
#                     +-- forcibly "cast" the string in $AlertContent.InnerText to an XML type
#                     |
#                     v
$ReportDefinition = [xml]( $AlertContent.InnerText )
# Use the native Save method from the XML document variable type
$ReportDefinition.Save('.\Scratch\' + $ReportDefinition.AlertDefinition.Name + '.xml')