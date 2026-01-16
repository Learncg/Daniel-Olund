# ==========================================================
# Script name: security_audit.ps1
# Description: Security audit for Windows systems
# Author: Automationsingenjör IT-säkerhet
# ==========================================================

$LogFile = "C:\Logs\SecurityAudit.log"
$Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

function Write-Log {
    param ([string]$Message)
    "$Date - $Message" | Out-File -Append -FilePath $LogFile
}

function Check-AdminAccounts {
    Write-Log "Checking local administrators..."
    Get-LocalGroupMember -Group "Administrators" |
        Select-Object Name |
        ForEach-Object { Write-Log "Admin account: $($_.Name)" }
}

function Check-FailedLogons {
    Write-Log "Checking failed logon attempts..."
    Get-WinEvent -FilterHashtable @{
        LogName='Security'
        Id=4625
    } -MaxEvents 5 | ForEach-Object {
        Write-Log "Failed logon detected at $($_.TimeCreated)"
    }
}

function Check-FirewallStatus {
    Write-Log "Checking firewall status..."
    Get-NetFirewallProfile | ForEach-Object {
        Write-Log "$($_.Name) Firewall Enabled: $($_.Enabled)"
    }
}

function Main {
    Write-Log "Security audit started"
    Check-AdminAccounts
    Check-FailedLogons
    Check-FirewallStatus
    Write-Log "Security audit completed"
}

Main
