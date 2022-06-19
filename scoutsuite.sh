#!/bin/sh
# Prep ScoutSuite Environment
deactivate
cd /opt/ScoutSuite/
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt 
