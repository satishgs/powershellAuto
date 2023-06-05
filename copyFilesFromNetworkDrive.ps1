# Define the network path
$networkPath = "\\server\share\Software"

# Define the destination directory
$destinationDirectory = "C:\Temp\Software"

# Check if the network path exists
if (!(Test-Path $networkPath)) {
    Write-Host "Network path not available. Please make sure the path is correct and accessible."
    exit
}

# Check if the destination directory exists, create it if necessary
if (!(Test-Path $destinationDirectory)) {
    New-Item -ItemType Directory -Path $destinationDirectory | Out-Null
}

# Get the software files from the network path
$files = Get-ChildItem -Path $networkPath -File

# Copy the files to the destination directory
foreach ($file in $files) {
    $destinationFile = Join-Path -Path $destinationDirectory -ChildPath $file.Name
    Copy-Item -Path $file.FullName -Destination $destinationFile -Force
}

Write-Host "Software files copied successfully to: $destinationDirectory"
