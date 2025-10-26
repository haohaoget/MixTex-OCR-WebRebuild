# Multi-stage build supporting linux/amd64 and linux/arm64
FROM node:18-alpine AS frontend-builder

# Set working directory
WORKDIR /app/frontend

# Copy frontend dependency files
COPY web-frontend/package*.json ./

# Install frontend dependencies
RUN npm ci

# Copy frontend source code
COPY web-frontend/ ./

# Build frontend
RUN npm run build

# Python backend build stage
FROM python:3.9-slim AS backend

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy backend dependency files
COPY webapi/requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend source code
COPY webapi/ ./

# Copy build artifacts from frontend build stage
COPY --from=frontend-builder /app/frontend/dist ./static

# Create model directory
RUN mkdir -p /app/model

# Model files should be mounted as volume at runtime
# COPY model/ /app/model/  # Uncomment for local builds with model files

# Set environment variables
ENV PYTHONPATH=/app
ENV HOST=0.0.0.0
ENV PORT=8000

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Start command
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
