#Requires -RunAsAdministrator

Write-Output "Installing Mozilla Firefox Developer Edition"
winget install --id=Mozilla.Firefox.DeveloperEdition -e
Write-Output "Installing Github Packages"
winget install --id=Git.Git -e ; winget install --id=GitHub.cli -e ; winget install --id=GitHub.GitHubDesktop -e 
Write-Output "Installing Extra package"
winget install --id=Microsoft.WindowsTerminal -e
