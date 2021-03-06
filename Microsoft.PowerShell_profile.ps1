#record custom functions for displaying
$sysfunctions = gci function:
function myfunctions {gci function: | where {$sysfunctions -notcontains $_} | where {$_.Source -eq ""}}

#Customize powershell UI
#$Shell = $Host.UI.RawUI
#$size = $Shell.WindowSize
#$size.width=255
#$size.height=50
#$Shell.WindowSize = $size
# $size = $Shell.BufferSize
# $size.width=70
# $size.height=5000
# $Shell.BufferSize = $size
# $Shell.BackgroundColor = 'Black'
# $shell.ForegroundColor = �White�

#Get VS Commands like msbuild in powershell
pushd 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools'    
cmd /c "vsvars32.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd
write-host "`nVisual Studio 2015 Command Prompt variables set." -ForegroundColor Yellow
#Load additional scripts
. D:\GihubPowerShellScripts\powershellFunctions.ps1
if([System.IO.File]::Exists("D:\GihubPowerShellScripts\WorkPowerShellScripts.ps1"))
{
  . D:\GihubPowerShellScripts\WorkPowerShellScripts.ps1
}
#Set the MACHINE_STORAGE_PATH for docker-machine
$env:MACHINE_STORAGE_PATH = "D:\DockerImages\machine\"

#Display custom functions
Write-Host "Custom functions:"
myfunctions
cd D:\
#clear

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
