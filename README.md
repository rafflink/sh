# Pi Agent & Just Setup Scripts

A set of automated bash scripts to supercharge your terminal with the [Pi Coding Agent](https://github.com/austingardner/pi), `just` command runner, and local AI model support via `vllm-mlx`.

## Scripts Included

### `setup_pi_environment.sh`
The ultimate setup script. It handles:
- Installing `just` and `fd` (required by `pi`) using `brew` or `apt-get`.
- Adding shorthand aliases (`j` for `just`, `jg` for `just --global-justfile`) to your shell profiles (`.zshrc`, `.bashrc`, etc.).
- Adding a `vllm-start` alias to easily boot up an MLX-optimized local AI model (`Llama-3.2-3B-Instruct-4bit`).
- Creating a global `~/.justfile`.
- Installing all the most popular and powerful `pi` community extensions.

**Usage:**
```bash
./setup_pi_environment.sh
```

### `install_pi_extensions.sh`
A standalone script that simply installs the most powerful and popular community extensions for `pi`.

Included extensions:
- `pi-messenger`: Multi-agent communication.
- `pi-web-access`: Web searching and page reading.
- `pi-interactive-shell`: PTY emulation for running interactive commands.
- `pi-agent-teams`: Experimental agent swarms.
- `pi-review-loop`: Automated code review loops.
- `pi-supervisor`: Task supervision and steering.
- `pi-model-switch`: Autonomous model switching.
- `pi-powerline-footer`: Beautiful CLI status bar.
- `pickle-rick-extension`: A fun persona.
- `compound-engineering-pi`: Compound engineering workflows.

**Usage:**
```bash
./install_pi_extensions.sh
```

## Requirements
- macOS or Linux
- The `pi` CLI installed (if running the extension script)
- Either `brew` (macOS) or `apt-get` (Ubuntu/Debian)

## Notes
After running the main setup script, don't forget to restart your terminal or run `source ~/.zshrc` to activate the aliases!

### `.zshrc`
An optimized, cleaned-up ZSH configuration file. It includes:
- `powerlevel10k` theme configuration (with a fallback to `robbyrussell` if you use VSCode/Cursor terminal).
- `uv` and `uvc` helper functions for ultra-fast Python virtual environment management.
- Pre-configured aliases for `just` (`j`, `jg`) and `vllm-start`.
