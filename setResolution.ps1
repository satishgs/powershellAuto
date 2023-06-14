# Run PowerShell as administrator

# Get the display information
$display = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams

# Define the desired resolution width and height
$width = 1920
$height = 1080

# Change the display resolution
Set-DisplayResolution -Width $width -Height $height -Force
