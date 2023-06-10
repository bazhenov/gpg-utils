#!/usr/bin/env bash
set -eo pipefail

export GNUPGHOME="$(pwd)/.gnupg"
MASTER_DIR="gpg-master"

if [ -d "$GNUPGHOME" ]; then
  echo "Directory already exists: ${GNUPGHOME}"
  exit 1
fi

openssl enc -d -aes-256-cbc -in "$MASTER_DIR.enc" -out "$MASTER_DIR.tar.gz"
tar xzf "$MASTER_DIR.tar.gz"

gpg --import "$MASTER_DIR/public.gpg"
gpg --import "$MASTER_DIR/private.gpg"

rm -rf "$MASTER_DIR"
rm -f "$MASTER_DIR.tar.gz"