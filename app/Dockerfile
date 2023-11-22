# Use a multi-stage build for a cleaner image
FROM python:3.8-slim AS builder

WORKDIR /usr/src/app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y build-essential && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Create a virtual environment and install dependencies
RUN python -m venv /venv && \
    /venv/bin/pip install --no-cache-dir -r requirements.txt

# Use a smaller base image for the final image
FROM python:3.8-slim

WORKDIR /usr/src/app

# Copy the virtual environment from the builder stage
COPY --from=builder /venv /venv

# Copy only necessary files
COPY app.py .

# Set up a non-root user
RUN adduser --disabled-password --gecos '' canoe && \
    chown -R canoe /usr/src/app

USER canoe

# Expose the port
EXPOSE 3000

# Command to run the application
CMD ["/venv/bin/python", "app.py"]
