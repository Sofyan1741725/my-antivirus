# Simple Antivirus Daemon & Restore Tool

An operating systems lab project implementing a lightweight directory-monitoring antivirus daemon, an interactive quarantine restore utility, a Makefile for workflow automation, a Whitelist persistence mechanism, and a Cron automation bonus.

---

## 1. Project Overview & Folder Hierarchy

```text
.
├── antivirusd.sh        # Main monitoring daemon script (with polling & whitelist check)
├── antivirus-cron.sh    # Scheduled cron scan script (Bonus 1)
├── restore.sh           # Interactive quarantine review and restore tool
├── Makefile             # Automation tool for pre-build, daemon, and restore
├── README.md            # Project documentation
├── whitelist.txt        # Persisted safe files (Bonus 2)
└── malicious_dir/       # Quarantine folder for flagged files
