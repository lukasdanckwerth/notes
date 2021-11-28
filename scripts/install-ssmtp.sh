#!/bin/bash
set -u
set -e

log() {
  echo -e "[install-ssmtp]  ${*}"
}

bold() {
  echo -e "$(tput bold)${*}$(tput sgr0)"
}

die() {
  log "$(tput setaf 9)ERROR: ${*} $(tput sgr0)" && exit 1
}

[[ "$(whoami)" == "root" ]] || die "script must be run as root"

echo -e "
Are you sure you want to install $(tput bold)ssmtp$(tput sgr0)? This will
do the following tasks:

  - install $(tput setab 5)ssmtp mailutils$(tput sgr0) packages
  - replace your ssmtp.config (if you want to)
"
read -r -p "Do you want to proceed? (y/n)? " INSTALL_CONTROL
[[ "${INSTALL_CONTROL}" == "y" ]] || exit 0

IS_REPOSITORY_URL="https://raw.githubusercontent.com/lukasdanckwerth/notes/main"
IS_DEFAULT_CONFIG_URL="${IS_REPOSITORY_URL}/assets/ssmtp/ssmtp.conf"

IS_SSMTP_CONFIG="/etc/ssmtp/ssmtp.conf"
IS_SSMTP_CONFIG_TEMP="/tmp/install-ssmtp.sh-ssmtp.conf"

IS_SSMTP_REVALIASES="/etc/ssmtp/revaliases"

log "start"
log "install packages"
sudo apt-get install --assume-yes ssmtp mailutils

[[ -d "/etc/ssmtp" ]] || die "directory /etc/ssmtp not existing."

echo
read -r -p "Do you want to run the wizard? (y/n) " replaceConfig

# replace ssmtp.conf
if [[ "${replaceConfig}" == "y" ]]; then

  log "download ssmtp.conf to ${IS_SSMTP_CONFIG_TEMP}"
  curl --silent "${IS_DEFAULT_CONFIG_URL}" -o "${IS_SSMTP_CONFIG_TEMP}"

  [[ -f "${IS_SSMTP_CONFIG_TEMP}" ]] || die "couldn't load ssmtp.conf ${IS_SSMTP_CONFIG}"

  log "removing old config ${IS_SSMTP_CONFIG}"
  sudo rm -rf "${IS_SSMTP_CONFIG}"

  log "moving new config from ${IS_SSMTP_CONFIG_TEMP} to ${IS_SSMTP_CONFIG}"
  sudo mv "${IS_SSMTP_CONFIG_TEMP}" "${IS_SSMTP_CONFIG}"

  [[ -f "${IS_SSMTP_CONFIG}" ]] || die "couldn't move ${IS_SSMTP_CONFIG}"
  sudo chown root:mail "${IS_SSMTP_CONFIG}"
  sudo chmod 640 "${IS_SSMTP_CONFIG}"

  log "$(sudo ls -la "${IS_SSMTP_CONFIG}")"

  log "Please provide a mailhub"
  log "  - mail.gmx.net:465"

  read -r -p "Enter mailhub (enter for GMX): " SM_MAILHUB_TEMP
  [[ "${SM_MAILHUB_TEMP}" == "" ]] && SM_MAILHUB="mail.gmx.net:465"
  [[ "${SM_MAILHUB_TEMP}" == "" ]] || SM_MAILHUB="${SM_MAILHUB_TEMP}"

  read -r -p "Enter mail adress: " SM_MAIL

  SM_PASSWORD_1="1"
  SM_PASSWORD_2="2"

  while [[ ! "${SM_PASSWORD_1}" == "${SM_PASSWORD_2}" ]]; do
    read -s -r -p "Enter password: " SM_PASSWORD_1
    echo
    read -s -r -p "Repeat password (again): " SM_PASSWORD_2
    echo
  done

  SM_PASSWORD_LENGTH=$(echo "${SM_PASSWORD_1}" | wc -c | xargs)

  echo "mailhub:   ${SM_MAILHUB}"
  echo "mail:      ${SM_MAIL}"
  echo "password:  ${SM_PASSWORD_LENGTH} characters"
  read -r -p "Is this correct (y/n)? " IS_DATA_CORRECT

  [[ "${IS_DATA_CORRECT}" == "y" ]] || exit 0

  sed -i "s/__MAILHUB__/${SM_MAILHUB}/g" "${IS_SSMTP_CONFIG}"
  sed -i "s/__MAIL__/${SM_MAIL}/g" "${IS_SSMTP_CONFIG}"
  sed -i "s/__PASSWORD__/${SM_PASSWORD_1}/g" "${IS_SSMTP_CONFIG}"

  read -r -p "Update ${IS_SSMTP_REVALIASES} (y/n)? " IS_UPDATE_REVALIASES
  [[ "${IS_UPDATE_REVALIASES}" == "y" ]] || exit 0
  sudo rm -rf "${IS_SSMTP_REVALIASES}"
  sudo touch "${IS_SSMTP_REVALIASES}"

  read -r -p "Use newly configured mail account for $(bold "root") (y/n)? " IS_USE_MAIL_ROOT
  [[ "${IS_USE_MAIL_ROOT}" == "y" ]] && echo "root:${SM_MAIL}:${SM_MAILHUB}" >> ${IS_SSMTP_REVALIASES}

  IS_SUDO_USER=$(SUDO_USER)
  read -r -p "Use newly configured mail account for $(bold "${IS_SUDO_USER}") (y/n)? " IS_USE_MAIL_USER
  [[ "${IS_USE_MAIL_USER}" == "y" ]] && echo "${IS_SUDO_USER}:${SM_MAIL}:${SM_MAILHUB}" >> ${IS_SSMTP_REVALIASES}

  read -r -p "Send test mail (y/n)? " IS_SEND_TEST_MAIL
  [[ "${IS_SEND_TEST_MAIL}" == "y" ]] || exit 0

  read -r -p "Receiver: " IS_SEND_TEST_MAIL_RECEIVER

  IS_HOSTNAME=$(hostname)
  IS_MAIL_SUBJECT="Successfully installed ssmtp on ${IS_HOSTNAME}"
  IS_MAIL_CONTENT="
Test mail from ${IS_HOSTNAME}.

Mailhub:  ${SM_MAILHUB}
Mail:     ${SM_MAIL}
Password: ${SM_PASSWORD_LENGTH} characters

Mail was automatically sent through install-ssmtp.sh script.
Link: ${IS_REPOSITORY_URL}
"

  echo "${IS_MAIL_CONTENT}" | mail -s "${IS_MAIL_SUBJECT}" "${IS_SEND_TEST_MAIL_RECEIVER}"

else
  read -r -p "Do you want to edit the ssmtp.conf right now (y/n)? " SET_PASSWORD
  echo
  if [[ "${SET_PASSWORD}" == "y" ]]; then
    sudo vim "${IS_SSMTP_CONFIG}"
  fi
fi
