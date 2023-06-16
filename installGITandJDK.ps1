# Configuration
$javaSource = "\\shared\path\to\java\jdk-setup.exe"
$javaDestination = "C:\Software\java"
$javaInstallDir = "C:\Program Files\Java\jdk"

$gitSource = "\\shared\path\to\git\git-setup.exe"
$gitDestination = "C:\Software\git"
$gitInstallDir = "C:\Program Files\Git"

# Copy Java
Write-Host "Copying Java..."
Copy-Item -Path $javaSource -Destination $javaDestination

# Install Java
Write-Host "Installing Java..."
Start-Process -FilePath "$javaDestination\jdk-setup.exe" -ArgumentList "/s /INSTALLDIR=`"$javaInstallDir`"" -Wait

# Copy Git
Write-Host "Copying Git..."
Copy-Item -Path $gitSource -Destination $gitDestination

# Install Git
Write-Host "Installing Git..."
Start-Process -FilePath "$gitDestination\git-setup.exe" -ArgumentList "/SILENT" -Wait

# Set Java path
Write-Host "Setting Java path..."
$envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$javaPath = "$javaInstallDir\bin"
$gitPath = "$gitInstallDir\bin"
$updatedPath = $envPath + ";" + $javaPath + ";" + $gitPath
[Environment]::SetEnvironmentVariable("Path", $updatedPath, "Machine")

# Validate Java installation
Write-Host "Validating Java installation..."
java -version

# Validate Git installation
Write-Host "Validating Git installation..."
git --version

Write-Host "JDK and Git installation complete."
