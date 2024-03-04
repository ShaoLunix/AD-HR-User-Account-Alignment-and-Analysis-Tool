clear

$time=$(Get-Date -f yyyyMMdd-HHmmss)

# AD server name
$server="SERVEURAD1"
# Directory for the resulting CSV files
$folder="C:\Technique"
# The output CSV files
$inputADUsers="$folder\$server - AD-users-$time.csv"
$CSVoutputADUsers="$folder\$server - full-AD-users-$time.csv"
$CSVoutputADUsersGroups="$folder\$server - full-AD-users-groups-$time.csv"

# Creating the list of AD users into a file
Get-ADUser -Filter * | select SamAccountName | Sort-Object -Property Name | ConvertTo-Csv -NoTypeInformation | % { $_ -replace '"', ""} | ? {$_.trim() -ne ""} | Out-File -Encoding UTF8 -Force $inputADUsers
# Getting the AD users's information and writing it to a file
Get-ADUser -Filter * -Properties Name, UserPrincipalName, SamAccountName, Mail, WhenCreated, Department, Enabled, LockedOut, LastLogonTimestamp, PasswordLastSet, PasswordNeverExpires, PasswordNotRequired, CannotChangePassword, PasswordExpired, PrimaryGroup, MemberOf | Sort-Object -Property SamAccountName | Export-Csv -Encoding UTF8 -Delimiter ";" -NoTypeInformation -Path $CSVoutputADUsers

# Going through the list of AD users previously created
# and getting the AD users's groups
$userNameList = Get-Content -Path $inputADUsers

# Initializing the file of AD users's groups
"SamAccountName;MemberOf" | Out-File -Encoding UTF8 -Append "$CSVoutputADUsersGroups"

foreach($username in $userNameList)
{
    if ($username -ne $null)
    {
        Write-Host "user : $username"

        # Getting the current user's groups
        $userGroups=Get-ADPrincipalGroupMembership -Identity $username | Select -Expand Name | Out-String
        
        # Writing all the information without the new lines and carriage returns to the output file
        $username+";"+$userGroups.Replace("`r`n",",") | Out-File -Encoding UTF8 -Append "$CSVoutputADUsersGroups"
    }
    if ([string]::IsNullOrEmpty($username))
    {
        Write-Host "The variable is null."
    }
}