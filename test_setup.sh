#!/bin/bash

# Test setup script for wlog project
# Installs bats testing framework locally

set -euo pipefail

echo "Setting up testing framework..."

# Create test directory
mkdir -p tests

# Install bats locally
if [ ! -d "bats-core" ]; then
    echo "Installing bats testing framework..."
    git clone https://github.com/bats-core/bats-core.git
    ./bats-core/install.sh ./bats
else
    echo "Bats already installed"
fi

echo "Testing framework setup complete!"
echo "Run tests with: ./bats/bin/bats tests/"