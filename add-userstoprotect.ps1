#This is a script that will pull a list of users that have Business Premium or E5 licenses, then add them to the list of Targeted Users to protect for the Standard Preset Security Policy
#connect to MSOL so list licenses
Connect-Msolservice
Connect-ExchangeOnline
#get premium users
$user_list = Get-MsolUser | Where-Object {($_.licenses).AccountSkuId -match "SPB" -or ($_.licenses).AccountSkuID -match "E5"}
#connect to EO to change antiphish policy
#format the user list to match what antiphish policy requires for the TargetedUsersToProtect Field
$formatted_ul = $user_list | ForEach-Object { $_.DisplayName + ";" + $_.UserPrincipalName}
$policy = get-antiphishpolicy | Where-Object -Property Identity -Match "Standard"
$policyID = $policy.Identity
set-antiphishpolicy -Identity $policyID -TargetedUsersToProtect $formatted_ul
