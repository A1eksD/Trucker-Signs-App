# Dockerfile

# 1. Base Image
FROM python:3.9-slim

# 2. Build‑Time Defaults
ARG APP_PORT=8020
ARG DJANGO_SUPERUSER_USERNAME=admin
ARG DJANGO_SUPERUSER_PASSWORD=admin
ARG DJANGO_SUPERUSER_EMAIL=admin@admin.com

# 3. System‑Dependencies installieren
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    netcat-openbsd \
  && rm -rf /var/lib/apt/lists/*

# 4. Environment‑Variablen (Runtime)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DOCKER_DB_HOST=db \
    DOCKER_DB_PORT=5432 \
    APP_PORT=${APP_PORT} \
    DJANGO_SUPERUSER_USERNAME=${DJANGO_SUPERUSER_USERNAME} \
    DJANGO_SUPERUSER_PASSWORD=${DJANGO_SUPERUSER_PASSWORD} \
    DJANGO_SUPERUSER_EMAIL=${DJANGO_SUPERUSER_EMAIL}

# 5. Arbeitsverzeichnis setzen
WORKDIR /app

# 6. Python‑Dependencies installieren
COPY requirements.txt . 
RUN pip install --no-cache-dir -r requirements.txt

# 7. Applikationscode kopieren
COPY . .

# 8. Entrypoint‑Skript kopieren und ausführbar machen
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 9. Port freigeben
EXPOSE ${APP_PORT}

# 10. Entrypoint definieren
ENTRYPOINT ["./entrypoint.sh"]
