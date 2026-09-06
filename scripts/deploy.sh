#!/usr/bin/env bash

echo
echo "===================== Microservices Deployment ====================="
echo

# ============================================================
# 1. Validate Environment
#    Make sure the required tools and project environment
#    are ready before starting the deployment.
# ============================================================

echo "Checking Deployment Prerequisites....."

if ! docker info > /dev/null 2>&1; then
  echo "✗ Docker is not running."
  exit 1
fi

echo "✓ Docker is running."

if ! docker compose version > /dev/null 2>&1; then
  echo "✗ Docker Compose is not available."
  exit 1
fi

echo "✓ Docker Compose is available."

if ! git --version > /dev/null 2>&1; then
  echo "✗ Git is not available."
  exit 1
fi

echo "✓ Git is available."

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "✗ Current directory is not a Git repository."
  exit 1
fi

echo "✓ Git repository detected."


# ============================================================
# 2. Git Safety Checks
#    Make sure deployment is performed from a clean and
#    expected Git state before pulling new changes.
# ============================================================

git_status=$(git status --porcelain)

if [[ -z "$git_status" ]]; then
  echo "✓ Git working tree is clean."
else
  echo "✗ Git working tree has uncommitted changes."
  exit 1
fi


current_branch=$(git branch --show-current)

if [[ -z "$current_branch" ]]; then
  echo "✗ Unable to determine current Git branch."
  exit 1
fi

echo "✓ Current branch: $current_branch"

if [[ "$current_branch" != "main" ]]; then
  echo "✗ Deployment must be run from the main branch."
  exit 1
fi

echo "✓ Deployment branch confirmed: main."


remote="origin"

if ! git remote get-url "$remote" > /dev/null 2>&1; then
  echo "✗ Git remote 'origin' is not configured."
  exit 1
fi

remote_url=$(git remote get-url "$remote")

if [[ -z "$remote_url" ]]; then
  echo "✗ Unable to retrieve Git remote URL."
  exit 1
fi

echo "✓ Git remote URL: $remote_url"


# ============================================================
# 3. Pull Latest Changes
#    Synchronize the local repository with the latest
#    changes from the main branch on the remote repository.
# ============================================================

if ! git pull origin main; then
  echo "✗ Failed to pull latest changes."
  exit 1
fi

echo "✓ Latest changes pulled successfully."


# ============================================================
# 4. Build Docker Images
#    Build or rebuild the Docker images using the current
#    project configuration and source code.
# ============================================================

if ! docker compose build; then
  echo "✗ Failed to build Docker images."
  exit 1
fi

echo "✓ Docker images built successfully."


# ============================================================
# 5. Start Services
#    Start the application services in detached mode using
#    the existing Docker Compose configuration.
# ============================================================

if ! docker compose up -d; then
  echo "✗ Failed to start services."
  exit 1
fi

echo "✓ Services started successfully."


# ============================================================
# 6. Deployment Verification
#    Read the health status reported by Docker Compose and
#    verify that all project services are healthy.
# ============================================================

services=($(docker compose ps --services))

all_healthy=true

for service in "${services[@]}"; do

  health=$(docker compose ps "$service" --format '{{.Health}}')

  if [[ "$health" != "healthy" ]]; then
    all_healthy=false
    echo "✗ $service is not healthy."
  fi

  echo "$service: $health"

done


# ============================================================
# 7. Final Deployment Status
#    Return a clear exit code so humans and CI/CD pipelines
#    can determine whether the deployment succeeded.
# ============================================================

if [[ "$all_healthy" == "true" ]]; then
  echo "✓ All services are healthy."
  echo "✓ Deployment completed successfully."
  exit 0
else
  echo "✗ Deployment verification failed."
  exit 1
fi

