# ======================================================
# Server Management Toolbox 
# ======================================================
Clear-Host
Write-Host "============================================"
Write-Host "    SERVER MANAGEMENT TOOLBOX    "
Write-Host "============================================"

function Get-InstalledFeatures { # Function to get the existing features
   $PC = Read-Host "Enter the server name or IP"
   Get-WindowsFeature -ComputerName $PC | Where-Object {$PSItem.Installed}
}

function Compare-Features { # Function to compare the existing features with new featues in the server
    $PC = Read-Host "Enter the server name or IP"
    Compare-Object -ReferenceObject (Import-Clixml .\Baseline.xml) `
    -DifferenceObject (Get-WindowsFeature -ComputerName $PC | Where-Object {$PSItem.Installed}) `
    -Property Name | Select-Object -ExpandProperty Name
}

function Uninstall-features {
    $PC = Read-Host "Enter the server name or IP"
    Uninstall-WindowsFeature -ComputerName $PC `
    -Name (Compare-Object -ReferenceObject (Import-Clixml .\Baseline.xml) `
    -DifferenceObject (Get-WindowsFeature -ComputerName $PC | Where-Object {$PSItem.Installed}) `
    -Property Name | Select-Object -ExpandProperty Name
    )
}


do{
    Write-Host "`nSelect an option:"
    Write-Host "1. Get installed features on the server"
    Write-Host "2. Compare existing features with the new features"
    Write-Host "3. Unisntalled any new features installed"
    Write-Host "0. Exit"
    $choice = Read-Host "Enter choice"


    Switch($choice){
    "1" {Get-InstalledFeatures}
    "2" {Compare-Features}
    "3" {Uninstall-features}
    "0" {Write-Host "Exiting toolbox..."}
    default {Write-Host "Invalied choice. Please try again."}
    }
    
}while($choice -ne "0")
