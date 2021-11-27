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
read -r -p "Do you want to proceed? (y/n)? " INSTALL_CONTROL
[[ "${INSTALL_CONTROL}" == "y" ]] || exit 0

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
# sudo apt-get install --assume-yes ssmtp mailutils

read -r -p "Do you want to replace the config $(bold "${IS_SSMTP_CONFIG}") with the default one from this script? The default config can't viewed at ${IS_DEFAULT_CONFIG_URL}. (y/n) " replaceConfig

# replace ssmtp.conf
if [[ "${replaceConfig}" == "y" ]]; then
  log "download ssmtp.conf to ${IS_SSMTP_CONFIG_TEMP}"
  curl "${IS_DEFAULT_CONFIG_URL}" -o "${IS_SSMTP_CONFIG_TEMP}"

  [[ -f "${IS_SSMTP_CONFIG_TEMP}" ]] || (log "couldn't load ssmtp.conf ${IS_SSMTP_CONFIG}" && exit 1)

  log "removing old config ${IS_SSMTP_CONFIG}"
  sudo rm -rf "${IS_SSMTP_CONFIG}"

  log "moving new config from ${IS_SSMTP_CONFIG_TEMP} to ${IS_SSMTP_CONFIG}"
  sudo mv "${IS_SSMTP_CONFIG_TEMP}" "${IS_SSMTP_CONFIG}"

  [[ -f "${IS_SSMTP_CONFIG}" ]] || (log "couldn't move ${IS_SSMTP_CONFIG}" && exit 1)

  log "${IS_SSMTP_CONFIG} file"
  sudo ls -la "${IS_SSMTP_CONFIG}"

  log "${IS_SSMTP_CONFIG} content"
  log ""
  sudo cat "${IS_SSMTP_CONFIG}"
  log ""

else
  read -r -p "Do you want to edit the ssmtp.conf right now (y/n)? " SET_PASSWORD
  echo
  if [[ "${SET_PASSWORD}" == "y" ]]; then
    sudo vim "${IS_SSMTP_CONFIG}"
  fi
fi
