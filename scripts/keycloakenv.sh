#!/usr/bin/env bash

# Prompt for values
read -rp "Enter KEYCLOAK_CLIENT_ID: " KEYCLOAK_CLIENT_ID
read -rp "Enter KEYCLOAK_CLIENT_SECRET: " KEYCLOAK_CLIENT_SECRET

# Create or overwrite the env file
ENV_FILE="/etc/caddy/caddy.env"

# Ensure the directory exists
if [ ! -d "/etc/caddy" ]; then
    echo "Directory /etc/caddy does not exist. Creating..."
    sudo mkdir -p /etc/caddy
fi

# Write values to the file
echo "Writing variables to $ENV_FILE..."
{
    echo "KEYCLOAK_CLIENT_ID=\"$KEYCLOAK_CLIENT_ID\""
    echo "KEYCLOAK_CLIENT_SECRET=\"$KEYCLOAK_CLIENT_SECRET\""
} | sudo tee "$ENV_FILE" > /dev/null

echo "Done. Environment variables saved to $ENV_FILE"
