#!/bin/bash
set -u
set -e

log() {
  echo "[install-composer]  ${*}"
}

log "start"
sudo apt update -y

log "install dependency packages"
sudo apt install php-cli php-zip unzip curl wget

log "moving to temporary dir"
pushd /tmp/

log "download installer"
curl -sS https://getcomposer.org/installer | php

log "download installer"
sudo mv composer.phar /usr/local/bin/composer
popd

if [[ -f "/usr/local/bin/composer" ]]; then
  log "successfully installed composer"
fi
