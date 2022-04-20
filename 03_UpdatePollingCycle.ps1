#region If we don't have a connection to SWIS, build one
if ( -not $SwisConnection ) {
    . .\00_Authenticate.ps1
}
#endregion If we don't have a connection to SWIS, build one


# Query to pull the things we want to change
$Swql = @'
SELECT Uri
     , Caption
     , PollInterval
     , ResponseTime
FROM Orion.Nodes
WHERE Status = 1 -- 'Up'
  AND ObjectSubType <> 'ICMP'
  AND ResponseTime > 80 -- in milliseconds
'@
# ^
# | 
# +-- This is called a here-string.  It's where we can write something on multiple lines and it's all stored
#     in one variable.  They start with @' or @" and end with '@ or "@ on a line to their own.
# I use them frequencly when working with queries because it's easier on the eyes.

# Build a list of Nodes to Update
$ListOfNodes = Get-SwisData -SwisConnection $SwisConnection -Query $Swql

<##############################################
Super Brief Primer on #>
ForEach ( $Node in $ListOfNodes ) {
    $NewInterval = $Node.PollInterval * 1.5 # Current Polling Cycle + 50%
    Write-Warning -Message "Updating $( $Node.Caption ) to a $NewInterval second polling interval"
    Set-SwisObject -SwisConnection $SwisConnection -Uri $Node.Uri -Properties @{ 
        'PollInterval' = $NewInterval                                        # ^
    }                                                                        # |
} # ^                                                                        # |
#   |                                                                          |
#   +-------------------------------------+------------------------------------+
#                                         |
#                          A @{ Key1 = Value 1 } is a hashtable

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