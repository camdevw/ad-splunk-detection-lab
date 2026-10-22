# 99 - Reset after a test run so the simulation can be repeated
Unlock-ADAccount -Identity user7
Remove-ADGroupMember "Domain Admins" -Members svc_backup -Confirm:$false
Remove-ADUser svc_backup -Confirm:$false
