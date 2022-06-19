#!/bin/sh
# Prep ScoutSuite Environmenta
deactivate
cd /opt/ScoutSuite/
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt 
