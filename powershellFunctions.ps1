new-item alias:np++ -value "C:\Program Files (x86)\Notepad++\notepad++.exe"
new-item alias:ag -value "C:\Program Files\Silver Searcher\ag.exe"
new-item alias:lprun -value "C:\Program Files (x86)\LINQPad5\LPRun.exe"
Import-Module posh-docker
Import-Module posh-git

function SearchInFiles ($text){
	dir -Recurse | Select-String -pattern $text
}

function ResxCompare($OrigFile, $NewFile){
	[xml]$OrigXmlDoc = Get-Content $OrigFile
	[xml]$NewXmlDoc = Get-Content $NewFile
	if($OrigXmlDoc.root.data.Count -ne $NewXmlDoc.root.data.Count){
		"The 2 XML files have a different number of resources";
		return;
	}
	for($i = 0; $i -le $OrigXmlDoc.root.data.Count; $i++){
		if($OrigXmlDoc.root.data[$i].value -ne $NewXmlDoc.root.data[$i].value -And 
		(-not ([string]::IsNullOrEmpty($OrigXmlDoc.root.data[$i].comment)) -And $OrigXmlDoc.root.data[$i].comment.ToLower() -ne "DO NOT LOCALIZE".ToLower())){
			Write-Host "The values for $($OrigXmlDoc.root.data[$i].value) match.";
			return;
		}
	}
	"Resx has all the same data points with different values";
}

function GetVmIps(){
	Get-VM | Where {$_.State -eq 'Running'} | Select -ExpandProperty NetworkAdapters | Format-Table -Property VMName,IPAddresses
}

function StopAllDockerImages(){
	docker ps --format "{{.Names}}" | foreach{"Stopping"; docker stop $_}
}

$sysVariables = Get-Variable
function myVars {Get-Variable | where {$sysVariables -notcontains $_}}

function RunSqlScripts{
	Param(
		[Parameter(Mandatory=$true)]
		[string] $User,
		[Parameter(Mandatory=$true)]
		[string] $Password,
		[Parameter(Mandatory=$true)]
		[string] $Database,
		[Parameter(Mandatory=$true)]
		[string] $Server
	)
	(ls *.sql -Recurse | sort -Property Name).FullName | Select-String -Pattern "([0-9]{10}_)\w+" | foreach {Write-Host $_; sqlcmd -U $User -P $Password -d $Database -S $Server -i "$_"}
}
