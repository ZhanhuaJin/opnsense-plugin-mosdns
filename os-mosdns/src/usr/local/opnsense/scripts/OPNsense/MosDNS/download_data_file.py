#!/usr/local/bin/python3
"""
MosDNS External Data File Downloader
Downloads data files from specified URLs with backup URL support
"""

import sys
import os
import urllib.request
import urllib.error
import time
import hashlib
from xml.etree import ElementTree as ET

def log_message(message):
    """Log message with timestamp"""
    timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
    print(f"[{timestamp}] {message}")

def get_file_size(file_path):
    """Get file size in human readable format"""
    try:
        size = os.path.getsize(file_path)
        for unit in ['B', 'KB', 'MB', 'GB']:
            if size < 1024.0:
                return f"{size:.1f} {unit}"
            size /= 1024.0
        return f"{size:.1f} TB"
    except:
        return "Unknown"

def update_config_status(uuid, status, last_updated=None, file_size=None):
    """Update the configuration file with download status"""
    try:
        config_path = '/conf/config.xml'
        if not os.path.exists(config_path):
            log_message(f"Config file not found: {config_path}")
            return False
            
        tree = ET.parse(config_path)
        root = tree.getroot()
        
        # Find the external data configuration
        mosdns_node = root.find('.//OPNsense/MosDNS')
        if mosdns_node is None:
            log_message("MosDNS configuration not found")
            return False
            
        external_data_node = mosdns_node.find('external_data')
        if external_data_node is None:
            log_message("External data configuration not found")
            return False
            
        data_files_node = external_data_node.find('data_files')
        if data_files_node is None:
            log_message("Data files configuration not found")
            return False
            
        # Find the specific data file by UUID
        for data_file in data_files_node.findall('data_file'):
            if data_file.get('uuid') == uuid:
                # Update status
                status_node = data_file.find('status')
                if status_node is not None:
                    status_node.text = status
                else:
                    status_elem = ET.SubElement(data_file, 'status')
                    status_elem.text = status
                    
                # Update last_updated if provided
                if last_updated:
                    last_updated_node = data_file.find('last_updated')
                    if last_updated_node is not None:
                        last_updated_node.text = last_updated
                    else:
                        last_updated_elem = ET.SubElement(data_file, 'last_updated')
                        last_updated_elem.text = last_updated
                        
                # Update file_size if provided
                if file_size:
                    file_size_node = data_file.find('file_size')
                    if file_size_node is not None:
                        file_size_node.text = file_size
                    else:
                        file_size_elem = ET.SubElement(data_file, 'file_size')
                        file_size_elem.text = file_size
                        
                # Save the configuration
                tree.write(config_path, encoding='utf-8', xml_declaration=True)
                log_message(f"Updated status for {uuid}: {status}")
                return True
                
        log_message(f"Data file with UUID {uuid} not found")
        return False
        
    except Exception as e:
        log_message(f"Error updating config status: {str(e)}")
        return False

def download_file(url, destination, timeout=30):
    """Download file from URL to destination"""
    try:
        log_message(f"Downloading from: {url}")
        
        # Create a request with user agent
        req = urllib.request.Request(url)
        req.add_header('User-Agent', 'MosDNS-OPNsense/1.0')
        
        # Download the file
        with urllib.request.urlopen(req, timeout=timeout) as response:
            if response.getcode() == 200:
                with open(destination, 'wb') as f:
                    while True:
                        chunk = response.read(8192)
                        if not chunk:
                            break
                        f.write(chunk)
                        
                log_message(f"Successfully downloaded to: {destination}")
                return True
            else:
                log_message(f"HTTP error: {response.getcode()}")
                return False
                
    except urllib.error.URLError as e:
        log_message(f"URL error: {str(e)}")
        return False
    except Exception as e:
        log_message(f"Download error: {str(e)}")
        return False

def main():
    """Main function"""
    if len(sys.argv) != 5:
        log_message("Usage: download_data_file.py <uuid> <filename> <url> <backup_url>")
        sys.exit(1)
        
    uuid = sys.argv[1]
    filename = sys.argv[2]
    url = sys.argv[3]
    backup_url = sys.argv[4]
    
    # Ensure the destination directory exists
    dest_dir = '/usr/local/etc/mosdns'
    if not os.path.exists(dest_dir):
        try:
            os.makedirs(dest_dir, mode=0o755)
            log_message(f"Created directory: {dest_dir}")
        except Exception as e:
            log_message(f"Failed to create directory {dest_dir}: {str(e)}")
            update_config_status(uuid, 'failed')
            sys.exit(1)
            
    destination = os.path.join(dest_dir, filename)
    
    # Update status to downloading
    update_config_status(uuid, 'downloading')
    
    # Try primary URL first
    success = False
    if url and url.strip():
        log_message(f"Attempting download from primary URL for {filename}")
        success = download_file(url, destination)
        
    # Try backup URL if primary failed
    if not success and backup_url and backup_url.strip():
        log_message(f"Primary URL failed, trying backup URL for {filename}")
        success = download_file(backup_url, destination)
        
    # Update final status
    if success:
        file_size = get_file_size(destination)
        current_time = time.strftime('%Y-%m-%d %H:%M:%S')
        update_config_status(uuid, 'success', current_time, file_size)
        log_message(f"Download completed successfully: {filename} ({file_size})")
        sys.exit(0)
    else:
        update_config_status(uuid, 'failed')
        log_message(f"Download failed for {filename}")
        sys.exit(1)

if __name__ == '__main__':
    main()