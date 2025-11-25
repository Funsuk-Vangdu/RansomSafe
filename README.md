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

