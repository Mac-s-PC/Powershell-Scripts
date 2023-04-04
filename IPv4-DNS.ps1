# Replace USERNAME with the new user's username
$Username = "USERNAME"

# Replace NEW_IP_ADDRESS with the new user's IPv4 address
$IpAddress = "NEW_IP_ADDRESS"

# Add the IPv4 address for the new user
New-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4 -IPAddress $IpAddress -PrefixLength 24 -DefaultGateway "DEFAULT_GATEWAY_ADDRESS"

# Set the DNS server address for the new user
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "DNS_SERVER_ADDRESS"

# Set the user's IPv4 address configuration to static
Set-NetIPInterface -InterfaceAlias "Ethernet" -InterfaceMetric 10 -AddressFamily IPv4 -Dhcp Disabled -IPAddress $IpAddress -PrefixLength 24 -DefaultGateway "DEFAULT_GATEWAY_ADDRESS"

# Add the new user to the local network access group
Add-LocalGroupMember -Group "Network Configuration Operators" -Member $Username