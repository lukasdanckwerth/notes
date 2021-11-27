#!/bin/bash
set -u
set -e

echo -e "
Are you sure you want to install $(tput bold)ssmtp$(tput sgr0)? This will
do the following tasks:

  - install $(tput setab 5)ssmtp$(tput sgr0) packages
  - replace your ssmtp.config (if you want to)
  - set a samba password for current user (if you want to)
"
read -r -p "Do you want to proceed?s  (y/n)?" INSTALL_CONTROL
[[ "${INSTALL_CONTROL}" == "y" ]] || exit 0;

IS_REPOSITORY_URL="https://raw.githubusercontent.com/lukasdanckwerth/notes/main"
IS_DEFAULT_CONFIG_URL="${IS_REPOSITORY_URL}/assets/ssmtp/ssmtp.conf"
IS_SSMTP_CONFIG="/etc/ssmtp/ssmtp.conf"
IS_SSMTP_CONFIG_TEMP="/tmp/install-ssmtp.sh-ssmtp.conf"

log() {
  echo -e "[install-ssmtp]  ${*}"
}

bold() {
  echo -e "$(tput bold)${*}$(tput sgr0)"
}

log "start"
log "install packages"
# sudo apt-get install --assume-yes ssmtp

log "contents of ${IS_SSMTP_CONFIG}"
cat "${IS_SSMTP_CONFIG}"

log "download ssmtp.conf to ${IS_SSMTP_CONFIG_TEMP}"
curl "${IS_DEFAULT_CONFIG_URL}" -o "${IS_SSMTP_CONFIG_TEMP}"

log "contents of ${IS_SSMTP_CONFIG_TEMP}"
cat "${IS_SSMTP_CONFIG}"

read -r -p "Do you want to replace the config $(bold "${IS_SSMTP_CONFIG}") with the default one from this script? The default config can't viewed at ${IS_DEFAULT_CONFIG_URL}. (y/n) " replaceConfig


exit 0

# replace smb.conf
if [[ "${replaceConfig}" == "y" ]]; then
  log "download smb.conf to ${IS_SSMTP_CONFIG_TEMP}"
  curl "${IS_DEFAULT_CONFIG_URL}" -o "${IS_SSMTP_CONFIG_TEMP}"

  if [[ -f "${IS_SSMTP_CONFIG_TEMP}" ]]; then

    log "removing old config ${IS_SSMTP_CONFIG}"
    sudo rm -rf "${IS_SSMTP_CONFIG}"

    log "moving new config from ${IS_SSMTP_CONFIG_TEMP} to ${IS_SSMTP_CONFIG}"
    sudo mv "${IS_SSMTP_CONFIG_TEMP}" "${IS_SSMTP_CONFIG}"

    if [[ -f "${IS_SSMTP_CONFIG}" ]]; then

      log "${IS_SSMTP_CONFIG} file"
      sudo ls -la "${IS_SSMTP_CONFIG}"

      log "${IS_SSMTP_CONFIG} content"
      log ""
      sudo cat "${IS_SSMTP_CONFIG}"
      log ""

    else
      log "couldn't move ${IS_SSMTP_CONFIG}"
      exit 1
    fi
  else
    log "couldn't load smb.conf ${IS_SSMTP_CONFIG}"
    exit 1
  fi

  if [[ ! -d "${IS_CONTENT_DIR}" ]]; then
    log "creating directory ${IS_CONTENT_DIR}"
    sudo mkdir -p "${IS_CONTENT_DIR}"
  else
    log "directory ${IS_CONTENT_DIR} already existing"
  fi
fi

INS_USER=${SUDO_USER}
echo
read -r -p "Set $(bold "samba password") for the user $(bold "${INS_USER}") (y/n)? " SET_PASSWORD
echo
if [[ "${SET_PASSWORD}" == "y" ]]; then
  sudo smbpasswd -a "${INS_USER}"
fi
