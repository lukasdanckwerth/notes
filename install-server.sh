#!/bin/bash
set -u
set -e

export IS_REPOSITORY_URL="https://raw.githubusercontent.com/lukasdanckwerth/install-apache2-server/main"
export IS_USER_1=${SUDO_USER}
export IS_USER_2=${LOGNAME}

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

bold() {
  echo -e "$(tput bold)${*}$(tput sgr0)"
}

log "start"
log "IS_USER_1: ${IS_USER_1}"
log "IS_USER_2: ${IS_USER_2}"

if [ ! -z ${1+x} ] && [[ "${1}" == "noupdate" ]]; then
  log "skipping apt update"
else
  log "running apt update" && echo
  sudo apt update -y
fi

if which "apache2" &>/dev/null; then
  log "apache2 already installed $(which "apache2")"
else
  sudo /bin/bash -c "$(curl -fsSL "${IS_REPOSITORY_URL}/install-apache2.sh")" "noupdate"
fi

if grep "postgresql" /etc/passwd &>/dev/null; then
  log "postgresql already installed."
else
  echo
  read -r -p "Install $(tput bold)postgresql$(tput sgr0) (y/n)? " IS_INSTALL_COMPOSER
  if [[ "${IS_INSTALL_COMPOSER}" == "y" ]]; then
    echo
    sudo /bin/bash -c "$(curl -fsSL "${IS_REPOSITORY_URL}/install-postgresql.sh")" "noupdate"
  fi
fi

if which "composer" &>/dev/null; then
  log "composer already installed: $(which "composer")"
else
  echo
  read -r -p "Install $(tput bold)Composer$(tput sgr0) (y/n)? " IS_INSTALL_COMPOSER
  if [[ "${IS_INSTALL_COMPOSER}" == "y" ]]; then
    echo
    sudo /bin/bash -c "$(curl -fsSL "${IS_REPOSITORY_URL}/install-composer.sh")" "noupdate"
  fi
fi

if which "samba" &>/dev/null; then
  log "samba already installed: $(which "samba")"
else
  echo
  read -r -p "Install $(tput bold)Samba$(tput sgr0) (y/n)? " IS_INSTALL_SAMBA
  if [[ "${IS_INSTALL_SAMBA}" == "y" ]]; then
    echo
    sudo /bin/bash -c "$(curl -fsSL "${IS_REPOSITORY_URL}/install-samba.sh")" "noupdate"
  fi
fi

log "finished"
