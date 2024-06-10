#!/bin/bash

# Prompt user for confirmation
confirm() {
    read -r -p "Do you want to proceed with the installation? [Y/n] " response
    if [[ "$response" =~ ^[Yy]$ || -z "$response" ]]; then
        true
    else
        echo "Installation aborted."
        exit 1
    fi
}

# Prompt user for confirmation
confirm

# Add cloudflare gpg key
echo "Adding Cloudflare GPG key..."
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# Add Cloudflare repository to apt sources
echo "Adding Cloudflare repository to apt sources..."
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared jammy main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

# Update package list and install cloudflared
echo "Updating package list and installing Cloudflared..."
sudo apt-get update && sudo apt-get install -y cloudflared

echo "Cloudflared installation complete."