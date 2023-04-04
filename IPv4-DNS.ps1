# Input parameters
$Username = Read-Host "Enter username"
$IpAddress = Read-Host "Enter IPv4 address"
$Gateway = Read-Host "Enter default gateway address"
$Dns = Read-Host "Enter DNS server address"

# Add the IPv4 address for the new user
New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4 -IPAddress $IpAddress -PrefixLength 24 -DefaultGateway $Gateway

# Set the DNS server address for the new user
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $Dns

# Set the user's IPv4 address configuration to static
Set-NetIPInterface -InterfaceAlias "Ethernet" -InterfaceMetric 10 -AddressFamily IPv4 -Dhcp Disabled -IPAddress $IpAddress -PrefixLength 24 -DefaultGateway $Gateway

# Add the new user to the local network access group
Add-LocalGroupMember -Group \"Network Configuration Operators" -Member $Username
