#!/usr/bin/env bash
set -eo pipefail

export GNUPGHOME="$(pwd)/.gnupg"
MASTER_DIR="gpg-master"

if [ ! -d "$GNUPGHOME" ]; then
  echo "Directory not exists: ${GNUPGHOME}"
  exit 1
fi

mkdir "$MASTER_DIR"

gpg --export-options backup --output "$MASTER_DIR/public.gpg" --export
gpg --export-options backup --output "$MASTER_DIR/private.gpg" --export-secret-keys

tar czf "$MASTER_DIR.tar.gz" "$MASTER_DIR"
rm -rf "$MASTER_DIR"

if [ -f "$MASTER_DIR.enc" ]; then
  mv "$MASTER_DIR.enc" "$MASTER_DIR.enc.bak"
fi

openssl enc -aes-256-cbc -in "$MASTER_DIR.tar.gz" -out "$MASTER_DIR.enc"
rm -f "$MASTER_DIR.tar.gz"
rm -rf "$GNUPGHOME"

echo "GnuPG home was sucessfully locked."
echo "Enter: unlock.sh to unlock directory"