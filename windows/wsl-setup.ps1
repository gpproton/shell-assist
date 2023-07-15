Write-Output "Setting up Windows Linux SubSystem..."
Enable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux' -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName 'VirtualMachinePlatform' -All -NoRestart
wsl --update
wsl --set-default-version 2

Invoke-WebRequest https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile ./wsl-kernel.msi
Write-Output "Starting WSL kernel installation..."
Start-Process ./wsl-kernel.msi -ArgumentList "/quiet /passive"
Remove-Item ./wsl-kernel.msi

Write-Output "Installing Ubuntu image.."
wsl --install Ubuntu
