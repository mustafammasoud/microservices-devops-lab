#!/usr/bin/env bash

echo
echo "===================== Starting Microservices DevOps Lab ====================="
echo

echo "Checking Prerequisites....."

# ============================================================
# Check Docker
# ============================================================

if ! docker info > /dev/null 2>&1; then
    echo "✗ Docker is not running."
    exit 1
fi

echo "✓ Docker is running."


# ============================================================
# Check Docker Compose
# ============================================================

if ! docker compose version > /dev/null 2>&1; then
    echo "✗ Docker Compose is not available."
    exit 1
fi

echo "✓ Docker Compose is available."


# ============================================================
# Check Required Files
# ============================================================

check_file() {

    local file="$1"

    if [[ ! -f "$file" ]]; then
        echo "✗ $file not found."
        return 1
    fi

    echo "✓ $file exists."
    return 0
}


required_files=(
    "docker-compose.yml"
    "nginx/nginx.conf"
    "frontend/Dockerfile"
    "api-gateway/Dockerfile"
    "user-service/Dockerfile"
    "product-service/Dockerfile"
    "order-service/Dockerfile"
)


echo
echo "Checking required files..."

for file in "${required_files[@]}"; do

    if ! check_file "$file"; then
        exit 1
    fi

done


# ============================================================
# Build & Start Application
# ============================================================

echo
echo "Building and starting application..."

if ! docker compose up -d --build; then

    echo "✗ Failed to build or start the application."
    exit 1

fi

echo "✓ Application started."


# ============================================================
# Health Check
# ============================================================

check_health() {

    echo
    echo "Checking services health..."
    echo

    local services
    local health
    local failed=0

    services=$(docker compose ps --services)

    for service in $services; do

        health=$(docker compose ps "$service" --format '{{.Health}}')

        if [[ "$health" == "healthy" ]]; then

            echo "✓ $service : healthy"

        elif [[ "$health" == "starting" ]]; then

            echo "⚠ $service : starting"
            failed=1

        elif [[ "$health" == "unhealthy" ]]; then

            echo "✗ $service : unhealthy"
            failed=1

        else

            echo "⚠ $service : no healthcheck"
            failed=1

        fi

    done

    echo

    if [[ $failed -eq 0 ]]; then

        echo "✓ All services are healthy."
        return 0

    fi

    echo "✗ Some services are not healthy."
    return 1
}


# ============================================================
# Final Health Verification
# ============================================================

if ! check_health; then

    echo
    echo "✗ Application health check failed."
    exit 1

fi


# ============================================================
# Success
# ============================================================

echo
echo "================================================================"
echo "✓ Microservices DevOps Lab is ready!"
echo "================================================================"
echo