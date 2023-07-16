param(
    [Parameter(Mandatory=$False, Position=0, ValueFromPipeline=$false)]
    [System.String]
    $Param1="help",

    [Parameter(Mandatory=$False, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $Param2="xx-xx-xx"
)

Write-Host $Param2

if ($Param1 -eq "help") {
    Write-Host $Param1
}

# $isAdmin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
# if (!$isAdmin) { 
#     # Start-Process pwsh "-NoLogo -ExecutionPolicy Bypass -Command $PSCommandPath -Param1 $Param1 -Param2 $Param2" -Verb RunAs; # //Run this script as Administrator.
#     # exit # //Exit from this non elevated context.
# }
# Write-Host $isAdmin

# function Test-Admin {
#     $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
#     $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
# }
# # If we are in a non-admin execution. Execute this script as admin
# if ((Test-Admin) -eq $false) {
#     exit
# }
