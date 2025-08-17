#!/usr/bin/env python3
"""
MosDNS External Data File Download Script
Downloads external data files for MosDNS with fallback support
"""

import sys
import os
import requests
import yaml
import time
import argparse
from datetime import datetime
from pathlib import Path

# Configuration
CONFIG_FILE = '/usr/local/etc/mosdns/external.yaml'
DATA_DIR = '/usr/local/etc/mosdns/data'
TIMEOUT = 30
RETRY_COUNT = 3
RETRY_DELAY = 2

def log_message(message):
    """Log message with timestamp"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print(f"[{timestamp}] {message}")

def load_config():
    """Load configuration from YAML file"""
    try:
        if os.path.exists(CONFIG_FILE):
            with open(CONFIG_FILE, 'r', encoding='utf-8') as f:
                return yaml.safe_load(f) or {}
        return {}
    except Exception as e:
        log_message(f"Error loading config: {e}")
        return {}

def save_config(config):
    """Save configuration to YAML file"""
    try:
        # Ensure config directory exists
        os.makedirs(os.path.dirname(CONFIG_FILE), exist_ok=True)
        
        with open(CONFIG_FILE, 'w', encoding='utf-8') as f:
            yaml.dump(config, f, default_flow_style=False, allow_unicode=True)
        return True
    except Exception as e:
        log_message(f"Error saving config: {e}")
        return False

def download_file(url, filepath, timeout=TIMEOUT):
    """Download file from URL with retry logic"""
    for attempt in range(RETRY_COUNT):
        try:
            log_message(f"Downloading from {url} (attempt {attempt + 1}/{RETRY_COUNT})")
            
            response = requests.get(url, timeout=timeout, stream=True)
            response.raise_for_status()
            
            # Ensure data directory exists
            os.makedirs(os.path.dirname(filepath), exist_ok=True)
            
            with open(filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    if chunk:
                        f.write(chunk)
            
            # Get file size
            file_size = os.path.getsize(filepath)
            log_message(f"Download completed: {filepath} ({file_size} bytes)")
            return True, file_size
            
        except requests.exceptions.RequestException as e:
            log_message(f"Download failed (attempt {attempt + 1}): {e}")
            if attempt < RETRY_COUNT - 1:
                time.sleep(RETRY_DELAY)
            continue
        except Exception as e:
            log_message(f"Unexpected error: {e}")
            break
    
    return False, 0

def update_file_status(uuid, status, last_updated=None, file_size=None):
    """Update file status in configuration"""
    config = load_config()
    
    if 'data_files' not in config:
        config['data_files'] = {}
    
    if uuid not in config['data_files']:
        config['data_files'][uuid] = {}
    
    config['data_files'][uuid]['status'] = status
    
    if last_updated:
        config['data_files'][uuid]['last_updated'] = last_updated
    
    if file_size is not None:
        config['data_files'][uuid]['file_size'] = file_size
    
    save_config(config)

def main():
    """Main download function"""
    parser = argparse.ArgumentParser(description='MosDNS External Data File Download Script')
    parser.add_argument('uuid', help='File UUID')
    parser.add_argument('filename', help='Target filename')
    parser.add_argument('primary_url', help='Primary download URL')
    parser.add_argument('backup_url', help='Backup download URL')
    parser.add_argument('--update', action='store_true', help='Update existing files only if newer version available')
    parser.add_argument('--force-update', action='store_true', help='Force update all files regardless of version')
    
    args = parser.parse_args()
    
    uuid = args.uuid
    filename = args.filename
    primary_url = args.primary_url
    backup_url = args.backup_url
    
    filepath = os.path.join(DATA_DIR, filename)
    
    # Check if file exists and handle update modes
    if args.update and os.path.exists(filepath):
        log_message(f"File {filename} already exists, checking if update needed")
        # For update mode, we could add version checking logic here
        # For now, skip if file exists
        log_message(f"Skipping {filename} - file already exists")
        sys.exit(0)
    elif not args.force_update and not args.update and os.path.exists(filepath):
        log_message(f"File {filename} already exists, use --force-update to overwrite")
        sys.exit(0)
    
    log_message(f"Starting download for {filename} (UUID: {uuid})")
    
    # Update status to downloading
    update_file_status(uuid, 'downloading')
    
    # Try primary URL first
    success, file_size = download_file(primary_url, filepath)
    
    # If primary fails, try backup URL
    if not success and backup_url and backup_url.strip():
        log_message("Primary URL failed, trying backup URL")
        success, file_size = download_file(backup_url, filepath)
    
    # Update final status
    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    if success:
        update_file_status(uuid, 'completed', current_time, file_size)
        action = "force updated" if args.force_update else ("updated" if args.update else "downloaded")
        log_message(f"Download {action} successfully: {filename}")
        sys.exit(0)
    else:
        update_file_status(uuid, 'failed', current_time)
        log_message(f"Download failed: {filename}")
        sys.exit(1)

if __name__ == '__main__':
    main()