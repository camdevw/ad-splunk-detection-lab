# 01 - Static IP, time zone, AD DS role, rename to DC01
# Run on the Windows Server 2022 VM in an elevated PowerShell session.
$if = (Get-NetAdapter | Where-Object Status -eq Up | Select-Object -First 1).Name
New-NetIPAddress -InterfaceAlias $if -IPAddress 10.0.2.10 -PrefixLength 24 -DefaultGateway 10.0.2.1 | Out-Null
Set-DnsClientServerAddress -InterfaceAlias $if -ServerAddresses 8.8.8.8   # temporary; DC promotion switches DNS to loopback
tzutil /s "Eastern Standard Time"
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Rename-Computer DC01 -Restart
