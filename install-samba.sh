#!/bin/bash
set -u
set -e

IS_DEFAULT_CONFIG_URL="${INS_REPOSITORY_URL}/smb/smb.conf"
IS_CONTENT_DIR="/var/www/content"
IS_SAMBA_CONFIG="/etc/samba/smb.conf"
IS_SAMBA_CONFIG_TEMP="/tmp/install-samba.sh-smb.conf"

log() {
  echo -e "[install-samba]  ${*}"
}

bold() {
  echo -e "$(tput bold)${*}$(tput sgr0)"
}

log "start"
log "INS_USER: ${INS_USER}"

log "install packages"
sudo apt-get install --assume-yes \
  samba \
  samba-common-bin

echo
read -r -p "Do you want to replace the config $(bold "${IS_SAMBA_CONFIG}") with the default one from this script? The default config can't viewed at ${IS_DEFAULT_CONFIG_URL}. (y/n) " replaceConfig

if [[ "${replaceConfig}" == "y" ]]; then
  log "download smb.conf to ${IS_SAMBA_CONFIG_TEMP}"
  curl "${IS_DEFAULT_CONFIG_URL}" -o "${IS_SAMBA_CONFIG_TEMP}"

  if [[ -f "${IS_SAMBA_CONFIG_TEMP}" ]]; then

    log "removing old config ${IS_SAMBA_CONFIG}"
    sudo rm -rf "${IS_SAMBA_CONFIG}"

    log "moving new config from ${IS_SAMBA_CONFIG_TEMP} to ${IS_SAMBA_CONFIG}"
    sudo mv "${IS_SAMBA_CONFIG_TEMP}" "${IS_SAMBA_CONFIG}"

    if [[ -f "${IS_SAMBA_CONFIG}" ]]; then

      log "${IS_SAMBA_CONFIG} file"
      sudo ls -la "${IS_SAMBA_CONFIG}"

      log "${IS_SAMBA_CONFIG} content"
      log ""
      sudo cat "${IS_SAMBA_CONFIG}"
      log ""

    else
      log "couldn't move ${IS_SAMBA_CONFIG}"
      exit 1
    fi

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
read -r -p "Set $(bold "samba password") for the user $(bold "${INS_USER}") (y/n)? " SET_PASSWORD
echo
if [[ "${SET_PASSWORD}" == "y" ]]; then
  sudo smbpasswd -a "${INS_USER}"
fi
