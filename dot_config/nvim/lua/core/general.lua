-- set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = "ù"

-- We provide our own Ctrl-hjkl mappings so Rex can participate in navigation.
vim.g.tmux_navigator_no_mappings = true

-- Let Neovim resolve the active Python from PATH (including mise shims).
-- The optional Python provider is disabled gracefully when Python isn't present.
if vim.fn.executable("python3") == 1 then
  vim.g.python3_host_prog = vim.fn.exepath("python3")
end
