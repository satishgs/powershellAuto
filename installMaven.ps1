# Define your paths
$networkPath = "<network_path>\apache-maven-3.8.2-bin.zip"
$localPath = "<local_path>"

# Check if local path exists, create it if it does not
if (!(Test-Path -Path $localPath)) {
    Write-Host "Creating destination directory..."
    New-Item -ItemType Directory -Force -Path $localPath
}

# Define path to the copied zip file and the path where it should be extracted
$zipFile = Join-Path -Path $localPath -ChildPath "apache-maven-3.8.2-bin.zip"
$extractPath = $localPath

# Check if Maven zip file already exists locally, copy it from network if it does not
if (!(Test-Path -Path $zipFile)) {
    Write-Host "Copying Maven package from network path..."
    Copy-Item -Path $networkPath -Destination $localPath
}

# Extract the Maven archive if it has not been extracted
$mavenHome = Join-Path -Path $localPath -ChildPath "apache-maven-3.8.2"
if (!(Test-Path -Path $mavenHome)) {
    Write-Host "Extracting Maven package..."
    Expand-Archive -Path $zipFile -DestinationPath $extractPath
}

# Set up environment variables if they are not already set
if (![Environment]::GetEnvironmentVariable("M2_HOME", "User") -or ![Environment]::GetEnvironmentVariable("PATH", "User").Contains("$mavenHome\bin")) {
    Write-Host "Setting up environment variables..."
    [Environment]::SetEnvironmentVariable("M2_HOME", $mavenHome, "User")
    [Environment]::SetEnvironmentVariable("PATH", "$env:PATH;$env:M2_HOME\bin", "User")
}

# Validate the installation
Write-Host "Validating the installation..."
mvn -version
