# Dockerfile

# 1. Base Image
FROM python:3.9-slim

# 2. System‑Dependencies installieren
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    netcat-openbsd \
  && rm -rf /var/lib/apt/lists/*

# 3. Environment‑Variablen (Runtime)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DOCKER_DB_HOST=db \
    DOCKER_DB_PORT=5432 \
    APP_PORT=8020 \
    DJANGO_SUPERUSER_USERNAME=admin \
    DJANGO_SUPERUSER_PASSWORD=admin \
    DJANGO_SUPERUSER_EMAIL=admin@admin.com

# 4. Arbeitsverzeichnis setzen
WORKDIR /app

# 5. Python‑Dependencies installieren
COPY requirements.txt . 
RUN pip install --no-cache-dir -r requirements.txt

# 6. Entrypoint‑Skript und Applikationscode kopieren
COPY entrypoint.sh /app/entrypoint.sh
COPY . .

# 7. Entrypoint‑Skript ausführbar machen
RUN chmod +x /app/entrypoint.sh

# 8. Port freigeben
EXPOSE ${APP_PORT}

# 9. Entrypoint definieren
ENTRYPOINT ["./entrypoint.sh"]