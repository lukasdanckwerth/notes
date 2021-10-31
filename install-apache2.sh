#!/bin/bash
set -u
set -e

log() {
  echo "[install-apache2]  ${*}"
}

IA_SERVERNAME_FILE_PATH="/etc/apache2/conf-available/servername.conf"
IA_HOSTNAME=$(hostname)

log "install packages"
sudo apt install -y vim apache2 php

log "handle servername.conf: ${IA_SERVERNAME_FILE_PATH}"
if [[ ! -f "${IA_SERVERNAME_FILE_PATH}" ]]; then
  sudo touch "${IA_SERVERNAME_FILE_PATH}"
  echo "${IA_HOSTNAME}" >"${IA_SERVERNAME_FILE_PATH}"
  log "created ${IA_SERVERNAME_FILE_PATH} with content '${IA_HOSTNAME}'"
fi

log "enable rewrite"
sudo a2enmod rewrite


