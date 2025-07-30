# Dockerfile

# 1. Base Image
FROM python:3.9-alpine

# 2. Build‑Time Defaults
ARG APP_PORT=8020
ARG DJANGO_SUPERUSER_USERNAME=admin
ARG DJANGO_SUPERUSER_PASSWORD=admin
ARG DJANGO_SUPERUSER_EMAIL=admin@admin.com

# 3. Install system dependencies for psycopg2, Pillow, cryptography, etc.
RUN apk update && apk add --no-cache \
    build-base \
    musl-dev \
    postgresql-dev \
    jpeg-dev \
    zlib-dev \
    libffi-dev \
    python3-dev

# 4. Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DOCKER_DB_HOST=db \
    DOCKER_DB_PORT=5432 \
    APP_PORT=${APP_PORT} \
    DJANGO_SUPERUSER_USERNAME=admin \
    DJANGO_SUPERUSER_PASSWORD=admin \
    DJANGO_SUPERUSER_EMAIL=admin@admin.com

# 5. Working directory
WORKDIR /app

# 6. Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 7. Copy application code
COPY . .

# 8. Copy entrypoint.sh from local context
COPY entrypoint.sh ./entrypoint.sh

# 9. Make entrypoint executable
RUN chmod +x ./entrypoint.sh

# 10. Expose application port
EXPOSE ${APP_PORT}

# 11. Use entrypoint
ENTRYPOINT ["./entrypoint.sh"]
