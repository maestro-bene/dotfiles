local keymap = vim.keymap -- for conciseness

-- Dashboard
keymap.set("n", "<leader>h", "<CMD>Dashboard<CR>", { desc = "Go Home" })

-- Telescope
local telescope = require("telescope")
local builtin = require("telescope.builtin")

-- Grug-far
keymap.set("n", "<leader>sr",
  '<CMD>lua require("grug-far").open({ prefills = { paths = vim.fn.expand("%"), search = vim.fn.expand("<cword>") } })<CR>',
  { noremap = true, desc = "Replace word (file)" })

keymap.set({ 'n', 'x' }, '<leader>ss', function()
  local search = vim.fn.getreg('/')
  -- surround with \b if "word" search (such as when pressing `*`)
  if search and vim.startswith(search, '\\<') and vim.endswith(search, '\\>') then
    search = '\\b' .. search:sub(3, -3) .. '\\b'
  elseif search and vim.startswith(search, '\\V') then
    search = search:sub(3)
  end
  local inst = require('grug-far').open({
    prefills = {
      search = search,
      paths = vim.fn.expand("%"),
    },
  })
  inst:when_ready(function()
    inst:goto_input('replacement')
  end)
end, { desc = 'grug-far: Search using @/ register value or visual selection' })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('grug-far-keymap', { clear = true }),
  pattern = { 'grug-far' },
  callback = function()
    -- jump back to first input by hitting left arrow in normal mode:
    vim.keymap.set('n', '<left>', function()
      require('grug-far').get_instance(0):goto_first_input()
    end, { buffer = true })
  end,
})

-- LSP Navigation avec Telescope
keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to definition" })
keymap.set("n", "gr", builtin.lsp_references, { desc = "Show references" })
keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Go to implementation" })
keymap.set("n", "gt", builtin.lsp_type_definitions, { desc = "Go to type definition" })

-- Diagnostics avec Telescope
keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Show diagnostics" })

keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
keymap.set("n", "<leader>fm", builtin.man_pages, { desc = "Fuzzy find man pages" })
keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })

-- Symbols avec Telescope
keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })

-- Git avec Telescope
keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Git files" })
keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })

-- Buffers/Tabs
keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
keymap.set("n", "<leader>fo", builtin.vim_options, { desc = "Vim options" })

keymap.set("n", "<leader>cl", telescope.extensions.neoclip.default, { desc = "Neoclip" })
vim.keymap.set("n", "<leader>fn", function()
  telescope.extensions.notify.notify({
    previewer = false,
    layout_strategy = "vertical",
    layout_config = { width = 0.6, height = 0.7 },
    initial_mode = "normal",
  })
end, { desc = "Notifications" })
keymap.set("n", "<leader>cf", telescope.extensions.conflicts.conflicts, { desc = "Git conflicts" })
keymap.set("n", "<leader>fz", telescope.extensions.zoxide.list, { desc = "Fuzzy find Zoxide" })

-- Conform
local conform = require("conform")
keymap.set({ "n", "v" }, "<leader>ft", function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, { desc = "Format file or range (in visual mode)" })
