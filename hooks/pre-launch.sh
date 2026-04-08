#!/bin/bash
set -euo pipefail

# Set up Context7 MCP if API key is provided
if [ -n "${CONTEXT7_API_KEY:-}" ]; then
    echo "Configuring Context7 MCP server..."
    mise exec node@lts -- ctx7 setup --claude --mcp --api-key "$CONTEXT7_API_KEY" -y
fi

# Authenticate with GitHub if not already logged in
if ! gh auth status &>/dev/null; then
    echo "GitHub CLI not authenticated — starting device-flow login..."
    gh auth login
fi

# Configure git to use gh for HTTPS auth and rewrite SSH to HTTPS
gh auth setup-git
git config --global url."https://github.com/".insteadOf "git@github.com:"
