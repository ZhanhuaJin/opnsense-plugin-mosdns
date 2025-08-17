#!/bin/sh

# MosDNS Configuration Generator
# This script generates the MosDNS configuration file from OPNsense settings

CONFIG_FILE="/usr/local/etc/mosdns/config.yaml"
TEMP_CONFIG="/tmp/mosdns_config.yaml.tmp"
CONFIG_DIR="/usr/local/etc/mosdns"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Generate configuration from OPNsense settings
# This is a template configuration that can be customized
cat > "$TEMP_CONFIG" << 'EOF'
log:
  level: info

plugins:
  # Cache plugin
  - tag: cache
    type: cache
    args:
      size: 10240
      lazy_cache_ttl: 86400

  # Redirect plugin for domain redirection
  - tag: redirect
    type: redirect
    args:
      rules:
        # Add your redirect rules here
        # Example: www.example.com example.com.cdn.cloudflare.net

  # Forward to local DNS servers
  - tag: forward_local
    type: forward
    args:
      concurrent: 2
      upstreams:
        - addr: udp://223.5.5.5
        - addr: udp://119.29.29.29

  # Forward to remote DNS servers
  - tag: forward_remote
    type: forward
    args:
      concurrent: 2
      upstreams:
        - addr: udp://8.8.8.8
        - addr: udp://1.1.1.1

  # Hosts plugin for custom host entries
  - tag: hosts
    type: hosts
    args:
      files:
        - "/usr/local/etc/mosdns/hosts"

  # IP set for local/china IPs
  - tag: local_ip
    type: ip_set
    args:
      files:
        - /usr/local/etc/mosdns/china_ip_list.txt

  # Local sequence for fallback
  - tag: local_sequence
    type: sequence
    args:
      - exec: $forward_local
      - matches: "!resp_ip $local_ip"
        exec: accept
      - exec: drop_resp

  # Remote sequence for fallback
  - tag: remote_sequence
    type: sequence
    args:
      - exec: $forward_remote
      - exec: accept

  # Fallback plugin
  - tag: fallback
    type: fallback
    args:
      primary: local_sequence
      secondary: remote_sequence
      threshold: 500
      always_standby: true

  # Main sequence
  - tag: main_sequence
    type: sequence
    args:
      - exec: $hosts
      - matches: has_resp
        exec: accept
      - matches: qtype 65
        exec: reject 3
      - exec: prefer_ipv4
      - exec: $redirect
      - exec: $cache
      - matches: has_resp
        exec: accept
      - exec: $fallback

  # UDP server
  - tag: udp_server
    type: udp_server
    args:
      entry: main_sequence
      listen: :53

  # TCP server
  - tag: tcp_server
    type: tcp_server
    args:
      entry: main_sequence
      listen: :53
EOF

# Move temp config to final location
mv "$TEMP_CONFIG" "$CONFIG_FILE"

# Set proper permissions
chmod 644 "$CONFIG_FILE"
chown root:wheel "$CONFIG_FILE"

echo "MosDNS configuration generated successfully at $CONFIG_FILE"
exit 0