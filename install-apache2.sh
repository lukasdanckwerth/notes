#!/bin/bash
set -u
set -e

IA_SERVERNAME_FILE_PATH="/etc/apache2/conf-available/servername.conf"
IA_HOSTNAME=$(hostname)
IA_APACHE_CONFIG="/etc/apache2/apache2.conf"
IA_DEFAULT_CONFIG_URL="${IS_REPOSITORY_URL}/apache2/apache.conf"
IA_INDEX="/var/www/html/index.html"
IA_INDEX_URL="${IS_REPOSITORY_URL}/apache2/index.html"

log() {
  echo "[install-apache2]  ${*}"
}

log "install packages" && echo
sudo apt install -y vim apache2 php && echo

log "handle servername.conf: ${IA_SERVERNAME_FILE_PATH}"
if [[ ! -f "${IA_SERVERNAME_FILE_PATH}" ]]; then
  sudo touch "${IA_SERVERNAME_FILE_PATH}"
  echo "${IA_HOSTNAME}" >"${IA_SERVERNAME_FILE_PATH}"
  log "created ${IA_SERVERNAME_FILE_PATH} with content '${IA_HOSTNAME}'"
fi

log "enable rewrite"
sudo a2enmod rewrite

echo
read -r -p "Do you want to replace the config $(bold "${IA_APACHE_CONFIG}") with the default one from this script? The default config can't viewed at ${IA_DEFAULT_CONFIG_URL}. (y/n) " INS_REPLACE_CONFIG
if [[ "${INS_REPLACE_CONFIG}" == "y" ]]; then
  echo 'replaceConfig'
fi


echo
read -r -p "Do you want to replace the index.html $(bold "${IA_INDEX}") with the default one from this script? The default index.html can't viewed at ${IA_INDEX_URL}. (y/n) " INS_REPLACE_INDEX
if [[ "${INS_REPLACE_INDEX}" == "y" ]]; then
  echo 'replaceConfig'
fi

env
