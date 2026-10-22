# 03 - Departmental OUs, security groups, and 50 test users
# Each user gets a unique random password, exported to C:\Lab\lab-users.csv (never commit this file).
Import-Module ActiveDirectory
$base  = "DC=lab,DC=local"
$depts = "IT","HR","Sales","Finance","Marketing"

New-ADOrganizationalUnit -Name "LabUsers" -Path $base
foreach ($d in $depts) {
    New-ADOrganizationalUnit -Name $d -Path "OU=LabUsers,$base"
    New-ADGroup -Name "$d-Staff" -GroupScope Global -GroupCategory Security -Path "OU=$d,OU=LabUsers,$base"
}

New-Item C:\Lab -ItemType Directory -Force | Out-Null
$out = @()
1..50 | ForEach-Object {
    $d   = $depts[($_ - 1) % 5]
    $sam = "user$_"
    $pw  = (-join ((65..90) + (97..122) + (48..57) | Get-Random -Count 14 | ForEach-Object { [char]$_ })) + "!9a"
    New-ADUser -Name $sam -SamAccountName $sam -UserPrincipalName "$sam@lab.local" -Department $d `
        -Path "OU=$d,OU=LabUsers,$base" -AccountPassword (ConvertTo-SecureString $pw -AsPlainText -Force) -Enabled $true
    Add-ADGroupMember -Identity "$d-Staff" -Members $sam
    $out += [pscustomobject]@{ User = $sam; Dept = $d; Password = $pw }
}
$out | Export-Csv C:\Lab\lab-users.csv -NoTypeInformation
(Get-ADUser -Filter * -SearchBase "OU=LabUsers,$base").Count   # expect 50
