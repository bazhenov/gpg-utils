#!/usr/bin/env bash
set -eo pipefail

export GNUPGHOME="$(pwd)/.gnupg"

if [ -d "$GNUPGHOME" ]; then
  echo "Directory already exists: ${GNUPGHOME}"
  exit 1
fi

gpg --expert --full-generate-key
