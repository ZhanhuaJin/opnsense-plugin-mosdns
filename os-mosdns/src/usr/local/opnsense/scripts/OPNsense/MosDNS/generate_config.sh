#!/bin/sh

# MosDNS Configuration Generator Script
# This script generates the MosDNS configuration file from the OPNsense template

CONFIG_DIR="/usr/local/etc/mosdns"
CONFIG_FILE="${CONFIG_DIR}/config.yaml"
TEMPLATE_DIR="/usr/local/opnsense/service/templates/OPNsense/MosDNS"
TEMPLATE_FILE="${TEMPLATE_DIR}/mosdns.conf"

# Create config directory if it doesn't exist
if [ ! -d "${CONFIG_DIR}" ]; then
    mkdir -p "${CONFIG_DIR}"
    chmod 755 "${CONFIG_DIR}"
fi

# Generate configuration from template
if [ -f "${TEMPLATE_FILE}" ]; then
    /usr/local/opnsense/scripts/OPNsense/Helpers/template_runner.py \
        --template "${TEMPLATE_FILE}" \
        --target "${CONFIG_FILE}" \
        --backup
    
    if [ $? -eq 0 ]; then
        echo "Configuration file generated successfully: ${CONFIG_FILE}"
        chmod 644 "${CONFIG_FILE}"
    else
        echo "Error: Failed to generate configuration file"
        exit 1
    fi
else
    echo "Error: Template file not found: ${TEMPLATE_FILE}"
    exit 1
fi

exit 0