#!/bin/bash
set -u
set -e

IA_SERVERNAME_FILE_PATH="/etc/apache2/conf-available/servername.conf"
IA_HOSTNAME=$(hostname)
IA_APACHE_CONFIG="/etc/apache2/apache2.conf"
IA_DEFAULT_CONFIG_URL="${IS_REPOSITORY_URL}/apache2/apache.conf"

log() {
  echo "[install-apache2]  ${*}"
}

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

echo
read -r -p "Do you want to replace the config $(bold "${IA_APACHE_CONFIG}") with the default one from this script? The default config can't viewed at ${IA_DEFAULT_CONFIG_URL}. (y/n) " replaceConfig

if [[ "${replaceConfig}" == "y" ]]; then
  echo 'replaceConfig'
fi

env
