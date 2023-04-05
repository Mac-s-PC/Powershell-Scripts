# Script: Script Menu
# Author: Robert Gregor
# Date of latest revision: 04 MAR 23

# My Sources:
    # [about_While] (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_while?view=powershell-7.3)

while($true) {
    clear
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
    Create-NewUser
    } elseif ($Selection -eq 2) {
    Create-NewUser
    } elseif ($Selection -eq 3) {
    Create-NewUser
    } elseif ($Selection -eq 4) {
        Create-NewUser
    } elseif ($Selection -eq 5) {
    Create-NewUser
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