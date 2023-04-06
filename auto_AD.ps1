# Script: Automate Active Directory Configuration
# Author: Mac's PC
# Date of latest revision: 04 MAR 23

# Mac's PC Sources:
    # [Press Any Key to Continue in PowerShell](https://java2blog.com/press-any-key-to-continue-powershell/)
    # [Get-ADUser](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-aduser?view=windowsserver2022-ps)
    # [Format-Table](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7.3)
    # [about_While] (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_while?view=powershell-7.3)

Import-Module ActiveDirectory

function Assign-IP-DNS{
    
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

    # Verify Changes and return to manu
    Write-Host ""
    Read-Host "Press any key to Verify Changes..."
    Write-Host ""

    ipconfig /all

    Read-Host "Press any key to return to menu..."
}

function Rename-Server{

}

function Create-NewUser {
    clear
    Write-Host ""
    Write-Host "Welcome to new user account set up"
    Write-Host "----------------------------------"

    $full_name = Read-Host "Please enter new users full name (First Last)"
    $user_name = Read-Host "Please enter new users USERNAME"
    Write-Host ""
    Write-Host "Passwords must be no less than seven characters and must include at least three of the following four character classes:"
    Write-Host "Uppercase letters (A-Z), Lowercase letters (a-z), Digits (0-9), Special characters (e.g., !@#$%^&*)"
    Write-Host "" 
    $password = Read-Host -AsSecureString "Please enter $full_name's secure password"
    $company_name = Read-Host "Please enter the company name"
    $office_location = Read-Host "Please enter $full_name's office location"
    $dept_name = Read-Host "Please enter $full_name's department"
    $job_title = Read-Host "Please enter $full_name's job title"
    Write-Host ""

    Read-Host "Press any key to create user..."

    New-ADUser -Name $full_name -SamAccountName $user_name -Accountpassword $password -Company $company_name  -Office $office_location -Department $dept_name -Title $job_title -Enabled $true

    Read-Host "New user $user_name created! Press any key to verify..."
    
    # Verifies new user was created and prints formatted table with all eight properties for all AD users to screen

    Get-ADUser -Filter * -Properties * | Format-Table Name, SamAccountName, Created, Company, Office, Department, Title, Enabled

    Read-Host "Press any key to continue..."
}

while($true) {
    clear
    Write-Host "----------------------------------------------------"
    Write-Host "Welcome to the Active Directory Configuration Wizard"
    Write-Host "----------------------------------------------------"
    Write-Host "1) Assign Windows Server a static IPv4 address and Domain Name Server (DNS)"
    Write-Host "2) Rename Windows Server"
    Write-Host "3) Install Active Directory Domain Services"
    Write-Host "4) Create an Active Directory Forest"
    Write-Host "5) Create an Active Directory Organizational Unit (OU)"
    Write-Host "6) Create an Active Directory User Account"
    Write-Host "exit) Exit Active Directory Configuration Wizard"
    Write-Host "----------------------------------------------------"
    $Selection = Read-Host "Please make a selection..."

    if ($Selection -eq 1) {
    Assign-IP-DNS
    } elseif ($Selection -eq 2) {
    Rename-Server
    } elseif ($Selection -eq 3) {
    exit
    } elseif ($Selection -eq 4) {
    exit
    } elseif ($Selection -eq 5) {
    exit
    } elseif ($Selection -eq 6) {
    Create-NewUser
    } elseif ($Selection -eq "exit") {
    Write-Host ""
    Write-Host "You have exited the Active Directory Configuration Wizard successfully!"
    Write-Host ""
    exit
    } else {
    Write-Host "Invalid Input!"
    }
}




