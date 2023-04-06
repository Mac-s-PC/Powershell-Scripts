# Script: Automate Active Directory Configuration
# Author: Mac's PC
# Date of latest revision: 04 MAR 23

# Mac's PC Sources:
    # [Press Any Key to Continue in PowerShell](https://java2blog.com/press-any-key-to-continue-powershell/)
    # [Get-ADUser](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-aduser?view=windowsserver2022-ps)
    # [Format-Table](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7.3)
    # [Remove-ADUser](https://learn.microsoft.com/en-us/powershell/module/activedirectory/remove-aduser?view=windowsserver2022-ps)
    # [about_While] (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_while?view=powershell-7.3)
    # [Install-ADDSForest](https://learn.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=windowsserver2022-ps)
    # [Get-ADForest](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-adforest?view=windowsserver2022-ps)
    # [Get-ADOrganizationalUnit](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-adorganizationalunit?view=windowsserver2022-ps)
    # [New-ADOrganizationalUnit](https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-adorganizationalunit?view=windowsserver2022-ps)
    # [Out-Null](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/out-null?view=powershell-7.3)
    # [Out-Host](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/out-host?view=powershell-7.3)

Import-Module ActiveDirectory

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
    Read-Host "Press enter to apply changes and restart computer..."

    # Restart the computer
    Restart-Computer

    # Wait for the server to restart
    Start-Sleep -Seconds 60

    Read-Host "Press enter to return to menu..."
}

function Assign-IP-DNS{
    
    # Get interface object
    $interface = Get-NetAdapter -Name Ethernet

    # Set IPv4 configuration
    $ipAddress = Read-Host "Enter IPv4 address"
    $subnetMask = Read-Host "Enter subnet address"
    $gateway = Read-Host "Enter Default Gateway"

    New-NetIPAddress -InterfaceIndex $interface.ifIndex -IPAddress $ipAddress -PrefixLength 24 -DefaultGateway $gateway | Out-Null

    # Set DNS configuration
    $dns = Read-Host "Enter DNS Server Address"

    Set-DnsClientServerAddress -InterfaceIndex $interface.ifIndex -ServerAddresses $dns

    # Verify Changes and return to manu
    Write-Host ""
    Read-Host "Press enter to Verify Changes..."
    Write-Host ""

    ipconfig /all

    Read-Host "Press enter to return to menu..."
}

function Install-AD{
    clear
    Write-Host ""
    Read-Host "Press enter to install the Active Directory Domain Services (AD DS) role along with its management tools and verify"
    Write-Host ""

    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

    Get-WindowsFeature -Name AD-Domain-Services, RSAT-ADDS

    Read-Host "Press enter to return to menu..."
}

function Create-Forest{
    clear
    Write-Host ""
    $forest_domain = Read-Host "Enter the domain name for the new Forest (ex. example.local)"
    Write-Host ""
    Write-Host "Passwords must be no less than seven characters and must include at least three of the following four character classes:"
    Write-Host "Uppercase letters (A-Z), Lowercase letters (a-z), Digits (0-9), Special characters (e.g., !@#$%^&*)"
    Write-Host ""
    $forest_password = Read-Host -AsSecureString "Please enter $forest_domain domain's secure password"
    Write-Host ""
    Read-Host "Press enter to create forest, sign out, and restart computer"
    Write-Host ""

    Install-ADDSForest -DomainName $forest_domain -SafeModeAdministratorPassword $forest_password -Force

    Read-Host "Press enter to return to menu"
}

function Create-OU{
    clear
    Write-Host ""
    $ou_name = Read-Host "Enter the name of the new Organizational Unit"
    $global:$ou_path = Read-Host "Enter the Distinguished Name (DN) of parent container where $ou_name OU will be created (ex DC=example)"
    Write-Host ""
    Read-Host "Press enter to create the $ou_name OU in $ou_path and verify"
    New-ADOrganizationalUnit -Name $ou_name -Path $ou_path
    Write-Host ""
    Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName | Out-Host
    Write-Host ""

    Read-Host "Press enter to return to menu"
}

