# Start with Python base
FROM python:3.12-slim AS builder

# Set work folder
WORKDIR /app

# Copy requirements first (helps cache pip)
COPY requirements.txt .

# Install packages
RUN pip install --user --no-cache-dir -r requirements.txt 

FROM python:3.12-slim 

WORKDIR /app 

COPY --from=builder /root/.local /root/.local

COPY . .

RUN apt-get update && apt-get install -y wait-for-it && rm -rf /var/lib/apt/lists/*


EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python manage.py check || exit 1

# Run Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]



