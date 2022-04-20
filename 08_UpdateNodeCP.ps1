#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one

<# Super-brief Hashtables overview...
############################################################
Given this definition:
    $Properties = @{
        'Comment' = 'East Coast Data Center';
        'Team'    = 'Virtualization';
        'Owner'   = 'joe@company.corp';
        'Sev'     = 1;
    }

The "keys" of the hashtable are the things on the left side
The "values" of the hashtable are the things on the right side
"Keys" should always be strings
"Values" are not strongly-typed (meaning you can have a single hashtable with strings, integers, decimals, etc. as various values)

-Adding new key/value pair:
    $Properties['Pi'] = 3.14159265358979
-Retrieving a value based on they key:
    $Properties['Pi']
    RETURNS: 3.14159265358979
-Updating a key/value pair
    $Properties['Pi'] = ( 22 / 7 )
    $Properties['Pi']
    RETURNS: 3.14285714285714
#############################################################>

# Query to pull the things we want to change
$Swql = @'
SELECT [CP].Uri
     , [CP].NodeID
     , [CP].Node.Caption
     , [CP].Team
     , [CP].Comments
FROM Orion.NodesCustomProperties AS [CP]
WHERE [CP].Comments IS NULL
   OR [CP].Team IS NULL
'@


# Query to get the things we want to change
$ListOfNodeCPs = Get-SwisData -SwisConnection $SwisConnection -Query $Swql

# cycle through each custom property in the list above
ForEach ( $NodeCP in $ListOfNodeCPs ) {
    # Build an empty hashtable for the properties
    $Properties = @{}

    # switch is an expanded way to do <if..then..else> processing
    switch -Wildcard ( $NodeCP.Caption ) {
        # Node Caption starts wtih "EAST"
        "EAST*" {
            $Properties['Comments'] = 'East Coast Data Center'
        }
        "NOC*" {
            $Properties['Comments'] = 'Network Operations Center'
        }
        "LAB*" {
            $Properties['Comments'] = 'Network Operations Center'
        }
        "WEST*" {
            $Properties['Comments'] = 'West Coast Data Center'
        }
        "NEWY*" {
            $Properties['Comments'] = 'New York Office'
        }
        "LOSA*" {
            $Properties['Comments'] = 'Los Angeles Office'
        }
    } # end of switch command

    # see notes above
    switch -Wildcard ( $NodeCP.Caption ) {
        "*HYV*" {
            $Properties['Team'] = 'Virtualization'
        }
        "*ESX*" {
            $Properties['Team'] = 'Virtualization'
        }
        "*VCENTER*" {
            $Properties['Team'] = 'Virtualization'
        }
        "*FILE*" {
            $Properties['Team'] = 'Server Admins'
        }
        "*SQL*" {
            $Properties['Team'] = 'Data Professionals'
        }
        "*-WAN" {
            $Properties['Team'] = 'Network Engineering'
        }
        "*-CORE" {
            $Properties['Team'] = 'Network Engineering'
        }
        "*-FW-*" {
            $Properties['Team'] = 'Network Engineering'
        }
        "*ADDS*" {
            $Properties['Team'] = 'Identity Management'
        }
        "*MPE*" {
            $Properties['Team'] = 'Systems Monitoring'
        }
        "*APE*" {
            $Properties['Team'] = 'Systems Monitoring'
        }
        "*AWS*" {
            $Properties['Team'] = 'Systems Monitoring'
        }
    } # end of switch command

    # Looking at the properties hashtable, it should have two entries for everything - one for the Comments and one for the Team
    # if it does, then we can proceed
    if ( $Properties.Keys.Count -eq 2 ) {
        Write-Warning -Message "[UPDATE] Updating custom properties for $( $NodeCP.Caption )"
        Set-SwisObject -SwisConnection $SwisConnection -Uri $NodeCP.Uri -Properties $Properties
    }
    # if not, then we should throw some type of message saying we're skipping it
    else {
        Write-Warning -Message "[SKIP]   No matching custom properties for $( $NodeCP.Caption )"
    }

} # end of ForEach loop