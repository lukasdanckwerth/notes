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

log_headline "sudo apt update -y"
echo
sudo apt update -y

if which "apache2" &>/dev/null; then
  log "apache2 already installed"
else
  sudo /bin/bash -c "$(curl -fsSL "${IS_REPOSITORY_URL}/install-apache2.sh")" "noupdate"
fi

if which "samba" &>/dev/null; then
  log "samba already installed"
else
  echo
  read -r -p "Do you want to install $(tput bold)Samba$(tput sgr0) (y/n)? " IS_INSTALL_SAMBA
  echo
  if [[ "${IS_INSTALL_SAMBA}" == "y" ]]; then
    sudo /bin/bash -c "$(curl -fsSL "${IS_REPOSITORY_URL}/install-samba.sh")" "noupdate"
  fi
fi

log "finished"
exit 0
