# 04 - Account lockout policy + advanced audit policy for identity telemetry
# Lockout: 5 bad attempts -> locked 15 minutes
Set-ADDefaultDomainPasswordPolicy -Identity lab.local -LockoutThreshold 5 `
    -LockoutDuration 00:15:00 -LockoutObservationWindow 00:15:00

# Audit subcategories that generate the events the detections rely on:
#   4771/4768 Kerberos auth, 4776 NTLM credential validation, 4625 failed logon,
#   4740 lockout, 4720/4738 user changes, 4728/4732/4756 group membership changes
"Credential Validation","Kerberos Authentication Service","Kerberos Service Ticket Operations",
"User Account Management","Security Group Management","Logon","Account Lockout" |
    ForEach-Object { auditpol /set /subcategory:"$_" /success:enable /failure:enable }

Get-ADDefaultDomainPasswordPolicy | Format-Table LockoutThreshold, LockoutDuration