function Create-NewUser{
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
    Write-Host ""
    $company_name = Read-Host "Please enter the company name"
    Write-Host ""
    $office_location = Read-Host "Please enter $full_name's office location"
    Write-Host ""
    $dept_name = Read-Host "Please enter $full_name's department"
    Write-Host ""
    $job_title = Read-Host "Please enter $full_name's job title"
    Write-Host ""

    Read-Host "Press enter to create user..."
    Write-Host ""

    # Executes New-ADUser PowerShell command to create new user and assigns values to eight properties
    New-ADUser -Name $full_name -SamAccountName $user_name -Accountpassword $password -Company $company_name  -Office $office_location -Department $dept_name -Title $job_title -Enabled $true

    Read-Host "New user $user_name created! Press enter to verify..."

    # Verifies new user was created and prints formatted table with eight properties for all AD users to screen
    Get-ADUser -Filter * -Properties * | Format-Table Name, SamAccountName, Created, Company, Office, Department, Title, Enabled
    Write-Host ""

    $ou_selection = Read-Host "Enter the Distinguished Name (DN) of the OU you wish to assign the user to (ex. OU=exampleOU,DC=example,DC=local)"
    $user_DN = (Get-ADUser -Identity $user_name).DistinguishedName
    Move-ADObject -Identity $user_DN -TargetPath $ou_selection
    Write-Host ""

    Read-Host "New user $user_name assigned to $ou_selection! Press enter to verify..."
    
    Get-ADUser -Filter * -SearchBase "OU=$ou_selection,$ou_path"

    Read-Host "Press enter to return to menu..."
}

function Remove-User{
    clear
    Get-ADUser -Filter * -Properties * | Format-Table Name, SamAccountName, Created, Company, Office, Department, Title, Enabled
    Write-Host ""
    $user_remove = Read-Host "Please enter the SamAccountName of the user you would like to remove"
    Write-Host ""
    Write-Host "You have chosen to remove the $user_remove account..."
    Write-Host ""
    Read-Host "Press enter to remove and verify..."

    Remove-ADUser -Identity $user_remove -Confirm:$false

    Get-ADUser -Filter * -Properties * | Format-Table Name, SamAccountName, Created, Company, Office, Department, Title, Enabled

    Read-Host "Press enter to return to menu"
}

while($true) {
    clear

    # Prints menu and requests user selection
    Write-Host "----------------------------------------------------"
    Write-Host "Welcome to the Active Directory Configuration Wizard"
    Write-Host "----------------------------------------------------"
    Write-Host "1) Rename Windows Server"
    Write-Host "2) Assign Windows Server a static IPv4 address and Domain Name Server (DNS)"
    Write-Host "3) Install Active Directory Domain Services"
    Write-Host "4) Create an Active Directory Forest"
    Write-Host "5) Create an Active Directory Organizational Unit (OU)"
    Write-Host "6) Create an Active Directory User Account"
    Write-Host "7) Remove an Active Directory User Account"
    Write-Host "exit) Exit Active Directory Configuration Wizard"
    Write-Host "----------------------------------------------------"
    $Selection = Read-Host "Please make a selection..."

    # Conditional used to determine which function to call based on user input above
    if ($Selection -eq 1) {
    Rename-Server
    } elseif ($Selection -eq 2) {
    Assign-IP-DNS
    } elseif ($Selection -eq 3) {
    Install-AD
    } elseif ($Selection -eq 4) {
    Create-Forest
    } elseif ($Selection -eq 5) {
    Create-OU
    } elseif ($Selection -eq 6) {
    Create-NewUser
    } elseif ($Selection -eq 7) {
    Remove-User
    } elseif ($Selection -eq "exit") {
    Write-Host ""
    Write-Host "You have exited the Active Directory Configuration Wizard successfully!"
    Write-Host ""
    exit
    } else {
    Write-Host "Invalid Input!"
    }
}




