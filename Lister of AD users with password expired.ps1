clear

$time=$(get-date -f yyyyMMdd-HHmmss)

# AD server name
$server="SERVEURAD1"
# Directory for the resulting CSV files
$folder="C:\Technique"
# The output CSV file
$CSVoutputFilename="$folder\$server - AD users with password expired-$time.csv"

# Creating the list of AD users whose the password has expired into a file
Get-ADUser -Filter { Enabled -eq "True" } -Properties PasswordExpired | Where {$_.PasswordExpired -eq $true } | sort-object -property SamAccountName | Export-CSV -Encoding UTF8 -Delimiter ";" -Path $CSVoutputFilename