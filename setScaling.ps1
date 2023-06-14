# Run PowerShell as administrator

# Set the DPI scaling value to 96 (100% scaling)
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "LogPixels" -Value 96

# Sign out and sign back in to apply the changes
shutdown.exe /l
