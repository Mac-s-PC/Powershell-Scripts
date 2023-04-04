# Script: Automate AD User Creation
# Author: Robert Gregor
# Date of latest revision: 04 MAR 23

# My Sources:
    # [Press Any Key to Continue in PowerShell](https://java2blog.com/press-any-key-to-continue-powershell/)
    # [Get-ADUser](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-aduser?view=windowsserver2022-ps)
    # [Format-Table](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7.3)

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
    $password = Read-Host -AsSecureString "Please enter $user_full_name's secure password"
    $company_name = Read-Host "Please enter the company name"
    $office_location = Read-Host "Please enter $user_full_name's office location"
    $dept_name = Read-Host "Please enter $user_full_name's department"
    $job_title = Read-Host "Please enter $user_full_name's job title"
    Write-Host ""

    Read-Host "Press any key to create user..."

    New-ADUser -Name $full_name -SamAccountName $user_name -Accountpassword $password -Company $company_name  -Office $office_location -Department $dept_name -Title $job_title -Enabled $true

    Read-Host "New user $user_name created! Press any key to verify..."
    
    # Verifies new user was created and prints formatted table with all eight properties for all AD users to screen

    Get-ADUser -Filter * -Properties * | Format-Table Name, SamAccountName, Created, Company, Office, Department, Title, Enabled

    Read-Host "Press any key to continue..."
    exit
}