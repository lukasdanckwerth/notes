#!/bin/bash

set -u
set -e

# ==-----------------------------------------------------------
# VARS

CC_DEBUG=0
CC_PREFIX="[cc]  "
CC_GIT_REPO="https://github.com/lukasdanckwerth/bash-command.git"
CC_GIT_COMMAND_FILE="https://raw.githubusercontent.com/lukasdanckwerth/bash-command/main/command"

if [[ "$*" == *-y* ]]; then CC_DEBUG=1; fi

# ==-----------------------------------------------------------
# FUNCTIONS

emph() {
    echo -e "\033[1m${*}\033[0m"
}

log() {
    echo -e "${CC_PREFIX}${*}"
}

die() {
    log "${*}" && exit 0
}

die_error() {
    log "" && log "  ERROR" && die "  ${*}\n"
}

ask() {
    read -r -p "${CC_PREFIX}${*} " CC_ANSWER
    echo "${CC_ANSWER}"
}

# ==-----------------------------------------------------------
# INTERACTION

if [[ "${CC_DEBUG}" == "1" ]]; then
    CC_CONTROL="y"
else
    CC_CONTROL=$(ask "Are you sure to create a new bash command $(emph "(y/n)")?")
fi

[[ "${CC_CONTROL}" == "y" ]] || die "User arborted."

CC_CMD_NAME=$(ask "Please provide a $(emph "command name"):")
if [[ "${CC_DEBUG}" == "1" && "${CC_CMD_NAME}" == "" ]]; then
    CC_CMD_NAME="test"
fi
[[ "${CC_CMD_NAME}" == "" ]] && die "No command name provided."

CC_VAR_PREFIX="$(echo "${CC_CMD_NAME}" | head -c2 | tr a-z A-Z)_"
CC_PROJECT_DIR="$(pwd)/${CC_CMD_NAME}"

log ""
log "command name: $(emph "${CC_CMD_NAME}")"
log "directory:    $(emph "${CC_PROJECT_DIR}")"
log "var prefix:   $(emph "${CC_VAR_PREFIX}")"
log ""

CC_CONTROL=$(ask "Is this correct $(emph "(y/n)")?")
[[ "${CC_CONTROL}" == "y" ]] || die "User arborted."

if [[ -d "${CC_PROJECT_DIR}" && "${CC_DEBUG}" == "0" ]]; then
    die_error "Directory ${CC_PROJECT_DIR} already existing."
fi

# ==-----------------------------------------------------------
# PREPARE PROJECT

log "Create project directory ..."
mkdir -p "${CC_PROJECT_DIR}"

log "Receive command file ..."
CC_CMD_PATH="${CC_PROJECT_DIR}/${CC_CMD_NAME}"
curl "${CC_GIT_COMMAND_FILE}" -o "${CC_CMD_PATH}" -s
chmod +x "${CC_CMD_PATH}"

log "Prepare command file ..."
sed -i "" "s/{{COMMAND_NAME}}/${CC_CMD_NAME}/g" "${CC_CMD_PATH}"
sed -i "" "s/__VAR_PREFIX__/${CC_VAR_PREFIX}/g" "${CC_CMD_PATH}"

log "Creating README.md ..."
CC_README_PATH="${CC_PROJECT_DIR}/README.md"
echo -e "# ${CC_CMD_NAME}\n" >"${CC_README_PATH}"
echo -e "## Usage\n" >>"${CC_README_PATH}"
echo "\`\`\`" >>"${CC_README_PATH}"
env ${CC_CMD_PATH} --help >>"${CC_README_PATH}"
echo "\`\`\`" >>"${CC_README_PATH}"

cat "${CC_README_PATH}"

CC_INIT_GIT_REPOSITORY=$(ask "Do you want to initialize a new git repository $(emph "(y/n)")?")
if [[ "${CC_INIT_GIT_REPOSITORY}" == "y" ]]; then
    pushd ${CC_PROJECT_DIR}

    git init
    git add .
    git commit -m "first commit"
    git branch -M main

    CC_REMOTE_URL=$(ask "You already got a repository URL ($(emph "optional")):")
    if [[ ! "${CC_REMOTE_URL}" == "" ]]; then
        git remote add origin "${CC_REMOTE_URL}"
        git push -u origin main
    fi
fi
