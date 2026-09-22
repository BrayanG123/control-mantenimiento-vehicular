#!/bin/bash
set -e
cd /home/site/wwwroot
export PYTHONPATH=/home/site/wwwroot
exec gunicorn -w 2 -k uvicorn.workers.UvicornWorker app.main:app --bind 0.0.0.0:8000 --timeout 120
