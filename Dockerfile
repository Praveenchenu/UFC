FROM python:3.11-slim

# Prevent Python from writing .pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# system deps required to build some python packages and to run libpq
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     build-essential \
     gcc \
     libpq-dev \
     curl \
  && rm -rf /var/lib/apt/lists/*

# Copy and install python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip \
  && pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . .

# Collect static files (ensure settings.py uses env var to toggle)
# (This is optional here — you can also run collectstatic as part of your CI/CD)
# RUN python manage.py collectstatic --noinput

# Expose port used by Gunicorn/Django
EXPOSE 8000

# Use gunicorn to serve the app (adjust module path if your wsgi module differs)
CMD ["gunicorn", "martialarts.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]
