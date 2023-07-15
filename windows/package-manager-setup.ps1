## Winget stup for windows
if ((Get-ComputerInfo | Select-Object -expand OsName) -match 10) {
    Write-Output "Starting Winget setup"
    Invoke-WebRequest https://github.com/microsoft/winget-cli/releases/download/v1.6.1573-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile ./winget.msixbundle
    Add-AppPackage -path ./winget.msixbundle
    Remove-Item ./winget.msixbundle
}
else {
    Install-Module -Name Microsoft.WinGet.Client -Force -AllowPrerelease -AcceptLicense
}

## chocolatey setup
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
