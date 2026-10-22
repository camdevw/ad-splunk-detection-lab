# 02 - Promote DC01 to the first domain controller of a new forest (lab.local)
# Prompts for the DSRM (SafeModeAdministratorPassword). The server reboots automatically.
Install-ADDSForest -DomainName "lab.local" -DomainNetbiosName "LAB" -InstallDns -Force
