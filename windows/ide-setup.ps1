Write-Output "Installing VsCode"
winget install vscode
Write-Output "Installing Microsoft Visual Studio 2022"
winget install --id=Microsoft.VisualStudio.2022.Community-Preview -e
Write-Output "Installing Dev frameworks.."
winget install --id= Microsoft.DotNet.SDK.7 -e winget install --id=Microsoft.DotNet.SDK.Preview -e ; winget install --id=OpenJS.NodeJS.LTS -e
