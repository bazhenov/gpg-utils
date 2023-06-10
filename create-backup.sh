#!/usr/bin/env bash
set -eo pipefail

export GNUPGHOME="$(pwd)/.gnupg"

BACKUP_DIR="gpg-backup"
mkdir "$BACKUP_DIR"

gpg --export-options backup --output "$BACKUP_DIR/public.gpg" --export
gpg --export-options backup --output "$BACKUP_DIR/private.gpg" --export-secret-keys

pass google.com/backup-codes > "$BACKUP_DIR/google-backup-codes.txt"
pass github/backup-codes > "$BACKUP_DIR/github-backup-codes.txt"

tar czf "$BACKUP_DIR.tar.gz" "$BACKUP_DIR"

echo "Full list of backup files:"
ls -la "$BACKUP_DIR"

rm -rf "$BACKUP_DIR"

openssl enc -aes-256-cbc -salt -in "$BACKUP_DIR.tar.gz" -out "${BACKUP_DIR}.enc"
rm -f "$BACKUP_DIR.tar.gz"

sha256sum "${BACKUP_DIR}.enc" > "${BACKUP_DIR}.enc.sha256"