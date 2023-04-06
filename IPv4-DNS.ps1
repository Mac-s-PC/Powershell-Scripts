# Get interface object

$interface = Get-NetAdapter -Name Ethernet

# Set IPv4 configuration

$ipAddress = Read-Host "Enter IPv4 address"
$subnetMask = Read-Host "Enter subnet address"
$gateway = Read-Host "Enter Default Gateway"

New-NetIPAddress -InterfaceIndex $interface.ifIndex -IPAddress $ipAddress -PrefixLength 24 -DefaultGateway $gateway

# Set DNS configuration

$dns = Read-Host "Enter DNS Server Address"

Set-DnsClientServerAddress -InterfaceIndex $interface.ifIndex -ServerAddresses $dns

# Verify Changes

Write-Host ""
Read-Host "Press any key to Verify Changes..."
Write-Host ""

ipconfig /all

Read-Host "Press any key to return to menu..."