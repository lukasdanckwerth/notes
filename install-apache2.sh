#!/usr/bin/env bash
set -x

echo -e """
# =========================================================== #
# Running install-apache2.sh ...                              #
# =========================================================== #
"""

log() {
  echo "[install-apache2.sh] ${*}";
}

# ========================================
# CONSTANTS
IA_SERVERNAME_FILE_PATH="/etc/apache2/conf-available/servername.conf"
IA_HOSTNAME=$(hostname)
log 'hostname: ' "${IA_HOSTNAME}"

# ========================================
# UPDATE
echo "update packages"
sudo apt update -y

# ========================================
# INSTALL
echo "install packages"
sudo apt install vim apache2 php postgresql postgresql-contrib -y

exit 0

# ========================================
# CONFIGURE APACHE

# ========================================
# CONFIGURE POSTGRESQL

ServerName __YOUR_WEB_SITE__

# enable rewrite
sudo a2enmod rewrite



$ sudo systemctl is-active postgresql
$ sudo systemctl is-enabled postgresql
$ sudo systemctl status postgresql
$ sudo pg_isready

$ sudo systemctl restart postgresql

$ curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

$ sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

$ sudo apt install pgadmin4 -y

$ sudo /usr/pgadmin4/bin/setup-web.sh
$ sudo systemctl restart apache2

$ sudo apt-get install php-pgsql

# ========================================
# install composer
sudo apt update && sudo apt install wget php-cli php-zip unzip curl
cd /tmp/
curl -sS https://getcomposer.org/installer |php
sudo mv composer.phar /usr/local/bin/composer