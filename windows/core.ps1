####################################
### core windows requirements
####################################

#Requires -RunAsAdministrator

Install-Module -Name PowerShellGet -Force
Update-Module -Name PowerShellGet
Install-PowerShell -Scope CurrentUser -AllowPrerelease
