# ============================
# RansomSafe Real-Time Watcher
# ============================

# --- CONFIGURATION ---
$WatchPath = "C:\RansomSafe\demo-data"   # Folder to monitor
$BackupRepo = "s3:http://127.0.0.1:9000/ransomsafe-locked"
$LogFile = "C:\RansomSafe\backup-log.txt"

# Environment variables – required for Restic
$env:RESTIC_PASSWORD = "stored offline"
$env:AWS_ACCESS_KEY_ID = "stored offline"
$env:AWS_SECRET_ACCESS_KEY = "stored offline"

# Debounce timer (prevents multiple backups per second)
$CooldownSeconds = 20
$LastBackupTime = (Get-Date).AddSeconds(-$CooldownSeconds)

# FileSystemWatcher setup
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $WatchPath
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

Write-Output "$(Get-Date) - Watcher started on $WatchPath" | Out-File -Append $LogFile

# Backup function
function Trigger-Backup {
    $now = Get-Date
    if (($now - $LastBackupTime).TotalSeconds -lt $CooldownSeconds) {
        return
    }

    $global:LastBackupTime = $now

    $logEntry = "$(Get-Date) - Change detected. Running backup..."
    Write-Output $logEntry | Out-File -Append $LogFile
    Write-Output $logEntry

    & "C:\RansomSafe\restic.exe" -r $BackupRepo backup $WatchPath | Out-File -Append $LogFile

    Write-Output "$(Get-Date) - Backup completed." | Out-File -Append $LogFile
}

# Events
$onChange = Register-ObjectEvent $watcher Changed -Action { Trigger-Backup }
$onCreate = Register-ObjectEvent $watcher Created -Action { Trigger-Backup }
$onDelete = Register-ObjectEvent $watcher Deleted -Action { Trigger-Backup }
$onRename = Register-ObjectEvent $watcher Renamed -Action { Trigger-Backup }

Write-Host "Real-time backup watcher is now running."
Write-Host "Do NOT close this window if you want continuous backups."
Write-Host "Press Ctrl + C to stop."
while ($true) { Start-Sleep 1 }

