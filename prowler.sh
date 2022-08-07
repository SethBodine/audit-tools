#!/bin/sh /usr/bin/source-this-script.sh
# Prep Environment

SCRIPT_PATH="/opt/prowler/"
APP_NAME="Prowler"

[[ ${VIRTUAL_ENV} ]] && deactivate

cd ${SCRIPT_PATH}
source venv/bin/activate
pip install --upgrade pip
pip install detect-secrets==1.0.3

echo -e "\n\n${APP_NAME} Environment Ready... execute \"deactivate\" to exit the environment"
