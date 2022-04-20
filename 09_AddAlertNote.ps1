#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

<#
Orion.AlertStatus.AddNote arguments
--------------------------
- alertDefinitonId [string] (in GUID format)
- activeObject [string]
- objectType [string]
- note [string]
#>

# The note to add
$Note = "This server is acting badly (Updated by PowerShell script)`nIt will be acknowledged in a moment."
#                                                                   ^
#                                                                   |
# the backtick is an escape character for strings. -----------------+
#  `t = tab, `n = new line, `` = backtick, others

# Get the alerts and the fields corresponding to the arguments we'll need
$AlertsForNotes = Get-SwisData -SwisConnection $SwisConnection -Query "SELECT AlertDefID, ActiveObject, ObjectType FROM Orion.AlertStatus WHERE ObjectName = 'NOCAPPSQL01v'"
Write-Warning -Message "We'll be adding $( $AlertsForNotes.Count ) notes."

ForEach ( $AlertNote in $AlertsForNotes ) {
    #region Build Parameters
    $AlertDefinitionId = [string]$AlertNote.AlertDefId #The AlertDefId property *may* come in a a GUID.  We cast is to string using [string]
    $AlertObject = $AlertNote.ActiveObject
    $ObjectType = $AlertNote.ObjectType
    # Since the note doesn't change, we don't need to re-define it for each alert where we want to tag it.
    # We just use the original one defined above. (line 17)
    #endregion Build Parameters

    Invoke-SwisVerb -SwisConnection $SwisConnection -EntityName 'Orion.AlertStatus' -Verb 'AddNote' -Arguments ( $AlertDefinitionId, $AlertObject, $ObjectType, $Note )
}



