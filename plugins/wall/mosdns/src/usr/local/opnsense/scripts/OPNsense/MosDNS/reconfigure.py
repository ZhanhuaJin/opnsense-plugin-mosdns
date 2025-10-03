#!/usr/local/bin/python3
"""
MosDNS service reconfiguration script
Generates configuration file from template and restarts service
"""

import os
import sys
import subprocess
import tempfile
import xml.etree.ElementTree as ET
from configparser import ConfigParser

sys.path.insert(0, '/usr/local/opnsense/site-python')
from opnsense.configd import template

def check_mosdns_config_exists():
    """
    Check if MosDNS configuration exists in /conf/config.xml
    """
    try:
        if not os.path.exists('/conf/config.xml'):
            return False
            
        tree = ET.parse('/conf/config.xml')
        root = tree.getroot()
        
        # Look for OPNsense/MosDNS section
        mosdns_section = root.find('.//OPNsense/MosDNS')
        return mosdns_section is not None
    except Exception as e:
        print(f"Error checking config.xml: {e}")
        return False

def main():
    """
    Main reconfiguration function
    """
    try:
        # Create config directory if it doesn't exist
        config_dir = '/usr/local/etc/mosdns'
        if not os.path.exists(config_dir):
            os.makedirs(config_dir, mode=0o755)
        
        # Check if MosDNS configuration exists in config.xml
        config_exists = check_mosdns_config_exists()
        
        if config_exists:
            # Generate configuration from template
            print("Generating MosDNS configuration from OPNsense settings...")
            template.generate_config_file(
                template_dir='/usr/local/opnsense/service/templates/OPNsense/MosDNS',
                template_file='mosdns.conf',
                target_file='/usr/local/etc/mosdns/config.yaml'
            )
            print("Configuration generated successfully.")
        else:
            # Use existing config.yaml if it exists, otherwise create default
            config_file = '/usr/local/etc/mosdns/config.yaml'
            if os.path.exists(config_file):
                print("No MosDNS configuration found in config.xml, using existing config.yaml")
            else:
                print("No MosDNS configuration found, creating default config.yaml")
                # Create a basic default configuration
                default_config = '''log:
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
'''
                with open(config_file, 'w') as f:
                    f.write(default_config)
                os.chmod(config_file, 0o644)
        
        # Check if MosDNS service is running
        try:
            result = subprocess.run(
                ['/usr/local/bin/mosdns', 'status'],
                capture_output=True,
                text=True,
                timeout=10
            )
            service_running = result.returncode == 0
        except (subprocess.TimeoutExpired, FileNotFoundError):
            service_running = False
        
        # Restart or start the service
        if service_running:
            print("Restarting MosDNS service...")
            subprocess.run(
                ['/usr/local/bin/mosdns', 'restart', '-c', '/usr/local/etc/mosdns/config.yaml'],
                check=True,
                timeout=30
            )
        else:
            print("Starting MosDNS service...")
            subprocess.run(
                ['/usr/local/bin/mosdns', 'start', '-c', '/usr/local/etc/mosdns/config.yaml'],
                check=True,
                timeout=30
            )
        
        print("MosDNS reconfiguration completed successfully.")
        return 0
        
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {e}")
        return 1
    except subprocess.TimeoutExpired:
        print("Command timed out")
        return 1
    except Exception as e:
        print(f"Unexpected error: {e}")
        return 1

if __name__ == '__main__':
    sys.exit(main())