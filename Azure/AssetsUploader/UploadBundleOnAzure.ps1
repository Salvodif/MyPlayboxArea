param([string]$ProjectDir)

# for some reason we have a " to remove at the end of string
$ProjectDir = $ProjectDir.Substring(0,$ProjectDir.Length-1)

$assetsDir = [string]::Format('{0}\{1}', $ProjectDir, 'Assets')

$myCss = Get-ChildItem "$assetsDir\Styles" -Filter "*.css" | % -process { $_.FullName }
$myJs = Get-ChildItem "$assetsDir\Scripts" -Filter "*.js" | % -process { $_.FullName }

[xml]$conf = Get-Content "$ProjectDir\UploadBundleAzureConf.XML"

$name = $conf.AzureConf.AzureAccountInfo.Name
$key = $conf.AzureConf.AzureAccountInfo.Key
$containers = $conf.AzureConf.Blob.Container

$ctx = New-AzureStorageContext -StorageAccountName $name -StorageAccountKey $key

$currContainers = Get-AzureStorageContainer -Context $ctx | % {$_.Name}

foreach ($item in $containers)
{
	if ($currContainers -notcontains $item.Name)
	{
		New-AzureStorageContainer -Name $item.Name -Permission "Container" -Context $ctx
	}
}

$cssdir = $containers | ? {$_.FileExt -eq "css"} | Select -ExpandProperty Name
$jsDir = $containers | ? {$_.FileExt -eq "js"} | Select -ExpandProperty Name

foreach ($css in $myCss)
{
	Set-AzureStorageBlobContent -File "$css" -Container $cssdir -Context $ctx -Force
}

foreach ($js in $myJs)
{
	Set-AzureStorageBlobContent -File "$js" -Container $jsDir -Context $ctx -Force
}

foreach ($name in $currContainers)
{
	$container = Get-AzureStorageContainer -Name $name -Context $ctx
	if ($container.Permission.get_PublicAccess() -eq "Off")
	{
		Set-AzureStorageContainerAcl -Name $name -Permission "Container" -Context $ctx
	}
}

Write-Host "Upload finished!"