#!/bin/sh
# Prep awsEnum Environment
deactivate
cd /opt/awsEnum
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt 
