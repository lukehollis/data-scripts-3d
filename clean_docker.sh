#!/bin/bash

# Set up logging with timestamps
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Stop all running containers
log "Stopping all running containers..."
CONTAINERS_STOPPED=$(docker stop $(docker ps -a -q 2>/dev/null) 2>/dev/null)
if [ -n "$CONTAINERS_STOPPED" ]; then
    log "Stopped containers: $CONTAINERS_STOPPED"
else
    log "No running containers found"
fi

# Remove all containers
log "Removing all containers..."
CONTAINERS_REMOVED=$(docker rm $(docker ps -a -q 2>/dev/null) 2>/dev/null)
if [ -n "$CONTAINERS_REMOVED" ]; then
    log "Removed containers: $CONTAINERS_REMOVED"
else
    log "No containers to remove"
fi

# Remove all images
log "Removing all images..."
IMAGES_REMOVED=$(docker rmi $(docker images -q 2>/dev/null) -f 2>/dev/null)
if [ -n "$IMAGES_REMOVED" ]; then
    log "Removed images: $IMAGES_REMOVED"
else
    log "No images to remove"
fi

# Remove all volumes
log "Removing all volumes..."
VOLUMES_REMOVED=$(docker volume rm $(docker volume ls -q 2>/dev/null) 2>/dev/null)
if [ -n "$VOLUMES_REMOVED" ]; then
    log "Removed volumes: $VOLUMES_REMOVED"
else
    log "No volumes to remove"
fi

# Remove all networks
log "Removing all networks..."
NETWORKS_REMOVED=$(docker network rm $(docker network ls -q 2>/dev/null) 2>/dev/null)
if [ -n "$NETWORKS_REMOVED" ]; then
    log "Removed networks: $NETWORKS_REMOVED"
else
    log "No networks to remove"
fi

# System prune
log "Performing system prune..."
docker system prune -a --volumes -f

log "Docker cleanup completed!"
