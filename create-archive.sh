#!/usr/bin/env bash

set -eo pipefail

function copy_gpg_key() {
  expected_format="OpenPGP (Public|Secret) Key Version 4"
  status=0
  file $1 | grep -E "${expected_format}" || status=$?
  if [ $status != 0 ]; then
    echo "File $1 is of invalid format. Expected: ${expected_format}"
    exit 1
  fi
  cp "$1" "$WORKDIR"
}

GPG_KEYS_DIRECTORY="/Volumes/Files/.gpg-keys"
ARCHIVE="recovery.tar.gz"

WORKDIR="recovery"

if [ -d "$WORKDIR" ]; then
  echo "Cleaning up working directory"
  rm -rf "$WORKDIR"
fi

mkdir $WORKDIR
copy_gpg_key $GPG_KEYS_DIRECTORY/bazhenov.public.gpg
copy_gpg_key $GPG_KEYS_DIRECTORY/bazhenov.secret.gpg
copy_gpg_key $GPG_KEYS_DIRECTORY/bazhenov.secsub.gpg

pass google.com/backup-codes > $WORKDIR/google-backup-codes.txt
pass github/backup-codes > $WORKDIR/github-backup-codes.txt

tar czvf "$ARCHIVE" "$WORKDIR"
rm -rf "$WORKDIR"

openssl enc -aes-256-cbc -salt -in "$ARCHIVE" -out "${ARCHIVE%.tar.gz}.enc"

rm -f $ARCHIVE