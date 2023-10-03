# REQUIRES -Modules MSOnline -RunAsAdministrator

# Check if the MSOnline module is installed. If not, run Install-Module MSOnline.
# You may need to run this script as an administrator.

# Display a title banner.
Write-Host("           __   __   __        ___  __  ") -ForegroundColor Yellow
Write-Host("|  | |\ | |__) /  \ |__) |__/ |__  |__) ") -ForegroundColor Cyan
Write-Host("\__/ | \| |__) \__/ |  \ |  \ |___ |  \ ") -ForegroundColor Magenta
Write-Host("                                        ")
Write-Host("Welcome to the 365 deleted account unborker.")
Write-Host("                                        ")
Write-Host("Please ensure that you have restored the account on 365 before continuing.")
Write-Host("                                        ")

# Wait for user input to start the process.
Read-Host("Press return to begin")

# Connect to Office 365.
Connect-MsolService

# Get the user's email address from Office 365.
$365_UPN = Read-Host("Enter the User's email address from 365")
Write-Host("Searching for: " + $365_UPN) -ForegroundColor Cyan

# Find the user in Office 365.
$365_user = Get-MsolUser -UserPrincipalName $365_UPN
Write-Host("Found: " + $365_user.DisplayName) -ForegroundColor Cyan
Write-Host("Found: " + $365_user.ImmutableId) -ForegroundColor Cyan

Write-Host("")
Write-Host("Checking for linked AD Accounts...")

# Convert the Immutable ID (365) to GUID (AD).
$GUID = [Guid]([Convert]::FromBase64String($365_user.ImmutableId))
Write-Host($GUID)

try {
    # Check whether we find a linked AD account.
    $AD_linked = Get-ADUser -Identity $GUID
    Write-Host("Found Linked Account: " + $AD_linked.Name) -ForegroundColor Yellow
    Write-Host("GUID: "+$GUID) -ForegroundColor Magenta

    Read-Host("Press CTRL+C to exit.")
}
catch {
    Write-Host("No linked accounts found. Continuing.")
}

Write-Host("")

# Get the AD Username from the user.
$AD_username = Read-Host("Enter the User's AD Username")
Write-Host("Searching for: " + $AD_username)
Write-Host("")

# Find the AD User.
$AD_user = Get-ADUser -Identity $AD_username -Properties *

Write-Host("Found: " + $AD_user.Name) -ForegroundColor Magenta
Write-Host("GUID: " + $AD_user.ObjectGUID) -ForegroundColor Magenta

Write-Host("")

# Convert the GUID (AD) to Immutable ID (365).
$ImmutableID = [system.convert]::ToBase64String(([GUID]($AD_User.ObjectGUID)).tobytearray())
Write-Host("Calculated Immutable ID: " + $ImmutableID) -ForegroundColor Magenta

# Check if the user is already matched to 365.
if($ImmutableID -eq $365_user.ImmutableId) {
    Write-Host("User is already matched.") -ForegroundColor Yellow
    Write-Host("Immutable ID:" + $365_user.ImmutableId) -ForegroundColor Cyan
    Write-Host("AD ID:" + $ImmutableID) -ForegroundColor Cyan
    Read-Host("Press CTRL+C to exit.")
    Write-Host("")
}

# Display differences between AD and Office 365 for the user.
Write-Host("                                        ")
Write-Host("|           Check Differences!           |") -ForegroundColor Yellow
Write-Host("|           Correct If Required          |") -ForegroundColor Yellow
Write-Host("                                        ")

Write-Host("AD Name: " + $AD_user.Name) -ForegroundColor Magenta
Write-Host("365 Name: " + $365_user.DisplayName) -ForegroundColor Cyan

Write-Host("                                        ")

Write-Host("AD UPN: " + $AD_user.UserPrincipalName) -ForegroundColor Magenta
Write-Host("365 UPN: " + $365_user.UserPrincipalName) -ForegroundColor Cyan

Write-Host("                                        ")

Write-Host("AD Email: " + $AD_user.Mail) -ForegroundColor Magenta

Write-Host("                                        ")

Write-Host("AD Proxy Addresses: " + $AD_user.ProxyAddresses) -ForegroundColor Magenta
Write-Host("365 Proxy Addresses: " + $AD_user.ProxyAddresses) -ForegroundColor Cyan

Write-Host("                                        ")

Write-Host("Resultant GUID will come from AD: " + $AD_user.ObjectGUID) -ForegroundColor Magenta
Write-Host("Calculated Immutable ID " + $ImmutableID) -ForegroundColor Magenta
Write-Host("This will replace: " + $365_user.ImmutableID) -ForegroundColor Cyan

Write-Host("                                        ")

# Ask for confirmation to continue.
Read-Host("Press Return to Continue. CTRL + C to cancel.")

# Provide a final chance for confirmation.
Read-Host("Final Chance. Return to Continue. CTRL + C to cancel.")

try {
    # Update the immutable ID in Office 365.
    Set-MsolUser -UserPrincipalName $365_user.UserPrincipalName -ImmutableID $ImmutableID
}
catch {
    # Log errors if the update fails.
    Write-Host("An error occurred when setting the immutable ID") -ForegroundColor Red
    Write-Host("Check that the immutable ID does not already exist on 365") -ForegroundColor Red
    Write-Warning($Error[0])
}
