#!/usr/bin/env bash

set -e # exit the script if any statement returns a non-true return value

log() {
  echo "[install-composer]  ${*}"
}

log "start"
log_headline "install composer"
sudo apt update -y

log "install dependency packages"
sudo apt install wget php-cli php-zip unzip curl

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

exit 0
