#!/usr/bin/env bash

# set -x   # prints all commands
set -e # exit the script if any statement returns a non-true return value

# functions
log() {
  echo "[install-postgresql]  ${*}"
}

die() {
  log "ERROR" && log "" && log "${*}"
}

log "start"
log "INSTALL PACKAGES"
sudo apt install postgresql postgresql-contrib php-pgsql -y

log "CONFIGURE POSTGRESQL"

IP_IS_ACTIVE=$(sudo systemctl is-active postgresql);
log "postgresql is-active: ${IP_IS_ACTIVE}"
if [[ "${IP_IS_ACTIVE}" != "active" ]]; then
  die "postgresql is NOT active"
  exit 1
fi

IP_IS_ENABLED=$(sudo systemctl is-enabled postgresql);
log "postgresql is-enabled: ${IP_IS_ENABLED}"
if [[ "${IP_IS_ENABLED}" != "enabled" ]]; then
  die "postgresql is NOT enabled"
  exit 1
fi


log "postgresql status:"
sudo systemctl status postgresql

log "postgresql pg_isready: $(sudo pg_isready)"

log "restart postgresql"
sudo systemctl restart postgresql

echo
read -r -p "Do you want to install $(tput bold)pgAdmin$(tput sgr0) (y/n)? " installPgAdmin

if [[ "${installPgAdmin}" == "y" ]]; then
  log_headline "will install pgadmin4"
  log "adding public key for pgadmin"
  curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

  if [[ ! -f "/etc/apt/sources.list.d/pgadmin4.list" ]]; then
    log "downloading sources list"
    sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
  else
    log "pgadmin4 sources list already existing"
  fi

  log "install pgadmin4 package"
  sudo apt install pgadmin4 -y

  log "execute pgadmin4 setup-web.sh"
  sudo /usr/pgadmin4/bin/setup-web.sh

  log "restart apache2"
  sudo systemctl restart apache2
else
  log "skip install pgadmin4"
fi

exit 0
