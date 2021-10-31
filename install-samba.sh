#!/usr/bin/env bash

set -e # exit the script if any statement returns a non-true return value

IS_REPOSITORY_URL="https://raw.githubusercontent.com/lukasdanckwerth/install-apache2-server/main"
IS_DEFAULT_CONFIG_URL="${IS_REPOSITORY_URL}/smb/smb.conf"
IS_CONTENT_DIR="/var/www/content"
IS_SAMBA_CONFIG="/etc/samba/smb.conf"
IS_SAMBA_CONFIG_TEMP="/tmp/install-samba.sh-smb.conf"

log() {
  echo "[install-samba]  ${*}"
}

bold() {
  echo "$(tput bold)${*}$(tput sgr0)"
}

log "start"
log "whoami: $(whoami)"

log "install packages"
sudo apt-get install --assume-yes \
  samba \
  samba-common-bin

echo
read -r -p "Do you want to replace the config $(bold "${IS_SAMBA_CONFIG}") with the default one from this script? The default config can't viewed at . (y/n) " replaceConfig

if [[ "${replaceConfig}" == "y" ]]; then
  log "download smb.conf to ${IS_SAMBA_CONFIG_TEMP}"
  curl "${IS_DEFAULT_CONFIG_URL}" -o "${IS_SAMBA_CONFIG_TEMP}"

  if [[ -f "${IS_SAMBA_CONFIG_TEMP}" ]]; then

    log "removing old config ${IS_SAMBA_CONFIG}"
    sudo rm -rf "${IS_SAMBA_CONFIG}"

    log "moving new config from ${IS_SAMBA_CONFIG_TEMP} to ${IS_SAMBA_CONFIG}"
    sudo mv "${IS_SAMBA_CONFIG_TEMP}" "${IS_SAMBA_CONFIG}"

  else
    log "couldn't load smb.conf ${IS_SAMBA_CONFIG}"
    exit 1
  fi

  if [[ ! -d "${IS_CONTENT_DIR}" ]]; then
    log "creating directory ${IS_CONTENT_DIR}"
    sudo mkdir -p "${IS_CONTENT_DIR}"
  else
    log "directory ${IS_CONTENT_DIR} already existing"
  fi
fi

echo
read -r -p "Do you want to set the $(bold "samba password") for the user $(bold "${USER}") (y/n)? " SET_PASSWORD
if [[ "${SET_PASSWORD}" == "y" ]]; then
  sudo smbpasswd -a "${USER}"
fi
