# === RansomSafe Automated Backup Script ===

# Set necessary environment variables
$env:RESTIC_PASSWORD = "MakeItStrongBro"
$env:AWS_ACCESS_KEY_ID = "minioadmin"
$env:AWS_SECRET_ACCESS_KEY = "minioadmin"

# Path to backup
$BackupPath = "C:\RansomSafe"

# Restic repository
$Repo = "s3:http://127.0.0.1:9000/ransomsafe-locked"

# Timestamp for logs
$Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Output "[$Time] Starting backup..."

# Perform backup
C:\RansomSafe\restic.exe -r $Repo backup $BackupPath

Write-Output "[$Time] Backup complete."
