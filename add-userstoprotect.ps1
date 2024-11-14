#This is a script that will pull a list of users, then add them to the Impersonation detection policy. It will prompt you to log in twice as Client's global admin. 
Install-Module MSOnline
Install-Module ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement
#connect to Microsoft Online Service to list users, Exchange Online to change antiphish policy
Connect-Msolservice
Connect-ExchangeOnline
#get premium users
$user_list = Get-MsolUser | Where-Object -Property isLicensed -eq True
#format the user list to match what antiphish policy requires for the TargetedUsersToProtect Field
$formatted_ul = $user_list | ForEach-Object { $_.DisplayName + ";" + $_.UserPrincipalName}
$policyID = (get-antiphishpolicy | Where-Object -Property Identity -Match "Standard").Identity
set-antiphishpolicy -Identity $policyID -TargetedUsersToProtect $formatted_ul
Get-AntiPhishPolicy -Identity $policyID