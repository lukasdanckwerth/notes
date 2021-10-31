#!/bin/bash
set -u
set -e

export IS_REPOSITORY_URL="https://raw.githubusercontent.com/lukasdanckwerth/install-apache2-server/main"
export IS_TEMP="/tmp/install-apache2-server-$(uuidgen)"
export IS_USER_1=${SUDO_USER}

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

temporary_file() {
  echo -e "${IS_TEMP}/$(uuidgen)"
}

download_and_execute_script() {
  local SCRIPT_NAME=${1}
  local SCRIPT_URL="${IS_REPOSITORY_URL}/${SCRIPT_NAME}"
  local LOCAL_SCRIPT_PATH="$(temporary_file).command"

  log "SCRIPT_NAME: ${SCRIPT_NAME}"
  log "SCRIPT_URL: ${SCRIPT_URL}"
  log "LOCAL_SCRIPT_PATH: ${LOCAL_SCRIPT_PATH}"

  curl "${SCRIPT_URL}" \
    --output "${LOCAL_SCRIPT_PATH}" \
    --silent \
    --show-error


}

log "start"

log "creating temporary directory"
log "IS_TEMP: ${IS_TEMP}"
mkdir -p "${IS_TEMP}"

log "IS_USER_1: ${IS_USER_1}"
log "IS_USER_2: ${IS_USER_2}"

if [ ! -z ${1+x} ] && [[ "${1}" == "noupdate" ]]; then
  log "skipping apt update"
else
  log "running apt update" && echo
  sudo apt update -y
fi

if which "apache2" &>/dev/null; then
  log "apache2 ($(bold "$(which "apache2")")) already installed"
else
  download_and_execute_script "install-apache2.sh"
fi

if grep "postgresql" /etc/passwd &>/dev/null; then
  log "postgresql already installed."
else
  echo
  read -r -p "Install $(tput bold)postgresql$(tput sgr0) (y/n)? " IS_INSTALL_COMPOSER
  if [[ "${IS_INSTALL_COMPOSER}" == "y" ]]; then
    download_and_execute_script "install-postgresql.sh"
  fi
fi

if which "composer" &>/dev/null; then
  log "composer ($(bold "$(which "composer")")) already installed"
else
  echo
  read -r -p "Install $(tput bold)Composer$(tput sgr0) (y/n)? " IS_INSTALL_COMPOSER
  if [[ "${IS_INSTALL_COMPOSER}" == "y" ]]; then
    download_and_execute_script "install-composer.sh"
  fi
fi

if which "samba" &>/dev/null; then
  log "samba ($(bold "$(which "samba")")) already installed"
else
  echo
  read -r -p "Install $(tput bold)Samba$(tput sgr0) (y/n)? " IS_INSTALL_SAMBA
  if [[ "${IS_INSTALL_SAMBA}" == "y" ]]; then
    download_and_execute_script "install-samba.sh"
  fi
fi

log "cleaning up"
rm -rf "${IS_TEMP}"

log "finished"
