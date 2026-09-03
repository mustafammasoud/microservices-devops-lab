#!/usr/bin/env bash

echo
echo "===================== Microservices Logs ====================="
echo


# ============================================================
# 1. Prerequisites
#    Make sure Docker and Docker Compose are available.
# ============================================================

echo "Checking Prerequisites....."

if ! docker info > /dev/null 2>&1; then
  echo "✗ Docker is not running."
  exit 1
fi
echo "✓ Docker is running."


# ============================================================
# 2. Check Docker Compose
# ============================================================

if ! docker compose version > /dev/null 2>&1; then
  echo "✗ Docker compose is not available."
  exit 1
fi
echo "✓ Docker compose is available."


# ============================================================
# 3. Check Running Containers
#    If no project containers are running, there are no logs to show.
# ============================================================

containers=$(docker compose ps -q)

if [[ -z "$containers"  ]]; then 
  echo "No project containers are currently running."
  echo "Application is already stopped."
  exit 0
fi
echo "✓ Running project containers found."

# ============================================================
# 4. Get Available Services
# ============================================================

echo
echo "Available services:"

services=($(docker compose ps --services))


for i in "${!services[@]}"; do

  echo "$((i + 1))) ${services[$i]}"

done

echo "0) All services"

# ============================================================
# 5. Select and Show Logs
# ============================================================

read -p "Choose a service: " choice


if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
  echo "✗ Invalid input"
  exit 1
fi

if [[ "$choice" -eq 0 ]]; then
    echo "Showing logs for all services..."
    docker compose logs -f

elif [[ "$choice" -lt 1 || "$choice" -gt "${#services[@]}" ]]; then
   echo "✗ Invalid service selection."
   exit 1
else 
    service_index=$((choice - 1))
    selected_service="${services[$service_index]}"
    echo "Showing logs for: $selected_service"
    docker compose logs -f "$selected_service"
fi

