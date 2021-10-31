#!/usr/bin/env bash

# set -x   # prints all commands
set -e # exit the script if any statement returns a non-true return value

log() {
  echo "[install-apache2]  ${*}"
}

log "1: ${1}"

IA_SERVERNAME_FILE_PATH="/etc/apache2/conf-available/servername.conf"
log "servername.conf: ${IA_SERVERNAME_FILE_PATH}"

IA_HOSTNAME=$(hostname)
log "hostname: ${IA_HOSTNAME}"

log "INSTALL PACKAGES"
sudo apt install vim apache2 php -y

log "CONFIGURE APACHE"
if [[ ! -f "${IA_SERVERNAME_FILE_PATH}" ]]; then
  sudo touch "${IA_SERVERNAME_FILE_PATH}"
  echo "${IA_HOSTNAME}" >"${IA_SERVERNAME_FILE_PATH}"
  log "created ${IA_SERVERNAME_FILE_PATH} with content '${IA_HOSTNAME}'"
fi

log "enable rewrite"
sudo a2enmod rewrite

exit 0
