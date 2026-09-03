#!/usr/bin/env bash
echo 
echo "=============== Stopping Microservices DevOps Lab ================"
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
# Check Docker Compose
# ============================================================

if ! docker compose version > /dev/null 2>&1; then
  echo "✗ Docker compose is not available."
  exit 1
fi
echo "✓ Docker compose is available."


# ============================================================
# 2. Check Running Containers
#    If no project containers are running, there is nothing
#    to stop.
# ============================================================

containers=$(docker compose ps -q)

if [[ -z "$containers"  ]]; then 
  echo "No project containers are currently running."
  echo "Application is already stopped."
  exit 0
fi
echo "✓ Running project containers found."

# ============================================================
# 3. Show Services
#    Display the services that will be stopped and ask for
#    user confirmation before shutting down the application.
# ============================================================

services=$(docker compose ps --services)
echo "The following services will be stopped: "
echo "$services"

read -p "Continue? [Y/N]: " answer

# ============================================================
# 4. Shutdown
#    docker compose down stops and removes project containers
#    and networks.
# ============================================================

case "$answer" in
  y|Y)
    echo "Proceeding with shutdown..."
    if ! docker compose down; then
      echo "✗ Failed to shut down the application."
      exit 1
    fi
    echo "✓ Application shut down successfully."
    ;;
  n|N)
    echo "Shutdown cancelled."
    exit 0
    ;;
  *)
    echo "Shutdown cancelled."
    exit 0
    ;;
esac

# ============================================================
# 5. Shutdown Verification
#    Check again to make sure no project containers are
#    still running after the shutdown.
# ============================================================

containers=$(docker compose ps -q)

if [[ -z "$containers"  ]]; then 
  echo "✓ No project containers are currently running."
  echo "✓ Shutdown verification successful."
  exit 0
else
  echo "✗ Shutdown verification failed."
  echo "✗ Some project containers are still running."
  exit 1
fi


