# Script: Automate Active Directory Configuration
# Author: Mac's PC
# Date of latest revision: 04 MAR 23

# Mac's PC Sources:
    # Creat-User function sources:
        # [Press Any Key to Continue in PowerShell](https://java2blog.com/press-any-key-to-continue-powershell/)
        # [Get-ADUser](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-aduser?view=windowsserver2022-ps)
        # [Format-Table](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7.3)
    # Menu functionality sources:
        # [about_While] (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_while?view=powershell-7.3)
    # Assign-IP-DNS function sources:
        #
    # Rename-Server function sources:
        #
    

Import-Module ActiveDirectory

function Install-AD{
    clear
    Write-Host ""
    Read-Host "Press any key to install the Active Directory Domain Services (AD DS) role along with its management tools and verify"
    Write-Host ""

    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

    Get-WindowsFeature -Name AD-Domain-Services, RSAT-ADDS

    Read-Host "Press any key to return to menu..."
}

function Rename-Server{
    # Displays current server name and requests user input for new server name
    clear
    Write-Host ""
    Write-Host "Your current computer name is $env:computername"
    Write-Host ""
    $new_server_name = Read-Host "Please provide the new computer name"

    # Renames server to user provided input
    Rename-Computer -NewName $new_server_name -Force
    Write-Host ""
    Write-Host "Your computer name has been changed to $new_server_name"
    Write-Host ""
    Read-Host "Press any key to restart and apply change..."

    # Restart the computer
    Restart-Computer

    # Wait for the server to restart
    Start-Sleep -Seconds 60

    # Verify server name has changed
    if (Test-Connection -ComputerName $new_server_name -Count 1 -ErrorAction SilentlyContinue) {
        Write-Host "Server has been renamed to $new_server_name and is online."
    } else {
        Write-Host "Server rename failed."
    }

    Read-Host "Press any key to return to menu..."
}

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

function Create-Forest{
    exit
}

function Create-OU{
    exit
}

function Create-NewUser {
    # Requests user input for six Active Directory user properties and a user password
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

    # Executes New-ADUser PowerShell command to create new user and assigns values to eight properties
    New-ADUser -Name $full_name -SamAccountName $user_name -Accountpassword $password -Company $company_name  -Office $office_location -Department $dept_name -Title $job_title -Enabled $true

    Read-Host "New user $user_name created! Press any key to verify..."
    
    # Verifies new user was created and prints formatted table with eight properties for all AD users to screen
    Get-ADUser -Filter * -Properties * | Format-Table Name, SamAccountName, Created, Company, Office, Department, Title, Enabled

    Read-Host "Press any key to return to menu..."
}

function Remove-AD-User{
    clear
    Get-ADUser -Filter * -Properties * | Format-Table Name, SamAccountName, Created, Company, Office, Department, Title, Enabled
    Write-Host ""
    $user_remove = Read-Host "Please enter the USERNAME of the user you would like to remove"
    Write-Host ""
    Write-Host "You have chosen to remove the $user_remove account..."
    Write-Host ""
    Read-Host "Press any key to remove and verify..."

    Remove-ADUser -Identity $user_remove -Confirm:$false

    Get-ADUser -Filter * -Properties * | Format-Table Name, SamAccountName, Created, Company, Office, Department, Title, Enabled

    Read-Host "Press any key to return to menu"
}

while($true) {
    clear

    # Prints menu and requests user selection
    Write-Host "----------------------------------------------------"
    Write-Host "Welcome to the Active Directory Configuration Wizard"
    Write-Host "----------------------------------------------------"
    Write-Host "1) Install Active Directory Domain Services"
    Write-Host "2) Rename Windows Server"
    Write-Host "3) Assign Windows Server a static IPv4 address and Domain Name Server (DNS)"
    Write-Host "4) Create an Active Directory Forest"
    Write-Host "5) Create an Active Directory Organizational Unit (OU)"
    Write-Host "6) Create an Active Directory User Account"
    Write-Host "7) Remove an Active Directory User Account"
    Write-Host "exit) Exit Active Directory Configuration Wizard"
    Write-Host "----------------------------------------------------"
    $Selection = Read-Host "Please make a selection..."

    # Conditional used to determine which function to call based on user input above
    if ($Selection -eq 1) {
    Install-AD
    } elseif ($Selection -eq 2) {
    Rename-Server
    } elseif ($Selection -eq 3) {
    Assign-IP-DNS
    } elseif ($Selection -eq 4) {
    Create-Forest
    } elseif ($Selection -eq 5) {
    Create-OU
    } elseif ($Selection -eq 6) {
    Create-NewUser
    } elseif ($Selection -eq 7) {
    Remove-AD-User
    } elseif ($Selection -eq "exit") {
    Write-Host ""
    Write-Host "You have exited the Active Directory Configuration Wizard successfully!"
    Write-Host ""
    exit
    } else {
    Write-Host "Invalid Input!"
    }
}




