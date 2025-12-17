# ========================
# Builder stage
# ========================
FROM python:3.12-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip \
    && pip wheel --no-cache-dir --no-deps -r requirements.txt

# ========================
# Runtime stage
# ========================
FROM python:3.12-slim

WORKDIR /app

# Copy only built wheels (NO gcc here)
COPY --from=builder /app /app

COPY . .

RUN pip install --no-cache-dir *.whl \
    && rm -rf /root/.cache

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
