#!/usr/bin/env bash

# set -x   # prints all commands
set -e # exit the script if any statement returns a non-true return value

echo -e """
# =========================================================== #
# install-apache2.sh
"""

log() {
  echo "[install-apache2.sh] ${*}"
}

IA_SERVERNAME_FILE_PATH="/etc/apache2/conf-available/servername.conf"
log "servername.conf: ${IA_SERVERNAME_FILE_PATH}"

IA_HOSTNAME=$(hostname)
log "hostname: ${IA_HOSTNAME}"

log "UPDATE PACKAGES"
sudo apt update -y

log "INSTALL PACKAGES"
sudo apt install vim apache2 php postgresql postgresql-contrib php-pgsql -y

log "CONFIGURE APACHE"
if [[ ! -f "${IA_SERVERNAME_FILE_PATH}" ]]; then
  sudo touch "${IA_SERVERNAME_FILE_PATH}"
  echo "${IA_HOSTNAME}" >"${IA_SERVERNAME_FILE_PATH}"
  log "created ${IA_SERVERNAME_FILE_PATH} with content '${IA_HOSTNAME}'"
fi

log "enable rewrite"
sudo a2enmod rewrite

log "CONFIGURE POSTGRESQL"
log "postgresql is-active: $(sudo systemctl is-active postgresql)"
log "postgresql is-enabled: $(sudo systemctl is-enabled postgresql)"
log "postgresql status: $(sudo systemctl status postgresql)"
log "postgresql status: $(sudo pg_isready)"
log "restart postgresql"
sudo systemctl restart postgresql

read -r -p "Do you want to install pgadmin4? yes / no" answer
log "answer: ${answer}"

if [[ "${answer}" -eq "yes" ]]; then
  log "will install pgadmin4"
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

read -r -p "Do you want to install composer? yes / no " installComposer
log "installComposer: ${installComposer}"

if [[ "${installComposer}" -eq "yes" ]]; then
  log "skip install composer"
  sudo apt update -y
else
  log "skip install composer"
fi

echo -e """
# successfully finished script                                #
# =========================================================== #
"""

exit 0

ServerName __YOUR_WEB_SITE__

# ========================================
# install composer
sudo apt update && sudo apt install wget php-cli php-zip unzip curl
cd /tmp/
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
