# RansomSafe  
A Real-Time Immutable Backup & Ransomware Recovery System  
*By Pavitra Dwivedi*

---

## 🚀 Overview  

RansomSafe is a **ransomware-resilient backup and recovery system** designed to protect critical data even if the entire host machine is compromised.

It uses:

- **Restic** for encrypted, deduplicated snapshots  
- **MinIO** as an S3-compatible immutable storage backend  
- **PowerShell automation** for real-time backup triggers  
- **Immutable object locking** to prevent attacker-led deletion or modification  

Even if ransomware encrypts all local files, **your snapshots remain untouched and fully recoverable**.

---

## 🎯 Problem Statement  

Modern ransomware does not only encrypt data — it also **targets and corrupts backup files** to prevent recovery.

Organizations need a backup system that is:

- Immutable  
- Encrypted  
- Versioned  
- Automated  
- Safe even if the system is destroyed  

RansomSafe solves this by combining S3 object-locking with encrypted snapshots.

---

## 🧠 Background & Technologies Used  

### **🔒 Restic (Backup Engine)**  
- End-to-end encrypted backups (AES-256-CTR + Poly1305)  
- Deduplication (saves space)  
- Incremental snapshots  
- Cross-platform  

### **🗄️ MinIO (Object Storage)**  
- S3-compatible storage  
- Versioning support  
- Governance mode object lock  
- Local + cloud-ready  

### **⚡ PowerShell (Automation)**  
- Real-time folder watcher  
- Automated scheduled/incremental backups  
- Ransomware simulation for testing  

### **🛡️ Immutable Storage**  
- Prevents deletion or modification of backups  
- Works even if attacker gains root access  
- 30-day governance lock enabled  

---

## 🏛️ Architecture Diagram  


![WhatsApp Image 2025-11-24 at 02 08 46_02ffee27](https://github.com/user-attachments/assets/701afb52-de55-44fc-ba92-53611ab39646)


---

## 🔁 Data Flow (How RansomSafe Works)

1. A folder is selected for protection (`demo-data`).  
2. **watcher.ps1** monitors it for create/modify/delete events.  
3. When an event occurs, **backup.ps1** triggers Restic.  
4. Restic encrypts data and creates a new snapshot.  
5. Snapshot uploaded to **MinIO immutable bucket** (`governance + versioning`).  
6. Ransomware attack occurs → local files get encrypted.  
7. Snapshots remain untouched in MinIO.  
8. Recovery uses Restic restore commands from the offline playbook.

---

## 🛠️ Tech Stack

| Component     | Purpose |
|---------------|---------|
| Restic        | Encrypted backup snapshots |
| MinIO         | S3 storage with object lock |
| PowerShell    | Automation + watcher |
| AES-256-CTR   | Encryption mode |
| Poly1305      | Authentication MAC |
| S3 Versioning | Keeps previous states |
| Governance Mode | Prevents deletion |

---

## ⚙️ Setup Instructions  

### 🔸 **Start MinIO Server**
```powershell
.\minio.exe server .\minio-data --console-address ":9001"

## ⚙️ Full Setup & Demo Steps (Step-by-Step Commands)

This section explains how to install, set up, run, attack, and recover using RansomSafe.

---

# 1️⃣ Install Required Tools (Restic, MinIO, mc)

Download binaries and place them inside your project folder (`C:\RansomSafe`):

- **restic.exe**
- **minio.exe**
- **mc.exe**

(No binaries are included in this repo.)

---

# 2️⃣ Start MinIO Server (Object Storage)

```powershell
cd C:\RansomSafe
.\minio.exe server .\minio-data --console-address ":9001"
3️⃣ Set Environment Variables (Masked)
$env:AWS_ACCESS_KEY_ID="******"
$env:AWS_SECRET_ACCESS_KEY="******"
$env:RESTIC_PASSWORD="******"


Real credentials are stored offline.

4️⃣ Initialize Restic Repository
.\restic.exe -r s3:http://127.0.0.1:9000/ransomsafe-locked init

5️⃣ Enable Versioning + Governance Lock
.\mc.exe alias set myminio http://127.0.0.1:9000 <Access Key><Secret Key>
.\mc.exe version enable myminio/ransomsafe-locked
.\mc.exe retention set governance 30d myminio/ransomsafe-locked --default

Your bucket is now:

immutable

versioned

undeletable even by root

6️⃣ Start Real-Time Backup Watcher
cd C:\RansomSafe
.\watcher.ps1

This script triggers Restic on every change.

7️⃣ Optional: Run Manual Backup
.\backup.ps1


8️⃣ Stop Watcher & MinIO Before Simulating Ransomware

To avoid backing up encrypted garbage:

Press Ctrl + C on watcher

Close the MinIO server window

9️⃣ Run Fake Ransomware Simulation (Safe)
.\fake_ransomware.ps1


Your folder will now show encrypted files (e.g., .encrypted).

🔟 Verify Damage

Check the demo-data folder — everything is intentionally encrypted.

1️⃣1️⃣ Restore Clean Data From Immutable Snapshots

Start MinIO again:

cd C:\RansomSafe
.\minio.exe server .\minio-data --console-address ":9001"

Re-set offline credentials:

$env:RESTIC_PASSWORD="******"
$env:AWS_ACCESS_KEY_ID="******"
$env:AWS_SECRET_ACCESS_KEY="******"



.\restic.exe -r s3:http://127.0.0.1:9000/ransomsafe-locked snapshots

Restore the clean version:

.\restic.exe -r s3:http://127.0.0.1:9000/ransomsafe-locked restore latest --target C:\RecoveredData

Your clean files are now restored.

1️⃣2️⃣ Optional: Reset RecoveredData Folder
Remove-Item -Recurse -Force C:\RecoveredData
mkdir C:\RecoveredData




🆘 Recovery Playbook

The redacted playbook (recovery_playbook_redacted.md) explains:

how to restart MinIO

how to run Restic

how to restore data

what to do during a real attack

No secrets included.

✅ Conclusion

RansomSafe successfully demonstrates a full enterprise-grade ransomware defense pipeline, including:

immutable backups

encrypted snapshotting

versioning

full recovery after encryption

Even if ransomware destroys your entire system, recovery is possible instantly.

📚 References

Restic Documentation

MinIO Documentation

AWS S3 Object Lock

MITRE ATT&CK T1486 (Ransomware)

NIST Storage Security Guidelines

