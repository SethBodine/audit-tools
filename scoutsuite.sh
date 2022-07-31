#!/bin/sh source-this-script.sh
# Prep Environment

SCRIPT_PATH="/opt/ScoutSuite/"
APP_NAME="Scoutsuite"

[[ ${VIRTUAL_ENV} ]] && deactivate

cd ${SCRIPT_PATH}
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt 

echo -e "\n\n${APP_NAME} Environment Ready... execute \"deactivate\" to exit the environment"
