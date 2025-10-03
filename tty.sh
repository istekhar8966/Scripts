#!/bin/sh
# Restore factory /etc/ttys and /etc/gettytab from base.txz (FreeBSD)
# Usage (single-user): REL=14.3-RELEASE ARCH=amd64 sh restore-ttys-gettytab.sh

set -eu

REL="${REL:-14.3-RELEASE}"
ARCH="${ARCH:-amd64}"
MIRROR="${MIRROR:-https://download.freebsd.org/releases}"

TMP="${TMPDIR:-/tmp}/fbsd-restore.$$"
BASE="$TMP/base.txz"

echo "[*] Release=$REL Arch=$ARCH Mirror=$MIRROR"
mkdir -p "$TMP"

# 1) Fetch base.txz
URL="$MIRROR/$ARCH/$REL/base.txz"
echo "[*] Fetching: $URL"
fetch -o "$BASE" "$URL"

# 2) Extract only /etc/ttys and /etc/gettytab
echo "[*] Extracting factory files..."
tar -C "$TMP" -Jxvf "$BASE" ./etc/ttys ./etc/gettytab

# 3) Backups
[ -f /etc/ttys ]     && cp -p /etc/ttys     /etc/ttys.bak.$(date +%s)
[ -f /etc/gettytab ] && cp -p /etc/gettytab /etc/gettytab.bak.$(date +%s)

# 4) Replace with factory copies
echo "[*] Installing /etc/ttys and /etc/gettytab ..."
cp "$TMP/etc/ttys"     /etc/ttys
cp "$TMP/etc/gettytab" /etc/gettytab

# 5) Remove stale capability DB (optional)
[ -f /etc/gettytab.db ] && rm -f /etc/gettytab.db

# 6) Minimize VTs: keep only ttyv0 on, others off (to stop spam)
echo "[*] Setting ttyv1..ttyv8 to off for now ..."
awk '
  /^ttyv[1-8][[:space:]]/ {
      # replace status/tokens to off while preserving columns loosely
      $3=$3; # noop to keep spacing reasonable
      print $1, $2, $3, "off", "secure";
      next
  }
  { print }
' /etc/ttys > /etc/ttys.new && mv /etc/ttys.new /etc/ttys

# 7) Show result heads
echo "[*] --- /etc/ttys (head) ---"
sed -n '1,80p' /etc/ttys
echo "[*] --- /etc/gettytab ---"
sed -n '1,40p' /etc/gettytab

echo "[*] Done."
echo "[*] Now reboot (recommended) or reload getty: pkill -HUP getty"
echo "[*] After stable login on ttyv0, edit /etc/ttys to turn ttyv1..ttyv8 back on:"
echo "    ttyvN   "/usr/libexec/getty Pc"   xterm   on  ifexists secure"