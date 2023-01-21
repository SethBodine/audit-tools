#!/bin/sh /usr/bin/source-this-script.sh
# Prep Environment

SCRIPT_PATH="/opt/awsEnum/"
APP_NAME="awsEnum"

#[[ ${VIRTUAL_ENV} ]] && deactivate
if [ ! -z "${VIRTUAL_ENV+x}" ]; then deactivate; fi

cd ${SCRIPT_PATH} || exit #handle for cd failure
. venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt 

printf "\n\n${APP_NAME} Environment Ready... execute \"deactivate\" to exit the environment\n\n"
