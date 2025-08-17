#!/bin/sh

# MosDNS Plugin Setup Script
# This script sets up the MosDNS plugin environment

CONFIG_DIR="/usr/local/etc/mosdns"
LOG_FILE="/var/log/mosdns.log"
BIN_PATH="/usr/local/bin/mosdns"

echo "Setting up MosDNS plugin environment..."

# Create configuration directory
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
    echo "Created configuration directory: $CONFIG_DIR"
fi

# Set proper permissions for config directory
chown root:wheel "$CONFIG_DIR"
chmod 755 "$CONFIG_DIR"

# Create log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    echo "Created log file: $LOG_FILE"
fi

# Set proper permissions for log file
chown root:wheel "$LOG_FILE"
chmod 644 "$LOG_FILE"

# Check if MosDNS binary exists
if [ ! -f "$BIN_PATH" ]; then
    echo "Warning: MosDNS binary not found at $BIN_PATH"
    echo "Please ensure MosDNS is properly installed"
else
    echo "MosDNS binary found at $BIN_PATH"
fi

# Generate initial configuration if it doesn't exist
if [ ! -f "$CONFIG_DIR/config.yaml" ]; then
    echo "Generating initial configuration..."
    /usr/local/opnsense/scripts/OPNsense/MosDNS/generate_config.sh
fi

echo "MosDNS plugin setup completed successfully"
exit 0