# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝

# =========================
# Logging Control
# =========================

# Log variable: set to 'Log' to enable verbose logging
# See log functions in ~/.config/fish/functions/
set -q LOG
or set -q LOG "Silent"

# =========================
# Homebrew Detection & Setup
# =========================

set -l brew_cmd (command -v brew 2>/dev/null)

if test -n "$brew_cmd"
    set -Ux HOMEBREW_PATH (dirname (dirname $brew_cmd))
    set -Ux HOMEBREW_NO_ENV_HINTS 1
    
    fish_add_path -mp $HOMEBREW_PATH/{bin,sbin}
    log "✅ Homebrew configuré : $HOMEBREW_PATH"
else
    log "❌ Homebrew non détecté"
    log "💡 Installer avec : /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
end

# =========================
# Utils Detection & Setup
# =========================

# Starship
if command -v starship >/dev/null
    function starship_transient_prompt_func
      starship module hostname
      starship module directory
      starship module character
    end
    function starship_transient_rprompt_func
      starship module time
    end
    starship init fish | source
    enable_transience
    set -x STARSHIP_SHELL fish
    log "✅ Starship configuré"
else
    log "❌ Starship non trouvé"
    if test -n "$brew_cmd"
        log "💡 Installer avec : brew install starship"
    else
        log "💡 Installer avec : curl -sS https://starship.rs/install.sh | sh"
    end
end

# Zoxide
if command -v zoxide >/dev/null
    zoxide init fish | source
    log "✅ Zoxide configuré"
else
    log "❌ Zoxide non trouvé"
    if test -n "$brew_cmd"
        log "💡 Installer avec : brew install zoxide"
    else
        log "💡 Installer avec : curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
    end
end

# Bat
if command -v bat >/dev/null
    set -Ux BAT_THEME "Catppuccin Mocha"
    set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"
    log "✅ Bat configuré avec thème Catppuccin Mocha"
else
    log "❌ Bat non trouvé"
    if test -n "$brew_cmd"
        log "💡 Installer avec : brew install bat"
    else
        log "💡 Installer avec votre gestionnaire de paquets (apt install bat / pacman -S bat)"
    end
end

# FZF
if command -v fzf >/dev/null
    if command -v fd >/dev/null
        set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'"
        log "✅ FZF configuré avec fd"
    else
        log "✅ FZF configuré (fd recommandé pour de meilleures performances)"
        if test -n "$brew_cmd"
            log "💡 Installer fd avec : brew install fd"
        end
    end
else
    log "❌ FZF non trouvé"
    if test -n "$brew_cmd"
        log "💡 Installer avec : brew install fzf"
    else
        log "💡 Installer avec votre gestionnaire de paquets ou : git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install"
    end
end

# =========================
# ASDF
# =========================

set -l asdf_configured false

if test -n "$brew_cmd" -a -f "$HOMEBREW_PATH/opt/asdf/libexec/asdf.fish"
    source $HOMEBREW_PATH/opt/asdf/libexec/asdf.fish
    fish_add_path -mp $HOMEBREW_PATH/opt/asdf/libexec/bin
    set asdf_configured true
    log "✅ asdf configuré via Homebrew"
else if test -f ~/.asdf/asdf.fish
    source ~/.asdf/asdf.fish
    set asdf_configured true
    log "✅ asdf configuré (installation directe)"
end

if test $asdf_configured = true
    set -x ASDF_ALWAYS_KEEP_DOWNLOAD false
    
    set -l asdf_shims_dir (test -n "$ASDF_DATA_DIR"; and echo "$ASDF_DATA_DIR/shims"; or echo "$HOME/.asdf/shims")
    test -d $asdf_shims_dir; and fish_add_path -mp $asdf_shims_dir
    
    if not test -f ~/.config/fish/completions/asdf.fish
        asdf completion fish > ~/.config/fish/completions/asdf.fish 2>/dev/null
        log "✅ Complétion asdf générée"
    end
else
    log "❌ asdf non trouvé"
    if test -n "$brew_cmd"
        log "💡 Installer avec : brew install asdf"
    else
        log "💡 Installer avec : git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0"
    end
end

# Language specific (conditional)
if command -v go >/dev/null
    set -Ux GOPATH (go env GOPATH)
    set -Ux GOBIN $GOPATH/bin
    log "✅ GOPATH configuré"
    fish_add_path $GOBIN
