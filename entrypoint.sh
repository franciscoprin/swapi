#!/usr/bin/env bash
set -euo pipefail

# Apply database migrations
python manage.py migrate --noinput

# Load initial data fixtures (mirrors Makefile load_data target)
python manage.py loaddata planets.json
python manage.py loaddata people.json
python manage.py loaddata species.json
python manage.py loaddata transport.json
python manage.py loaddata starships.json
python manage.py loaddata vehicles.json
python manage.py loaddata films.json

# Collect static files
python manage.py collectstatic --noinput

# Start server
exec gunicorn swapi.wsgi --bind 0.0.0.0:8000 --log-file -
