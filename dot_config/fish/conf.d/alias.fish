#alias clangd='clangd --query-driver=/opt/homebrew/Cellar/open-mpi/4.1.6/bin/mpic++'

#alias loaddb="gupdatedb --localpaths=$HOME --prunepaths=/Volumes --output=$HOME/locatedb"

if command -q python
    alias python3 'python'
    alias pip 'python -m pip'
end

if command -q nvim
    alias vim "nvim"
    alias vnim "nvim"
    alias ivm "nvim"
end

if command -q git
    alias dotfiles='git --git-dir=$HOME/dotfiles --work-tree=$HOME'
end
if command -q nvim
    alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'
end

if command -q podman
    alias docker='podman'
end
