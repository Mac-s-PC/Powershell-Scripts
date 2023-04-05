bash

# Specify the old and new server names
$OldServerName = "OldServerName"
$NewServerName = "NewServerName"

# Rename the server
Rename-Computer -ComputerName $OldServerName -NewName $NewServerName -Restart

# Wait for the server to restart
Start-Sleep-Seconds 60

# Verify that the server name has changed
if (Test-Connection -ComputerName $NewServerName -Count 1 -ErrorAction SilentlyContinue) {
    Write-Host "Server has been renamed to $NewServerName and is online."
} else {
    Write-Host "Server rename failed."
}

This PowerShell script renames a Windows server by changing the computer name from $OldServerName to $NewServerName. The Rename-Computer 
cmdlet is used to perform the actual renaming, and the -Restart switch is added to prompt the server to restart after the name change.

After the restart, the script uses the Test-Connection cmdlet to check if the server is online with its new name. If the server is online, the
script outputs a message indicating that the server has been renamed to the new name and is online. If the server is not online, the script outputs 
a message indicating that the server rename has failed.

The script also includes a 60-second pause (Start-Sleep -Seconds 60) to give the server enough time to complete the renaming process and restart.


Sources :google,chatgrp
