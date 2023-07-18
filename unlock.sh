#!/usr/bin/env bash
set -eo pipefail

MASTER_DIR="gpg-master"
INPUT="$1"

openssl enc -d -aes-256-cbc -in "$INPUT" | tar xz

gpg --import "$MASTER_DIR/public.gpg"
gpg --import "$MASTER_DIR/private.gpg"

rm -rf "$MASTER_DIR"
rm -f "$MASTER_DIR.tar.gz"
