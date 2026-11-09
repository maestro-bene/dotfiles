local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

vim.cmd([[command! -nargs=0 GoToCommand :Telescope commands]])
vim.cmd([[command! -nargs=0 GoToFile :Telescope find_files]])
vim.cmd([[command! -nargs=0 Grep :Telescope live_grep]])
vim.cmd([[command! -nargs=0 SmartGoTo :Telescope smart_goto]])
vim.o.cursorlineopt = "number"

require("lazy").setup({
  { import = "maestro-bene.plugins" },
  { import = "maestro-bene.plugins.lsp" },
  { import = "maestro-bene.plugins.theme" },
  { import = "maestro-bene.plugins.ui" },
  { import = "maestro-bene.plugins.navigation" },
  { import = "maestro-bene.plugins.completion" },
  { import = "maestro-bene.plugins.diagnostics" },
  { import = "maestro-bene.plugins.editing-utils" },
  { import = "maestro-bene.plugins.git" },
  { import = "maestro-bene.plugins.ai" },
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  git = {
    timeout = 600, -- secondes (ex: 10 min)
  },
  ui = { border = "rounded" },
})

local target_file = vim.fn.expand("~/.local/share/nvim/lazy/codecompanion.nvim/lua/codecompanion/adapters/ollama.lua")
local line_to_modify = 30
local stored_line_content = nil

local function get_line_content()
  local lines = vim.fn.readfile(target_file)
  if lines and #lines >= line_to_modify then
    return lines[line_to_modify]
  end
  return nil
end

local function remove_line()
  stored_line_content = get_line_content()
  if stored_line_content then
    local lines = vim.fn.readfile(target_file)
    table.remove(lines, line_to_modify)
    vim.fn.writefile(lines, target_file)
  end
end

local function restore_line()
  if stored_line_content then
    local lines = vim.fn.readfile(target_file)
    table.insert(lines, line_to_modify, stored_line_content)
    vim.fn.writefile(lines, target_file)
  end
end

vim.api.nvim_create_user_command("LazySyncWithLine", function()
  remove_line()
  vim.cmd("Lazy sync")
  restore_line()
end, {})
