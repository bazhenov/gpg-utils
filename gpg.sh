#!/usr/bin/env bash
set -eo pipefail

export GNUPGHOME="$(pwd)/.gnupg"
exec gpg $@