end

# =========================
# Neovim & Mason
# =========================

if command -v nvim >/dev/null
    set -Ux EDITOR nvim
    set -Ux GIT_EDITOR nvim
    set -Ux VISUAL nvim
    log "✅ Neovim configuré comme éditeur par défaut"
    
    set -l mason_bin "$HOME/.local/share/nvim/mason/bin"
    if test -d $mason_bin
        fish_add_path -mp $mason_bin
        log "✅ Mason bin ajouté au PATH"
    else
        log "⚠️ Mason bin non trouvé ($mason_bin)"
        log "💡 Installer Mason dans Neovim avec : :Lazy install mason-lspconfig.nvim"
    end
else
    log "❌ Neovim non trouvé"
    if test -n "$brew_cmd"
        log "💡 Installer avec : brew install neovim"
    else
        log "💡 Installer avec votre gestionnaire de paquets ou depuis https://github.com/neovim/neovim/releases"
    end
end

# =========================
# User Scripts & Custom bin paths
# =========================

# User paths (always added)
set -l user_paths $HOME/.local/bin

for path in $user_paths
    if test -d $path
        fish_add_path -mp $path
        log "✅ Path ajouté : $path"
    else
        log "⚠️  Path non trouvé : $path"
    end
end

# =========================
# Environment Variables & User Settings
# =========================

# Fish shell configuration
set -U fish_greeting ""  # disable fish greeting
set -U fish_key_bindings fish_vi_key_bindings
set -U fish_cursor_default block
set -U fish_cursor_insert line
set -Ux BROWSER firefox

source ~/.config/fish/conf.d/abbr.fish
source ~/.config/fish/conf.d/alias.fish

# Locale
set -U LANG en_US.UTF-8
set -U LC_ALL en_US.UTF-8

# Secrets and sensible Environment variables
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
else
    log "⚠️ Secrets file not found"
end
# set -Ux DOCKER_HOST tcp://127.0.0.1:2375  #Useful only if current user not in docker group

# Proxy configuration
set -l proxy_vars HTTP_PROXY HTTPS_PROXY FTP_PROXY http_proxy https_proxy ftp_proxy
for var in $proxy_vars
    # set -x $var http://localhost:3129
    # set -x $var http://localhost:8080
end

set -x NO_PROXY "localhost,127.0.0.1,::1"
set -x no_proxy "localhost,127.0.0.1,::1"
set -Ux LAZYGIT_NEW_DIR_FILE $HOME/.lazygit/newdir

# =========================
# Service Management
# =========================

function start_service_if_needed
    set service_name $argv[1]
    if pgrep -f $service_name > /dev/null
        log "ℹ️ Service: $service_name is already running."
    else
        log "ℹ️ Starting $service_name..."
        log_function sudo service $service_name start
    end
end

# List of services to ensure are running
# set -l services wsl-vpnkit cntlm
set -l services docker

for service in $services
    start_service_if_needed $service
end

# =========================
# SSH Agent
# =========================

# SSH Agent avec Keychain
if command -v keychain >/dev/null
    # Keychain avec options optimisées
    eval (keychain --eval \
        --quiet \
        id_ed25519 id_rsa)
    log "✅ SSH Agent ready via Keychain"
else
    echo "❌ Keychain not found. Install with: brew install keychain"
end

# =========================
# Interactive shell scripts
# =========================

if status is-interactive
    log "🔧 Mode interactif activé"
    # Execute custom scripts only in interactive mode
    # log_function ~/.config/bin/mount_sshfs
end

# =========================
# Configuration finale
# =========================

log "🎯 Configuration Fish terminée"
log "📊 Outils détectés :"
command -v brew >/dev/null; and log "  ✅ Homebrew"
command -v starship >/dev/null; and log "  ✅ Starship"
command -v zoxide >/dev/null; and log "  ✅ Zoxide"
command -v bat >/dev/null; and log "  ✅ Bat"
command -v fzf >/dev/null; and log "  ✅ FZF"
command -v asdf >/dev/null; and log "  ✅ asdf"
command -v nvim >/dev/null; and log "  ✅ Neovim"
command -v keychain >/dev/null; and log "  ✅ Keychain"
