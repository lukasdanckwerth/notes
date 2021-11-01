#!/bin/bash
set -u
set -e

log() {
  echo "[install-postgresql]  ${*}"
}

log "start"

log "adding public key for pgadmin"
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

if [[ ! -f "/etc/apt/sources.list.d/pgadmin4.list" ]]; then
  log "get sources list"
  sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
else
  log "sources list already existing"
fi

log "install pgadmin4 package"
sudo apt install --assume-yes pgadmin4

log "execute pgadmin4 setup-web.sh"
sudo /usr/pgadmin4/bin/setup-web.sh

log "restart apache2"
sudo systemctl restart apache2
