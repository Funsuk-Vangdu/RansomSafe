# ====================================
# SAFE RANSOMWARE SIMULATOR (Pavi)
# ====================================
# WARNING: This ONLY affects demo-data folder.
# It is NOT malware. It will NOT spread.

$TargetFolder = "C:\RansomSafe\demo-data"
$RansomNote = @"
Your files have been encrypted.

Don't panic. This is a simulation.
Restore your files from RansomSafe.
"@

# Encrypt-like function (safe)
function Fake-Encrypt($path) {
    $content = Get-Content $path -Raw
    $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($content))
    Set-Content -Path $path -Value $encoded
}

Write-Host "Simulating ransomware attack on $TargetFolder ..."

# Encrypt all files
Get-ChildItem $TargetFolder -Recurse -File | ForEach-Object {
    Fake-Encrypt $_.FullName
    
    $newName = $_.FullName + ".encrypted"
    Rename-Item $_.FullName $newName
}

# Drop ransom note
$ransomPath = Join-Path $TargetFolder "README_RECOVER_FILES.txt"
Set-Content $ransomPath $RansomNote

Write-Host "Simulation complete. Files encrypted (Base64)."
