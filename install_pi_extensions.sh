#!/bin/bash
set -e # Exit on any error

echo "=================================================="
echo "🧩 Installing pi extensions..."
echo "=================================================="

# Check if pi is installed
if ! command -v pi &> /dev/null; then
    echo "❌ Error: 'pi' command not found. Please install the pi agent first."
    exit 1
fi

extensions=(
  "git:github.com/nicobailon/pi-messenger"
  "git:github.com/nicobailon/pi-web-access"
  "git:github.com/nicobailon/pi-interactive-shell"
  "git:github.com/tmustier/pi-agent-teams"
  "git:github.com/nicobailon/pi-review-loop"
  "git:github.com/galz10/pickle-rick-extension"
  "git:github.com/nicobailon/pi-powerline-footer"
  "git:github.com/nicobailon/pi-model-switch"
  "git:github.com/tintinweb/pi-supervisor"
  "git:github.com/gvkhosla/compound-engineering-pi"
)

install_pi_ext() {
    echo "   -> Installing $1"
    pi install "$1"
}

for ext in "${extensions[@]}"; do
  install_pi_ext "$ext"
done

echo ""
echo "✅ All extensions installed!"
echo "Current installed extensions:"
pi list
