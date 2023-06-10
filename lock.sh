#!/usr/bin/env bash
set -eo pipefail

export GNUPGHOME="$(pwd)/.gnupg"
MASTER_DIR="gpg-master"
OUT="$1"

if [ ! -d "$GNUPGHOME" ]; then
  echo "Directory not exists: ${GNUPGHOME}"
  exit 1
fi

mkdir "$MASTER_DIR"

gpg --export-options backup --output "$MASTER_DIR/public.gpg" --export
gpg --export-options backup --output "$MASTER_DIR/private.gpg" --export-secret-keys

if [ -f "$OUT" ]; then
  mv "$OUT" "$OUT.bak"
fi

tar cz "$MASTER_DIR" | openssl enc -aes-256-cbc -out "$OUT"
rm -rf "$MASTER_DIR"
rm -rf "$GNUPGHOME"

echo "GnuPG home was sucessfully locked."
echo "Enter: unlock.sh to unlock directory"