# Define the network path and installation directory
$networkPath = "\\server\share\maven"
$installDir = "C:\path\to\maven"

# Copy Maven files from network path to local installation directory
try {
    Write-Host "Copying Maven files..."
    Copy-Item -Path $networkPath -Destination $installDir -Recurse -ErrorAction Stop
    Write-Host "Maven files copied successfully!"
}
catch {
    Write-Host "Failed to copy Maven files from the network path. Please check the network connectivity and paths."
    exit 1
}

# Set environment variables
$env:MAVEN_HOME = $installDir
$env:Path += ";$env:MAVEN_HOME\bin"

# Validate Maven installation
$mvnCmdPath = Join-Path $env:MAVEN_HOME 'bin\mvn.cmd'
if (Test-Path $mvnCmdPath) {
    Write-Host "Maven installation successful!"

    # Print Maven version
    Write-Host "Maven version:"
    & $mvnCmdPath -version
}
else {
    Write-Host "Maven installation failed. Please check the installation directory."
    exit 1
}
