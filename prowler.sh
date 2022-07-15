#!/bin/sh
# Prep Prowler Environment
deactivate
cd /opt/prowler
source venv/bin/activate
pip install --upgrade pip
pip install detect-secrets==1.0.3
