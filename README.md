# Linux Security Audit Toolkit

A modular and extensible **Linux Security Audit Toolkit** written in Bash. This toolkit helps you quickly identify potential security misconfigurations and vulnerabilities on your Linux system through automated scans.

(P.S. Yes, there are a lot of comments. Ik good code should be self documenting but just don't mind it this once :P)

---

## Features

The toolkit currently includes the following modules:

| Feature                        | Description                                                   |
|-------------------------------|---------------------------------------------------------------|
| Password Policy Audit       | System-wide password aging policy, checks time since changed  |
| User Account Audit          | Detects inactive, duplicate, or privileged users              |
| World-Writable Files Audit  | Finds files with world-writable permissions                   |
| SUID/SGID Files Audit       | Locates files with SUID or SGID set and ranks severity        |
| Open Ports Audit            | Lists open and listening ports with associated processes      |
| Running Processes Audit     | Flags suspicious or high-privilege running processes          |
| Cron Jobs Audit             | Audits cron jobs for all users and system-wide configurations |
| SSH Config Audit            | Analyzes sshd_config for insecure parameters                  |

---

## Getting Started

### Requirements

- Bash (>= 4.x)
- `awk`, `grep`, `find`, `ss`, `ps`, and standard GNU/Linux core utilities
- Root access recommended for full scan

---

### Installation

```bash
git clone https://github.com/pcubedp/security-audit-script.git
cd security-audit-script
cd scripts
chmod +x run-audit.sh
````

---

## Usage

Run the main script to start the audit:

```bash
sudo ./run-audit.sh
```

You will see a menu like:

```
Select an option:
1. Run ALL audits
2. Password Policy Audit
3. User Accounts Audit
4. World Writable Files Audit
5. SUID/SGID Files Audit
6. Open Ports & Listening Services Audit
7. Running Processes Audit
8. Cron Jobs Audit
9. SSH Configuration Audit
0. Exit
```

---

## Security Notes

* The scripts do not make any changes to your system.
* Review the output carefully to identify potential security risks.
* Disable unnecessary services (like `sshd`) on systems where remote access isn't required.

---

## Customization

Each script is modular and can be run independently. Most are adaptable for different environments (e.g., server-only systems or containers), though a few may require small tweaks depending on system configuration.





Each script is modular and can be run independently or modified for specific environments (e.g., server-only checks, container audits).

---
