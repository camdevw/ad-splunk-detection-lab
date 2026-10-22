# 06 - Install Splunk Add-on for Windows, create the wineventlog index, collect the Security log
# Config is written as files (no Splunk login needed). Same content as splunk/lab_inputs/local in this repo.
$sp = 'C:\Program Files\Splunk'
tar -xzf (Get-ChildItem C:\Lab\*.spl | Select-Object -First 1).FullName -C "$sp\etc\apps"
New-Item "$sp\etc\apps\lab_inputs\local" -ItemType Directory -Force | Out-Null
@'
[wineventlog]
homePath   = $SPLUNK_DB\wineventlog\db
coldPath   = $SPLUNK_DB\wineventlog\colddb
thawedPath = $SPLUNK_DB\wineventlog\thaweddb
'@ | Set-Content "$sp\etc\apps\lab_inputs\local\indexes.conf" -Encoding ASCII
@'
[WinEventLog://Security]
disabled = 0
index = wineventlog
renderXml = false
start_from = oldest
current_only = 0
'@ | Set-Content "$sp\etc\apps\lab_inputs\local\inputs.conf" -Encoding ASCII
& "$sp\bin\splunk.exe" restart
