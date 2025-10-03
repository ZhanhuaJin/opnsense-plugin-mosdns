#!/bin/sh

# MosDNS Plugin Setup Script
# This script is executed after package installation

echo "Setting up MosDNS plugin..."

# Make scripts executable
chmod +x /usr/local/bin/mosdns
chmod +x /usr/local/etc/rc.d/mosdns
chmod +x /usr/local/opnsense/scripts/OPNsense/MosDNS/generate_config.sh

# Create necessary directories
mkdir -p /usr/local/etc/mosdns
mkdir -p /var/log

# Create default configuration if it doesn't exist
if [ ! -f "/usr/local/etc/mosdns/config.yaml" ]; then
    cat > /usr/local/etc/mosdns/config.yaml << 'EOF'
log:
  level: info
  file: /var/log/mosdns.log

plugins:
  - tag: forward_default
    type: forward
    args:
      upstreams:
        - addr: 8.8.8.8:53
        - addr: 1.1.1.1:53
  - tag: udp_server
    type: udp_server
    args:
      entry: forward_default
      listen: 127.0.0.1:53
  - tag: tcp_server
    type: tcp_server
    args:
      entry: forward_default
      listen: 127.0.0.1:53
EOF
fi

# Set proper permissions
chown root:wheel /usr/local/etc/mosdns/config.yaml
chmod 644 /usr/local/etc/mosdns/config.yaml

# Create log file
touch /var/log/mosdns.log
chown root:wheel /var/log/mosdns.log
chmod 644 /var/log/mosdns.log

echo "MosDNS plugin setup completed."
exit 0