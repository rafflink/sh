# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
source $ZSH/oh-my-zsh.sh
# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
# You may need to manually set your language environment
# export LANG=en_US.UTF-8
# Set proper terminal type for colors and formatting
export TERM=xterm-256color
# Use Powerlevel10k for iTerm2, simpler theme for Cursor
if [[ "$TERM_PROGRAM" == "vscode" ]] || [[ "$TERM_PROGRAM" == "cursor" ]] || [[ -n "$VSCODE_INJECTION" ]]; then 
    export TERM=screen-256color
    export COLORTERM=truecolor
    # Use simpler theme for Cursor
    ZSH_THEME="robbyrussell"
else
    # Use Powerlevel10k for iTerm2 and other terminals
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
# Compilation flags
# export ARCHFLAGS="-arch x86_64"
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/usr/local/bin:$PATH"
# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# --- uv-conda aliases ---
# Mimic conda commands using uv for a faster experience.
# Assumes virtual environments are created in the current directory.
# Usage: uvc-create <env_name> [--python <python_version>]
# Example: uvc-create my-app --python 3.11
uvc-create() {
    if [ -z "$1" ]; then
        echo "Usage: uvc-create <env_name> [--python <python_version>]"
        echo "Example: uvc-create my-app --python 3.11"
        return 1
    fi
    echo "Creating virtual environment '$1'..."
    uv venv "$@"
}
# Usage: uvc-activate <env_name>
uvc-activate() {
    if [ -z "$1" ]; then
        echo "Usage: uvc-activate <env_name>"
        return 1
    fi
    if [ -f "$1/bin/activate" ]; then
        source "$1/bin/activate"
        echo "Activated environment: $1"
    else
        echo "Error: Environment '$1' not found in the current directory."
        return 1
    fi
}
# The 'deactivate' command is available automatically in an active environment.
alias uvc-install='uv pip install'
alias uvc-uninstall='uv pip uninstall'
alias uvc-list='uv pip list'
alias uvc-freeze='uv pip freeze'
# --- end uv-conda aliases ---
# --- uvc help ---
uvc-help() {
    echo "🚀 UVC Commands Help 🚀"
    echo "--------------------------------------------------------------------------------"
    echo "  ✨ uvc-create <env> [--python <ver>]   - Create a virtual environment."
    echo "  ✨ uvc-activate <env>                  - Activate a virtual environment."
    echo "  ✨ uvc-install <pkg>                   - Install a package."
    echo "  ✨ uvc-uninstall <pkg>                 - Uninstall a package."
    echo "  ✨ uvc-list                            - List installed packages."
    echo "  ✨ uvc-freeze                          - Freeze installed packages."
    echo "--------------------------------------------------------------------------------"
}
uvc() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        uvc-help
    else
        echo "uvc is a prefix for custom commands. Available commands are:"
        echo "  uvc-create, uvc-activate, uvc-install, uvc-uninstall, uvc-list, uvc-freeze"
        echo "Run 'uvc --help' for more details."
    fi
}
# Display UVC commands help on new terminal
# uvc-help # Commented out to prevent printing on every shell startup
# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
source $HOME/.local/share/uv/virtualenvs/global/bin/activate
alias j='just'
alias jg='just --global-justfile'
alias vllm-start='vllm-mlx serve mlx-community/Llama-3.2-3B-Instruct-4bit --port 8000'
