#!/bin/bash

# set -x   # prints all commands
set -e # exit the script if any statement returns a non-true return value
set -u # a reference to any variable you haven't previously defined - with the exceptions of $* and $@ - is an error, and causes the program to immediately exit.

export IS_REPOSITORY_URL="https://raw.githubusercontent.com/lukasdanckwerth/install-apache2-server/main"

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

IS_YES_NO="\033[32m(y/n)\033[0m"
IS_DO_APT_UPDATE=1

log "start"

if [ -z ${1+x} ]; then
  IS_DO_APT_UPDATE=1
  echo "1 is unset"
else
  IS_DO_APT_UPDATE=0
  echo "var is set to '${1}'"
fi

if [[ "${IS_DO_APT_UPDATE}" == "0" ]]; then
  log "running apt update"
  echo
  sudo apt update -y
else
  log "skipping apt update"
fi

if which "apache2" &>/dev/null; then
  log "apache2 already installed $(which "apache2")"
else
  sudo /bin/bash -c "$(curl -fsSL "${IS_REPOSITORY_URL}/install-apache2.sh")" "noupdate"
fi

if which "composer" &>/dev/null; then
  log "composer already installed: $(which "composer")"
else
  echo
  read -r -p "Do you want to install $(tput bold)Composer$(tput sgr0) ${IS_YES_NO}? " IS_INSTALL_COMPOSER
  echo
  if [[ "${IS_INSTALL_COMPOSER}" == "y" ]]; then
    sudo /bin/bash -c "$(curl -fsSL "${IS_REPOSITORY_URL}/install-composer.sh")" "noupdate"
  fi
fi

if which "samba" &>/dev/null; then
  log "samba already installed: $(which "samba")"
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
