#!/bin/bash
set -u
set -e

log() {
  echo "[install-postgresql]  ${*}"
}

die() {
  log "ERROR" && log "" && log "${*}"
  exit 1
}

log "start"
log "install packages"
sudo apt install postgresql postgresql-contrib php-pgsql -y

IP_IS_ACTIVE=$(sudo systemctl is-active postgresql)
log "postgresql is-active: ${IP_IS_ACTIVE}"
if [[ "${IP_IS_ACTIVE}" != "active" ]]; then
  die "postgresql is NOT active"
fi

IP_IS_ENABLED=$(sudo systemctl is-enabled postgresql)
log "postgresql is-enabled: ${IP_IS_ENABLED}"
if [[ "${IP_IS_ENABLED}" != "enabled" ]]; then
  die "postgresql is NOT enabled"
fi

log "postgresql status:"
sudo systemctl status postgresql

log "postgresql pg_isready: $(sudo pg_isready)"

log "restart postgresql"
sudo systemctl restart postgresql


if [[ -d "/usr/pgadmin4" ]]; then
  log "pgAdmin4 ($(bold "/usr/pgadmin4")) already installed"
else
  echo
  read -r -p "Install $(tput bold)pgAdmin4$(tput sgr0) (y/n)? " IS_INSTALL_COMPOSER
  if [[ "${IS_INSTALL_COMPOSER}" == "y" ]]; then
    download_and_execute_script "install-pgadmin4.sh"
  fi
fi
