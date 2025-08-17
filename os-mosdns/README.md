# OPNsense MosDNS Plugin

This plugin provides a web interface for managing MosDNS DNS forwarder on OPNsense.

## Features

- **Web-based Configuration**: Easy-to-use web interface for configuring MosDNS
- **Service Management**: Start, stop, restart, and monitor MosDNS service
- **YAML Configuration**: Generate MosDNS configuration from web forms
- **Multiple Upstream Support**: Configure multiple DNS upstream servers
- **Plugin Architecture**: Support for MosDNS plugin-based configuration
- **Real-time Monitoring**: View service status and logs
- **Protocol Support**: UDP, TCP, DNS over HTTPS (DoH), DNS over TLS (DoT)

## Installation

### Building the Package

#### Linux Environment
Since OPNsense uses FreeBSD packages, use the provided cross-platform script:

```bash
# Clone the repository
git clone <repository-url>
cd opnsense-plugin-mosdns

# Create the package
./create_package.sh

# Verify the package (optional)
./verify_package.sh
```

#### FreeBSD Environment
```bash
# Build using make
cd os-mosdns
make package
```

### Installing the Package

```bash
# Copy the package to your OPNsense system
scp os-mosdns-*.txz root@opnsense-ip:/tmp/

# Install on OPNsense
pkg add /tmp/os-mosdns-*.txz

# Restart the web interface
configctl webgui restart
```

## Usage

1. Navigate to **Services → MosDNS** in the OPNsense web interface
2. Configure the general settings:
   - Enable the service
   - Set log level
   - Configure listen address and port
3. Add upstream DNS servers
4. Configure plugins as needed
5. Save the configuration
6. Start the MosDNS service

## Configuration

### General Settings
- **Enabled**: Enable/disable the MosDNS service
- **Log Level**: Set logging verbosity (debug, info, warn, error)
- **Listen Address**: IP address to bind to (default: 127.0.0.1)
- **Listen Port**: Port to listen on (default: 53)

### Upstream Servers
Configure one or more upstream DNS servers:
- **Name**: Unique identifier for the upstream
- **Address**: DNS server address (IP:port or URL for DoH/DoT)
- **Type**: Protocol type (UDP, TCP, DoT, DoH)
- **Timeout**: Query timeout in seconds

### Plugins
Configure MosDNS plugins:
- **Tag**: Unique plugin identifier
- **Type**: Plugin type (forward, udp_server, tcp_server, cache, etc.)
- **Args**: Plugin-specific arguments in YAML format

### Advanced Configuration
- **Custom Config**: Additional YAML configuration to append

## File Locations

- **Configuration**: `/usr/local/etc/mosdns/config.yaml`
- **Binary**: `/usr/local/bin/mosdns`
- **Logs**: `/var/log/mosdns.log`
- **RC Script**: `/usr/local/etc/rc.d/mosdns`

## Troubleshooting

1. **Service won't start**: Check the configuration file syntax and logs
2. **Web interface not showing**: Ensure the plugin is properly installed and web server restarted
3. **DNS queries not working**: Verify listen address/port and firewall rules

## Support

For issues related to:
- **MosDNS software**: Visit https://github.com/IrineSistiana/mosdns
- **OPNsense plugin**: Check OPNsense documentation and forums

## License

This plugin is released under the BSD 2-Clause License, same as OPNsense.