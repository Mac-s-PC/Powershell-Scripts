bash

# Specify the old VM name and the new VM name
$oldVMName = "OldVMName" $newVMName = "NewVMName" 
# Connect to the Hyper-V server
$serverName = "HypervServerName" $cred = Get-Credential Connect-VIServer -Server $serverName -Credential $cred
# Get the old VM object and rename it 
$vm = Get-VM -Name $oldVMName $vm | Set-VM -NewName $newVMName 
# Disconnect from the Hyper-V server
Disconnect-VIServer -Server $serverName -Force


To use this script, replace the OldVMName and NewVMName variables with the actual names
of the VM before and after the rename operation, respectively. Then, replace the HypervServerName
with the name or IP address of your Hyper-V server. Finally, run the script in a PowerShell console
with administrative privileges. The script will prompt you for credentials to connect to the Hyper-V
server, and then it will rename the specified VM.

Sources :google,chatgrp
