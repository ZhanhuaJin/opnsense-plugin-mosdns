#!/bin/bash

# OPNsense MosDNS Plugin Package Creator for Linux
# This script creates a FreeBSD package that can be installed on OPNsense

set -e

PLUGIN_NAME="os-mosdns"
PLUGIN_VERSION="5.3.3"
BUILD_DIR="$(pwd)"
PLUGIN_DIR="${BUILD_DIR}/${PLUGIN_NAME}"
PACKAGE_DIR="${BUILD_DIR}/package_build"
PACKAGE_NAME="${PLUGIN_NAME}-${PLUGIN_VERSION}.txz"

echo "Creating OPNsense MosDNS Plugin Package v${PLUGIN_VERSION}"
echo "========================================================"

# Check if plugin directory exists
if [ ! -d "${PLUGIN_DIR}" ]; then
    echo "Error: Plugin directory ${PLUGIN_DIR} not found!"
    exit 1
fi

# Clean and create package build directory
rm -rf "${PACKAGE_DIR}"
mkdir -p "${PACKAGE_DIR}"

# Create package structure
echo "Creating package structure..."
# Copy plugin files to package directory with proper structure
echo "Copying plugin files..."

# Copy files that should go to /usr/local/ (opnsense, etc directories)
if [ -d "${PLUGIN_DIR}/src/opnsense" ]; then
    mkdir -p "${PACKAGE_DIR}/usr/local"
    cp -r "${PLUGIN_DIR}/src/opnsense" "${PACKAGE_DIR}/usr/local/"
fi

if [ -d "${PLUGIN_DIR}/src/etc" ]; then
    mkdir -p "${PACKAGE_DIR}/usr/local"
    cp -r "${PLUGIN_DIR}/src/etc" "${PACKAGE_DIR}/usr/local/"
fi

# Copy files that already have usr/local structure
if [ -d "${PLUGIN_DIR}/src/usr" ]; then
    cp -r "${PLUGIN_DIR}/src/usr" "${PACKAGE_DIR}/"
fi

# Create plist file (file list) using pkg-plist
echo "Creating package file list from pkg-plist..."
cd "${PACKAGE_DIR}"

# Always scan actual files in package directory
echo "Scanning files in package directory..."
find . -type f ! -name '+*' | sed 's|^\./||' | sort > "+CONTENTS"

# Create UCL format manifest (required by FreeBSD pkg)
echo "Creating package manifest..."
cat > "+MANIFEST" << EOF
name: "${PLUGIN_NAME}"
version: "${PLUGIN_VERSION}"
origin: "dns/${PLUGIN_NAME}"
comment: "OPNsense MosDNS Plugin"
desc: "MosDNS is a DNS forwarder with flexible configuration.\nThis plugin provides a web interface for managing MosDNS configuration."
www: "https://github.com/IrineSistiana/mosdns"
maintainer: "opnsense@deciso.com"
prefix: "/usr/local"
arch: "FreeBSD:14:amd64"
categories: ["dns"]
licenses: ["GPLv3"]
flatsize: $(du -sb . | cut -f1)
files: {
EOF

# Add files with checksums to manifest
find . -type f ! -name '+*' | while read file; do
    filepath="${file#./}"
    # Use relative path for FreeBSD pkg compatibility
    checksum=$(sha256sum "$file" | cut -d' ' -f1)
    echo "    \"${filepath}\": \"1\$${checksum}\"," >> "+MANIFEST"
done

# Close the files section
echo "}" >> "+MANIFEST"

# Create post-install script
echo "Creating post-install script..."
cat > "${PACKAGE_DIR}/+POST_INSTALL" << 'EOF'
#!/bin/sh

echo "Setting up MosDNS plugin..."

# Make scripts executable
chmod +x /usr/local/bin/mosdns
chmod +x /usr/local/etc/rc.d/mosdns
chmod +x /usr/local/opnsense/scripts/OPNsense/MosDNS/generate_config.sh
chmod +x /usr/local/opnsense/scripts/OPNsense/MosDNS/setup.sh

# Create necessary directories
mkdir -p /usr/local/etc/mosdns
mkdir -p /var/log

# Set proper permissions
chown root:wheel /usr/local/etc/mosdns/config.yaml
chmod 644 /usr/local/etc/mosdns/config.yaml

# Create log file
touch /var/log/mosdns.log
chown root:wheel /var/log/mosdns.log
chmod 644 /var/log/mosdns.log

echo "MosDNS plugin setup completed."
echo "Please restart the web interface: configctl webgui restart"
EOF

chmod +x "${PACKAGE_DIR}/+POST_INSTALL"

# Create pre-deinstall script
cat > "${PACKAGE_DIR}/+PRE_DEINSTALL" << 'EOF'
#!/bin/sh

echo "Stopping MosDNS service..."

# Stop service if running
if [ -f "/var/run/mosdns.pid" ]; then
    /usr/local/etc/rc.d/mosdns stop || true
fi
EOF

chmod +x "${PACKAGE_DIR}/+PRE_DEINSTALL"

# Create the package using tar with ustar format
echo "Creating package archive..."
cd "${PACKAGE_DIR}"
# Create tar archive with proper FreeBSD pkg format using ustar
# FreeBSD pkg expects ustar format for compatibility
tar --format=ustar -czf "${BUILD_DIR}/${PACKAGE_NAME}" +MANIFEST +POST_INSTALL +PRE_DEINSTALL $(find . -type f ! -name '+*' | sed 's|^\./||')

echo ""
echo "Package created successfully: ${PACKAGE_NAME}"
echo "Package size: $(du -h "${BUILD_DIR}/${PACKAGE_NAME}" | cut -f1)"
echo ""
echo "To install on OPNsense:"
echo "1. Copy ${PACKAGE_NAME} to your OPNsense system"
echo "2. Install: pkg add ${PACKAGE_NAME}"
echo "3. Restart web interface: configctl webgui restart"
echo "4. Access via Services → MosDNS"
echo ""
echo "To uninstall:"
echo "pkg delete ${PLUGIN_NAME}"

# Clean up build directory
rm -rf "${PACKAGE_DIR}"

echo "Build completed successfully!"