#!/bin/bash

# Package verification script for OPNsense MosDNS Plugin
# This script helps verify that the package is properly formatted

PACKAGE_FILE="os-mosdns-5.3.3.txz"

echo "OPNsense MosDNS Package Verification"
echo "===================================="

# Check if package file exists
if [ ! -f "$PACKAGE_FILE" ]; then
    echo "❌ Error: Package file '$PACKAGE_FILE' not found"
    echo "   Please run './create_package.sh' first"
    exit 1
fi

echo "✅ Package file found: $PACKAGE_FILE"
echo "📦 Package size: $(du -h "$PACKAGE_FILE" | cut -f1)"
echo ""

# Check package structure
echo "📋 Checking package structure..."
REQUIRED_FILES=("+MANIFEST" "+POST_INSTALL" "+PRE_DEINSTALL")

for file in "${REQUIRED_FILES[@]}"; do
    if tar -tzf "$PACKAGE_FILE" | grep -q "^$file$"; then
        echo "✅ $file found"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

echo ""
echo "📄 Manifest content:"
echo "-------------------"
tar -xzf "$PACKAGE_FILE" "+MANIFEST" -O
echo ""
echo "-------------------"

echo ""
echo "📁 Package contents (first 10 files):"
echo "------------------------------------"
tar -tzf "$PACKAGE_FILE" | head -10
echo "------------------------------------"

echo ""
echo "✅ Package verification completed successfully!"
echo ""
echo "📋 Installation instructions:"
echo "1. Copy $PACKAGE_FILE to your OPNsense system"
echo "2. Run: pkg add $PACKAGE_FILE"
echo "3. Restart web interface: configctl webgui restart"
echo "4. Access via Services → MosDNS"
echo ""
echo "🔍 If installation fails, check the troubleshooting section in INSTALL_GUIDE.md"