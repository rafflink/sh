#!/bin/bash
set -e # Exit on any error

# Detect OS
OS="$(uname)"

echo "=================================================="

# Install Homebrew if not present (macOS/Linux)
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the rest of the script (Linux or Apple Silicon)
    if [ -d "/opt/homebrew/bin" ]; then
        export PATH="/opt/homebrew/bin:$PATH"
    elif [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew is already installed."
fi


# Install 'uv' if not present
if ! command -v uv &> /dev/null; then
    echo "📦 Installing 'uv' via curl..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "✅ 'uv' is already installed."
fi


# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing 'Oh My Zsh'..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ 'Oh My Zsh' is already installed."
fi

# Install Powerlevel10k theme if not present
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "📦 Installing 'Powerlevel10k' theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "✅ 'Powerlevel10k' is already installed."
fi

echo "🚀 Setting up pi, just, and vllm environment..."
echo "=================================================="

# 1. Install 'just' and 'fd' if not present
install_dependency() {
    local cmd=$1
    if ! command -v "$cmd" &> /dev/null; then
        echo "📦 Installing '$cmd'..."
        if command -v brew &> /dev/null; then
            brew install "$cmd"
        elif command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y "$cmd"
        else
            echo "❌ Error: Package manager not found. Please install '$cmd' manually."
            exit 1
        fi
    else
        echo "✅ '$cmd' is already installed."
    fi
}

install_dependency "just"
# Note: On Ubuntu, 'fd' is often packaged as 'fd-find'. We'll try 'fd' but fallback may be needed by the user.
if [ "$OS" = "Linux" ] && command -v apt-get &> /dev/null; then
    if ! command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
        echo "📦 Installing 'fd-find'..."
        sudo apt-get install -y fd-find
        # Create a symlink if 'fd' doesn't exist
        mkdir -p "$HOME/.local/bin"
        ln -s $(command -v fdfind) "$HOME/.local/bin/fd" || true
    else
        echo "✅ 'fd' is already installed."
    fi
else
    install_dependency "fd"
fi

# 2. Add aliases to shell configs
echo "⚙️  Configuring aliases in shell profiles..."
for rc_file in "$HOME/.zshrc" "$HOME/.zprofile" "$HOME/.bashrc" "$HOME/.bash_profile"; do
    if [ -f "$rc_file" ]; then
        # Add j and jg aliases
        grep -q "alias j='just'" "$rc_file" || echo "alias j='just'" >> "$rc_file"
        grep -q "alias jg='just --global-justfile'" "$rc_file" || echo "alias jg='just --global-justfile'" >> "$rc_file"
        # Add vllm-start alias
        grep -q "alias vllm-start=" "$rc_file" || echo "alias vllm-start='vllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000'" >> "$rc_file"
    fi
done

# 3. Create global justfile with vllm-start recipe
echo "📝 Creating global justfile ($HOME/.justfile)..."
if [ ! -f "$HOME/.justfile" ]; then
    cat > "$HOME/.justfile" << 'JUSTEOF'
vllm-start:
	vllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000
JUSTEOF
else
    echo "✅ $HOME/.justfile already exists. Ensuring vllm-start recipe is present..."
    grep -q "vllm-start:" "$HOME/.justfile" || printf "vllm-start:\n\tvllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000\n" >> "$HOME/.justfile"
fi


# Install 'pi' if not present
if ! command -v pi &> /dev/null; then
    echo "📦 Installing 'pi' globally..."
    # If npm is missing, maybe we should install node first, but let's assume it's there
    if command -v npm &> /dev/null; then
        npm install -g @austingardner/pi
    else
        echo "❌ Error: npm not found. Please install Node.js manually to install pi."
        exit 1
    fi
else
    echo "✅ 'pi' is already installed."
fi


# 4. Clean up legacy pi extension folders to prevent duplicates
echo "🧹 Cleaning up legacy pi extension folders..."
rm -rf "$HOME/.pi/agent/extensions/pi-review-loop"

# 4. Install pi extensions
echo "🧩 Installing pi agent extensions..."
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

if command -v pi &> /dev/null; then
    for ext in "${extensions[@]}"; do
        install_pi_ext "$ext"
    done
else
    echo "⚠️  'pi' is not installed or not in PATH. Skipping extension installation."
    echo "Please install pi first from: https://github.com/austingardner/pi"
fi

echo ""
echo "=================================================="
echo "🎉 Setup Complete!"
echo "=================================================="
echo "Available new commands (after restarting terminal or running source ~/.zshrc):"
echo "  j          - alias for 'just'"
echo "  jg         - alias for 'just --global-justfile'"
echo "  vllm-start - alias to start the vllm mlx server"
echo ""
echo "To use pi, don't forget to export your API key (e.g. export GEMINI_API_KEY='your_key')"
