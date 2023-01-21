#!/bin/sh /usr/bin/source-this-script.sh
# Prep Environment

SCRIPT_PATH="/opt/prowler/"
APP_NAME="Prowler v2"

#[[ ${VIRTUAL_ENV} ]] && deactivate
if [ ! -z "${VIRTUAL_ENV+x}" ]; then deactivate; fi


cd ${SCRIPT_PATH} || exit #handle for cd failure
. venv/bin/activate
pip install --upgrade pip
pip install detect-secrets==1.0.3

printf "\n\n${APP_NAME} Environment Ready... execute \"deactivate\" to exit the environment\n\n"
