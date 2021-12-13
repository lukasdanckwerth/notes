#!/bin/bash
set -u
set -e

# next line will be replaced by `update-version` command
INS_VERSION=109

export INS_NAME="install-server"
export INS_SEPARATOR="--------------------------------------"
export INS_REPOSITORY_URL="https://raw.githubusercontent.com/lukasdanckwerth/notes/main"
export INS_TEMP_DIR="/tmp/${INS_NAME}-$(uuidgen | tail -c 12)"
export INS_USER=${SUDO_USER}
export INS_DEBUG=0
export INS_SKIP_UPDATE=0
export INS_LOCAL_IP=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')

log() {
  echo "[install-server]  ${*}"
}

die() {
  log "ERROR" && log "" && log "${*}"
}

log_headline() {
  echo && log "${INS_SEPARATOR}"
  log "${*}"
}

bold() {
  echo -e "$(tput bold)${*}$(tput sgr0)"
}

green() {
  echo -e "$(tput setaf 3)${*}$(tput sgr0)"
}

temporary_file() {
  echo -e "${INS_TEMP_DIR}/$(uuidgen | tail -c 12)"
}

download_and_execute_script() {
  local SCRIPT_NAME=${1}
  local SCRIPT_URL="${INS_REPOSITORY_URL}/scripts/${SCRIPT_NAME}"
  # shellcheck disable=SC2155
  local LOCAL_SCRIPT_PATH="$(temporary_file)-${SCRIPT_NAME}"

  curl "${SCRIPT_URL}" \
    --output "${LOCAL_SCRIPT_PATH}" \
    --silent \
    --show-error

  log_headline "executing ${SCRIPT_NAME}"

  # shellcheck disable=SC1090
  . "${LOCAL_SCRIPT_PATH}"
}

[[ "$*" == *--debug* ]] && export INS_DEBUG=1
log "start (version: ${INS_VERSION})"

mkdir -p "${INS_TEMP_DIR}"

if ! [[ "$*" == *--no-update* ]]; then
  log "running apt update" && echo
  sudo apt update -y
fi

if which "apache2" &>/dev/null && [[ "${INS_DEBUG}" == "0" ]]; then
  log "apache2 ($(bold "$(which "apache2")")) already installed"
else
  download_and_execute_script "install-apache2.sh"
fi

if grep "postgresql" /etc/passwd &>/dev/null; then
  log "postgresql already installed."
else
  echo
  read -r -p "Install $(tput bold)postgresql$(tput sgr0) $(green "(y/n)")? " IS_INSTALL_COMPOSER
  if [[ "${IS_INSTALL_COMPOSER}" == "y" ]]; then
    download_and_execute_script "install-postgresql.sh"
  fi
fi

if which "composer" &>/dev/null; then
  log "composer ($(bold "$(which "composer")")) already installed"
else
  echo
  read -r -p "Install $(tput bold)Composer$(tput sgr0) $(green "(y/n)")? " IS_INSTALL_COMPOSER
  if [[ "${IS_INSTALL_COMPOSER}" == "y" ]]; then
    download_and_execute_script "install-composer.sh"
  fi
fi

if which "samba" &>/dev/null; then
  log "samba ($(bold "$(which "samba")")) already installed"
else
  echo
  read -r -p "Install $(tput bold)Samba$(tput sgr0) $(green "(y/n)")? " IS_INSTALL_SAMBA
  if [[ "${IS_INSTALL_SAMBA}" == "y" ]]; then
    download_and_execute_script "install-samba.sh"
  fi
fi

# remove working directory
rm -rf "${INS_TEMP_DIR}"

log ""
log "successfully finished"
