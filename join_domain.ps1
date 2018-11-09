clear 
$ErrorActionPreference = "Stop" #Automatically exit script in the event of an unhandled exception.
Write-Host "Welcome to the AD Domain Join and Configure script. - $(Get-Date -Format T)" -ForegroundColor "Green"; Write-Host


#Gather required information for deployment
Write-Host "Please provide the following information. - $(Get-Date -Format T)" -ForegroundColor "Yellow"; Write-Host
$domainName = Read-Host -Prompt "Enter Fully Qualified Domain Name"
$domainCred = Get-Credential -Message "Enter Domain Administrative Credentials:"
Write-Host; write-Host "Required information has been collected. Attempting to join to the domain now. - $(Get-Date -Format T)" -ForegroundColor "Yellow"


#Join to domain
Add-Computer -Domainname $domainName -Credential $domainCred -WarningAction SilentlyContinue > $null
write-host


if ($(Get-WmiObject Win32_ComputerSystem).Domain -ne $domainName){
    Write-Host "-Failed to join to domain. - $(Get-Date -Format T)" -ForegroundColor Red
    Read-Host -Prompt "System reboot will not be scheduled. Press enter to exit"
}
else {
    Write-Host "-Successfully joined the domain. - $(Get-Date -Format T)" -ForegroundColor "Cyan"; Write-Host
}


#Reboot computer to finalize domain-join
$rebootNow = Read-Host -Prompt "It is necessary to restart the operating system to finalize the domain join. Would you like to restart now? (ex: Yes|No)"
while ("Yes","No" -notcontains $rebootNow){
    $rebootNow = Read-Host -Prompt "Invalid Input! Would you like to restart now? (ex: Yes|No)"
}
if ($rebootNow -eq "Yes"){
    Write-Host; Write-Host "Restarting the operating system now. - $(Get-Date -Format T)" -ForegroundColor Yellow
    sleep 2
    shutdown -t 0 -r
}
else{
    Write-Host; Write-Host "System reboot will not be scheduled. - $(Get-Date -Format T)" -ForegroundColor Yellow
    Write-Host; Read-Host -Prompt "Press enter to exit"
}
