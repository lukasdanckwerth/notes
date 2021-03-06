#!/bin/bash
set -u
set -e

IA_SERVERNAME_FILE_PATH="/etc/apache2/conf-available/servername.conf"
IA_HOSTNAME=$(hostname)
IA_APACHE_CONFIG="/etc/apache2/apache2.conf"
IA_APACHE_CONFIG_URL="${INS_REPOSITORY_URL}/assets/apache2/apache.conf"
IA_INDEX="/var/www/html/index.html"
IA_INDEX_URL="${INS_REPOSITORY_URL}/assets/apache2/index.html"

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

log "enable rewrite: $(sudo a2enmod rewrite)"

echo
read -r -p "Do you want to replace the config $(bold "${IA_APACHE_CONFIG}") with the default one from this script? The default config can't viewed at ${IA_APACHE_CONFIG_URL}. $(green "(y/n)") " INS_REPLACE_CONFIG
if [[ "${INS_REPLACE_CONFIG}" == "y" ]]; then
  echo 'replaceConfig'
fi

echo
read -r -p "Do you want to replace the index.html $(bold "${IA_INDEX}") with the default one from this script? The default index.html can't viewed at ${IA_INDEX_URL}. $(green "(y/n)") " INS_REPLACE_INDEX
if [[ "${INS_REPLACE_INDEX}" == "y" ]]; then
  INS_INDEX_TEMPORARY="$(temporary_file)-index.html"
  log "downloading index.html to ${INS_INDEX_TEMPORARY}"

  curl "${IA_INDEX_URL}" -o "${INS_INDEX_TEMPORARY}" -s
  [[ -f "${INS_INDEX_TEMPORARY}" ]] || (log "ERROR: can't download index.html" && exit 1)

  sed -i "s/___TITLE___/${IA_HOSTNAME}/g" "${INS_INDEX_TEMPORARY}"
  sed -i "s/___LOCAL_IP___/${INS_LOCAL_IP}/g" "${INS_INDEX_TEMPORARY}"

  log "$(sudo rm -rfv "${IA_INDEX}")"
  log "$(sudo mv -v "${INS_INDEX_TEMPORARY}" "${IA_INDEX}")"
fi
