#!/usr/bin/env bash
set -eo pipefail

MASTER_DIR="gpg-master"
OUT="$1"

mkdir "$MASTER_DIR"

gpg --export-options backup --output "$MASTER_DIR/public.gpg" --export
gpg --export-options backup --output "$MASTER_DIR/private.gpg" --export-secret-keys

if [ -f "$OUT" ]; then
  mv "$OUT" "$OUT.bak"
fi

tar cz "$MASTER_DIR" | openssl enc -aes-256-cbc -out "$OUT"
rm -rf "$MASTER_DIR"

GPGDIR="$(gpgconf -L homedir)"
read -p "Delete $GPGDIR?: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	rm -rf "$GPGDIR"
fi

echo "GnuPG home was sucessfully locked."
echo "Enter: unlock.sh to unlock directory"
