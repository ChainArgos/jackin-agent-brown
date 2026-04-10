#!/bin/bash
set -euo pipefail

# Derive POSTGRESQL_DB_HOST from the DinD sidecar hostname so Gradle build
# files can connect to PostgreSQL running inside docker-compose.
# TODO: Replace with JACKIN_DIND_HOSTNAME once jackin-project/jackin#32 lands.
if [ -n "${JACKIN_DIND_HOSTNAME:-}" ]; then
    export POSTGRESQL_DB_HOST="$JACKIN_DIND_HOSTNAME"
elif [ -n "${DOCKER_HOST:-}" ]; then
    export POSTGRESQL_DB_HOST
    POSTGRESQL_DB_HOST="$(echo "$DOCKER_HOST" | sed 's|tcp://||;s|:.*||')"
fi

# Set up Context7 MCP if API key is provided
if [ -n "${CONTEXT7_API_KEY:-}" ]; then
    echo "Configuring Context7 MCP server..."
    mise exec node@lts -- ctx7 setup --claude --mcp --api-key "$CONTEXT7_API_KEY" -y
fi
