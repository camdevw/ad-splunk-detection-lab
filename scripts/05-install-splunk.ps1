# 05 - Silent install of Splunk Enterprise on DC01
# Installer + add-on are shared read-only from the host via a VirtualBox shared folder (\\VBoxSvr\LabFiles).
$src = Get-ChildItem '\\VBoxSvr\LabFiles' | Where-Object Name -like 'splunk-*.msi' | Select-Object -First 1
$ta  = Get-ChildItem '\\VBoxSvr\LabFiles' | Where-Object Name -like '*.spl'       | Select-Object -First 1
Copy-Item $src.FullName, $ta.FullName C:\Lab\

$pw    = Read-Host "Create Splunk admin password (8+ chars)" -AsSecureString
$plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw))
Start-Process msiexec.exe -Wait -ArgumentList "/i `"C:\Lab\$($src.Name)`" AGREETOLICENSE=Yes SPLUNKUSERNAME=admin SPLUNKPASSWORD=`"$plain`" LAUNCHSPLUNK=1 /quiet"
Remove-Variable plain
Test-Path 'C:\Program Files\Splunk\bin\splunk.exe'   # expect True
