#!/usr/bin/env bash

MASTER_COPY="../gpg-master.enc"
LOCAL_BACKUP="/Users/bazhenov/gpg-master.enc"

MASTER_COPY_CS=$(md5sum "${MASTER_COPY}" | awk '{print $1}')
LOCAL_BACKUP_CS=$(md5sum "${LOCAL_BACKUP}" | awk '{print $1}')

if [[ "$MASTER_COPY_CS" == "$LOCAL_BACKUP_CS" ]]; then
  echo "Ok (${MASTER_COPY_CS})"
  exit 0
else
  echo "Failed"
  md5sum "${MASTER_COPY}"
  md5sum "${LOCAL_BACKUP}"
  exit 1
fi

