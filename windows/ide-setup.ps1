echo "Installing VsCode"
winget install vscode
echo "Installing Microsoft Visual Studio 2022"
winget install --id=Microsoft.VisualStudio.2022.Community-Preview -e
echo "Installing Dev frameworks.."
winget install --id= Microsoft.DotNet.SDK.7 -e winget install --id=Microsoft.DotNet.SDK.Preview -e ; winget install --id=OpenJS.NodeJS.LTS -e
