-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.scrolloff = 0

    vim.bo.filetype = "terminal"
  end,
})

-- Indentation par langage
local two_spaces = {
  "lua",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "yaml",
  "toml",
  "html",
  "css",
  "scss",
  "markdown",
  "bash",
  "sh",
  "terraform",
  "hcl",
  "ruby",
  "logstash",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = two_spaces,
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- Create file if doesn't exist when writing buffer
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    -- args.match = chemin du buffer (peut être "oil:/..."), args.buf = bufnr
    local name = args.match or vim.api.nvim_buf_get_name(args.buf)
    if name:match("^oil:") then
      return
    end

    local dir = vim.fn.fnamemodify(name, ":p:h")
    if dir ~= "" and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Create and apply logstash filetype
local grp = vim.api.nvim_create_augroup("ft_fix", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = grp,
  pattern = "*.conf",
  callback = function(args)
    local p = vim.api.nvim_buf_get_name(args.buf)
    if p:match("[/\\]logstash[/\\].-%.conf$") then
      vim.bo[args.buf].filetype = "logstash"
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "diff", "oil", "help", "TelescopePrompt", "gitcommit" },
  callback = function()
    if vim.bo.commentstring == "" then
      vim.bo.commentstring = "# %s"
    end
  end,
})
