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

die() {
  log "$(tput setaf 9)ERROR: ${*} $(tput sgr0)" && exit 1
}

log "start"
log "install packages"
sudo apt-get install --assume-yes ssmtp mailutils

[[ -d "/etc/ssmtp" ]] || die "directory /etc/ssmtp not existing."

read -r -p "Do you want to run the wizard? (y/n) " replaceConfig

# replace ssmtp.conf
if [[ "${replaceConfig}" == "y" ]]; then
  log "download ssmtp.conf to ${IS_SSMTP_CONFIG_TEMP}"
  curl "${IS_DEFAULT_CONFIG_URL}" -o "${IS_SSMTP_CONFIG_TEMP}"

  [[ -f "${IS_SSMTP_CONFIG_TEMP}" ]] || die "couldn't load ssmtp.conf ${IS_SSMTP_CONFIG}"

  log "removing old config ${IS_SSMTP_CONFIG}"
  sudo rm -rf "${IS_SSMTP_CONFIG}"

  log "moving new config from ${IS_SSMTP_CONFIG_TEMP} to ${IS_SSMTP_CONFIG}"
  sudo mv "${IS_SSMTP_CONFIG_TEMP}" "${IS_SSMTP_CONFIG}"

  [[ -f "${IS_SSMTP_CONFIG}" ]] || die "couldn't move ${IS_SSMTP_CONFIG}"

  log "${IS_SSMTP_CONFIG} file"
  sudo ls -la "${IS_SSMTP_CONFIG}"

  log "${IS_SSMTP_CONFIG} content"
  log ""
  sudo cat "${IS_SSMTP_CONFIG}"
  log ""

  echo -e "
  Please provide a mailhub.

  - GMX mail.gmx.net:465
  "
  read -r -p "Enter mailhub: " SM_MAILHUB
  read -r -p "Enter mail adress: " SM_MAIL

  SM_PASSWORD_1="1"
  SM_PASSWORD_2="2"

  while [[ ! "${SM_PASSWORD_1}" == "${SM_PASSWORD_1}" ]]; do
    read -r -p "Enter password: " SM_PASSWORD_1
    read -r -p "Repeat password (again): " SM_PASSWORD_2
  done

else
  read -r -p "Do you want to edit the ssmtp.conf right now (y/n)? " SET_PASSWORD
  echo
  if [[ "${SET_PASSWORD}" == "y" ]]; then
    sudo vim "${IS_SSMTP_CONFIG}"
  fi
fi
