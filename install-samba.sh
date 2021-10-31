#!/usr/bin/env bash

set -e # exit the script if any statement returns a non-true return value

IS_CONTENT_DIR="/var/www/content"

# functions
log() {
  echo "[install-samba]  ${*}"
}

log "start"
log "install packages"
sudo apt-get install --assume-yes \
  samba \
  samba-common-bin

if [[ -d "${IS_CONTENT_DIR}" ]]; then
  exit 0
fi
