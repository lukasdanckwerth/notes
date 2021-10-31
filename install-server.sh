#!/usr/bin/env bash

# set -x   # prints all commands
set -e # exit the script if any statement returns a non-true return value

IS_REPOSITORY_URL="https://raw.githubusercontent.com/lukasdanckwerth/install-apache2-server/main"

# functions
log() {
  echo "[install-server]  ${*}"
}

die() {
  log "ERROR" && log "" && log "${*}"
}

log_headline() {
  log "--------------------------------------"
  log "${*}"
}

log "start"

log_headline "UPDATE PACKAGES"
sudo apt update -y

if command -v "apache2" &>/dev/null; then
  log "apache2 already installed"
else
  sudo /bin/bash -c "$(curl -fsSL "${IS_REPOSITORY_URL}/install-apache2.sh")" "noupdate"
fi


if command -v "smb" &>/dev/null; then
  log "samba already installed"
else
  echo
  read -r -p "Do you want to install $(tput bold)Samba$(tput sgr0) (y/n)? " IS_INSTALL_SAMBA
  if [[ "${IS_INSTALL_SAMBA}" == "y" ]]; then
    sudo /bin/bash -c "$(curl -fsSL "${IS_REPOSITORY_URL}/install-samba.sh")" "noupdate"
  fi
fi

log "successfully finished script"
exit 0
