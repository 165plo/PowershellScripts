#record custom functions for displaying
$sysfunctions = gci function:
function myfunctions {gci function: | where {$sysfunctions -notcontains $_} | where {$_.Source -eq ""}}
#Customize powershell UI
$Shell = $Host.UI.RawUI
$size = $Shell.WindowSize
$size.width=164
$size.height=50
$Shell.WindowSize = $size
# $size = $Shell.BufferSize
# $size.width=70
# $size.height=5000
# $Shell.BufferSize = $size
# $shell.BackgroundColor = “Blue”
# $shell.ForegroundColor = “White”

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
#Display custom functions
Write-Host "Custom functions:"
myfunctions
cd D:\
#clear
