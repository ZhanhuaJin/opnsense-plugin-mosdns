#!/usr/local/bin/python3
"""
MosDNS service reconfiguration script
Generates configuration file from template and restarts service
"""

import os
import sys
import subprocess
import tempfile
from configparser import ConfigParser

sys.path.insert(0, '/usr/local/opnsense/site-python')
from opnsense.configd import template

def main():
    """
    Main reconfiguration function
    """
    try:
        # Generate configuration from template
        print("Generating MosDNS configuration...")
        
        # Create config directory if it doesn't exist
        config_dir = '/usr/local/etc/mosdns'
        if not os.path.exists(config_dir):
            os.makedirs(config_dir, mode=0o755)
        
        # Generate configuration file
        template.generate_config_file(
            template_dir='/usr/local/opnsense/service/templates/OPNsense/MosDNS',
            template_file='mosdns.conf',
            target_file='/usr/local/etc/mosdns/config.yaml'
        )
        
        print("Configuration generated successfully.")
        
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