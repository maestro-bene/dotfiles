local opt = vim.opt -- for conciseness

-- Line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true         -- shows absolute line number on cursor line (when relative number is on)

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4     -- 4 spaces for indent width
opt.expandtab = true   -- expand tab to spaces
opt.autoindent = true  -- copy indent from current line when starting new one
opt.smartindent = true -- does the same, except it takes the syntax into account

-- Line wrapping
opt.wrap = false -- disable line wrapping

-- Search settings
opt.ignorecase = false -- ignore case when searching
opt.smartcase = true   -- if you include mixed case in your search, assumes you want case-sensitive

opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"
opt.undofile = true

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- turn on termguicolors for nightfly colorscheme to work
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- Allow backspace on indent, end of line or insert mode start position
opt.backspace = "indent,eol,start"

-- Use system clipboard as default register
-- opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- Turn off swapfile
opt.swapfile = false

-- views can only be fully collapsed with the global statusline
opt.laststatus = 3
