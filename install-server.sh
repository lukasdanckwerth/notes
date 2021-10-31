#!/bin/bash
set -u
set -e

export INS_NAME="install-server-automation"
export INS_REPOSITORY_URL="https://raw.githubusercontent.com/lukasdanckwerth/install-apache2-server/main"
INS_TEMP_DIR="/tmp/${INS_NAME}-$(uuidgen)"
export INS_TEMP_DIR
export INS_USER=${SUDO_USER}
export INS_DEBUG=0
export INS_SKIP_UPDATE=0

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
  local INS_UUID="$(uuidgen)"
  echo -e "${INS_TEMP_DIR}/${INS_UUID: -10}"
}

download_and_execute_script() {
  local SCRIPT_NAME=${1}
  local SCRIPT_URL="${INS_REPOSITORY_URL}/${SCRIPT_NAME}"
  local LOCAL_SCRIPT_PATH="$(temporary_file)-${SCRIPT_NAME}"

  curl "${SCRIPT_URL}" \
    --output "${LOCAL_SCRIPT_PATH}" \
    --silent \
    --show-error

  log "executing ${LOCAL_SCRIPT_PATH}"
  # shellcheck disable=SC1090
  . "${LOCAL_SCRIPT_PATH}"
}

log "start"

if [[ "$*" == *--debug* ]]; then
  export INS_DEBUG=1 && log "enabled debug"
fi

log "working directory: ${INS_TEMP_DIR}"
mkdir -p "${INS_TEMP_DIR}"

if [[ "$*" == *--no-update* ]]; then
  export INS_SKIP_UPDATE=1
  log "disabled updates (--no-update)"
else
  log "running apt update" && echo
  sudo apt update -y
fi

if which "apache23" &>/dev/null; then
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

log "removing working directory: ${INS_TEMP_DIR}"
rm -rf "${INS_TEMP_DIR}"

log "finished"
