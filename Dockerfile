# Base image with Python 2.7
FROM python:2.7-slim

# Prevent pyc files and enable unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# System dependencies for building wheels and required libs (psycopg2, pylibmc, etc.)
# Note: Debian buster is EOL. Point sources to archive.debian.org and disable validity check.
RUN sed -i -e 's|deb.debian.org|archive.debian.org|g' \
           -e 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list \
 && apt-get -o Acquire::Check-Valid-Until=false update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libpq-dev \
    python-dev \
    libmemcached-dev \
    libsasl2-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

# Install dependencies first for better caching
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /app

# Ensure entrypoint is executable
RUN chmod +x entrypoint.sh

# Expose gunicorn port
EXPOSE 8000

# Default command
CMD ["./entrypoint.sh"]
