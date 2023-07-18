#!/usr/bin/env bash
set -eo pipefail

if [ ! -d "$1" ]; then
  echo "create-backup.sh PATH_TO_PASS_DB"
  exit 1
fi

BACKUP_DIR="gpg-backup"

export PASSWORD_STORE_DIR="$1"
export GNUPGHOME="$(pwd)/.gnupg"

mkdir "$BACKUP_DIR"

gpg --export-options backup --output "$BACKUP_DIR/public.gpg" --export
gpg --export-options backup --output "$BACKUP_DIR/private.gpg" --export-secret-keys

unset GNUPGHOME
pass google.com/backup-codes > "$BACKUP_DIR/google-backup-codes.txt"
pass github/backup-codes > "$BACKUP_DIR/github-backup-codes.txt"

echo "Full list of backup files:"
ls -la "$BACKUP_DIR"

tar cz "$BACKUP_DIR" | openssl enc -aes-256-cbc -salt -out "${BACKUP_DIR}.enc"
rm -rf "$BACKUP_DIR"

sha256sum "${BACKUP_DIR}.enc" > "${BACKUP_DIR}.enc.sha256"
