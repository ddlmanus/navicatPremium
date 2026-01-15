#!/bin/bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
RESET_SCRIPT="$SCRIPT_DIR/reset_navicat_new.sh"
PLIST_PATH="$HOME/Library/LaunchAgents/com.user.navicatreset.plist"
LOG_DIR="$HOME/.gemini"

echo "=========================================="
echo "   Navicat Auto-Reset Installer"
echo "=========================================="

# Check if reset script exists
if [ ! -f "$RESET_SCRIPT" ]; then
    echo "Error: reset_navicat_new.sh not found in $SCRIPT_DIR"
    exit 1
fi

# Make reset script executable
chmod +x "$RESET_SCRIPT"
echo "✓ Set executable permissions for reset script"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Generate Plist content with dynamic path
echo "✓ Generating LaunchAgent configuration..."
cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.navicatreset</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$RESET_SCRIPT</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>0</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$LOG_DIR/navicat_reset.log</string>
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/navicat_reset.err</string>
</dict>
</plist>
EOF

echo "✓ Created plist at: $PLIST_PATH"

# Reload LaunchAgent
echo "✓ Registering background service..."
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "=========================================="
echo "✓ Installation Complete!"
echo "The reset script will run automatically every night at 00:00."
echo "=========================================="
