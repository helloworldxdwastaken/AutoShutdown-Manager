# AutoShutdown Complete - All-in-One Windows App
# Contains installer, remover, and menu interface in one file

# Function to show menu
function Show-Menu {
    Write-Host "`n🌙 AutoShutdown Manager for Windows" -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host "1. Install AutoShutdown" -ForegroundColor Green
    Write-Host "2. Remove AutoShutdown" -ForegroundColor Red
    Write-Host "3. Check Status" -ForegroundColor Yellow
    Write-Host "4. Exit" -ForegroundColor Gray
    Write-Host ""
}

# Function to install AutoShutdown
function Install-AutoShutdown {
    try {
        Write-Host "Installing AutoShutdown..." -ForegroundColor Yellow
        
        # Create Scripts directory
        $scriptsDir = "C:\Scripts"
        if (!(Test-Path $scriptsDir)) {
            New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
        }
        
        # Create the PowerShell script
        $psScript = @'
# C:\Scripts\AutoShutdown.ps1
# Shows a popup at 23:00; if ignored for 60s OR you click OK -> shutdown.
# Click 'Cancel' to abort for tonight.

$timeout = 60
$msg     = "It's 23:00. Your PC will shut down in $timeout seconds unless you cancel."
$title   = "Auto Shutdown"

# 0x30 = Info icon, 0x1 = OK/Cancel
$wshell  = New-Object -ComObject WScript.Shell
$result  = $wshell.Popup($msg, $timeout, $title, 0x30 + 0x1)

# Popup return values: -1 timeout, 1 OK, 2 Cancel
if ($result -eq -1 -or $result -eq 1) {
  Start-Process -FilePath "shutdown.exe" -ArgumentList "/s /f /t 0" -WindowStyle Hidden
  exit
}
# If Cancel (2), do nothing.
'@
        
        Set-Content -Path "$scriptsDir\AutoShutdown.ps1" -Value $psScript -Encoding UTF8
        
        # Create/replace scheduled task
        $taskName = "AutoShutdown"
        $psPath = "$scriptsDir\AutoShutdown.ps1"
        
        # Delete existing task if it exists
        $existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
        if ($existingTask) {
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        }
        
        # Create new task
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$psPath`""
        $trigger = New-ScheduledTaskTrigger -Daily -At "22:00"
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -WakeToRun
        $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal | Out-Null
        
        Write-Host "✅ AutoShutdown installed successfully!" -ForegroundColor Green
        Write-Host "Your PC will now show a shutdown prompt every day at 10:00 PM." -ForegroundColor Green
        
    } catch {
        Write-Host "❌ Installation failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Function to remove AutoShutdown
function Remove-AutoShutdown {
    try {
        Write-Host "Removing AutoShutdown..." -ForegroundColor Yellow
        
        $taskName = "AutoShutdown"
        $psPath = "C:\Scripts\AutoShutdown.ps1"
        
        # Remove scheduled task
        $existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
        if ($existingTask) {
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        }
        
        # Remove script file
        if (Test-Path $psPath) {
            Remove-Item $psPath -Force
        }
        
        Write-Host "🧹 AutoShutdown removed successfully!" -ForegroundColor Green
        Write-Host "Your PC will no longer automatically shut down." -ForegroundColor Green
        
    } catch {
        Write-Host "❌ Removal failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Function to check status
function Check-Status {
    try {
        $taskName = "AutoShutdown"
        $existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
        
        if ($existingTask) {
            Write-Host "✅ AutoShutdown is ACTIVE" -ForegroundColor Green
            Write-Host "Will show shutdown prompt at 10:00 PM daily." -ForegroundColor Green
            Write-Host "Force shutdown enabled - will close all apps without saving." -ForegroundColor Yellow
        } else {
            Write-Host "❌ AutoShutdown is NOT installed" -ForegroundColor Red
            Write-Host "Run option 1 to install it." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ AutoShutdown is NOT installed" -ForegroundColor Red
    }
}

# Main menu loop
do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-4)"
    
    switch ($choice) {
        "1" { Install-AutoShutdown }
        "2" { Remove-AutoShutdown }
        "3" { Check-Status }
        "4" { 
            Write-Host "Goodbye! 👋" -ForegroundColor Cyan
            break 
        }
        default { 
            Write-Host "Invalid choice. Please enter 1-4." -ForegroundColor Red 
        }
    }
    
    if ($choice -ne "4") {
        Write-Host "`nPress any key to continue..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    
} while ($choice -ne "4")
