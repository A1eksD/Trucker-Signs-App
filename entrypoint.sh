#!/usr/bin/env sh
set -e

echo "Waiting for database at $DOCKER_DB_HOST:$DOCKER_DB_PORT …"
while ! nc -z "$DOCKER_DB_HOST" "$DOCKER_DB_PORT"; do
  sleep 0.1
done

echo "Database is up – running migrations and static collect"

# Migrationen anwenden
python manage.py migrate --noinput

# Static files sammeln
python manage.py collectstatic --noinput

# Superuser anlegen, falls noch nicht vorhanden
python manage.py createsuperuser --noinput \
    --username "$DJANGO_SUPERUSER_USERNAME" \
    --email "$DJANGO_SUPERUSER_EMAIL" || true

echo "Setup complete – starting Gunicorn WSGI server"
exec gunicorn truck_signs_designs.wsgi:application \
    --bind 0.0.0.0:"$APP_PORT" \
    --workers 3
