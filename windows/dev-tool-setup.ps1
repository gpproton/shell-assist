echo "Installing Mozilla Firefox Developer Edition"
winget install --id=Mozilla.Firefox.DeveloperEdition -e
echo "Installing Github Packages"
winget install --id=Git.Git -e ; winget install --id=GitHub.cli -e ; winget install --id=GitHub.GitHubDesktop -e 
echo "Installing Extra package"
winget install --id=Microsoft.WindowsTerminal -e
