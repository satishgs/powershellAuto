$wmiClass = Get-WmiObject -Namespace root\wmi -Class WmiMonitorBasicDisplayParams
$screenWidth = $wmiClass.MaxHorizontalImageSize
$screenHeight = $wmiClass.MaxVerticalImageSize

$scaleRegistryPath = "HKCU:\Control Panel\Desktop"
$scalingValue = Get-ItemProperty -Path $scaleRegistryPath -Name LogPixels
$scaleFactor = [math]::Round(($scalingValue.LogPixels / 96), 2)

Write-Output "Screen Resolution: $screenWidth x $screenHeight"
Write-Output "Scale Factor: $scaleFactor"
