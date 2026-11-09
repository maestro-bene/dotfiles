-- To see/edit the <leader>, see ./general.lua
local keymap = vim.keymap -- for conciseness

-- GENERAL KEYMAPS

keymap.set("n", "<leader>q", "<CMD>q<CR>", { desc = "Exit buffer" })
keymap.set("n", "<leader>sq", "<CMD>wq<CR>", { desc = "Write and Exit buffer" })
keymap.set("n", "<Esc>", "<CMD>q<CR>", { desc = "Exit buffer" })
keymap.set("n", "!<Esc>", "<CMD>q!<CR>", { desc = "Exit buffer w/o saving" })

keymap.set("n", "<leader><leader>", "<CMD>w!<CR>", { desc = "Save buffer" })

keymap.set("n", "<leader>nh", "<CMD>nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "x", '"_x', { desc = "Deleting single char whitout copying into reg" })

-- Move around selected text up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Append the line below to current line
keymap.set("n", "<leader>j", "mzJ`z")

-- Centering the cursor when moving up/down half a bufr
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "G", "Gzz")

-- Centering the cursor when iterating over search results
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Copy code as a Markdown fence without disturbing the visual selection or cursor
keymap.set("v", "<leader>y", function()
  vim.cmd('normal!"vy')
  local text = vim.fn.getreg('v')
  text = text:gsub("\n$", "")
  local filetype = vim.bo.filetype
  vim.fn.setreg('+', "```" .. filetype .. "\n" .. text .. "\n```")
  vim.notify("Selection copied in system clipboard", vim.log.levels.INFO, { title = "Clipboard" })
end, { desc = "Copy selection wrapped in code block with filetype into system clipboard" })

keymap.set("n", "<leader>y", function()
  local lines    = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local text     = table.concat(lines, "\n")
  local filetype = vim.bo.filetype
  vim.fn.setreg('+', "```" .. filetype .. "\n" .. text .. "\n```")
  vim.notify("Buffer copied in system clipboard", vim.log.levels.INFO, { title = "Clipboard" })
end, { desc = "Copy entier buffer in code block with filetype into system clipboard" })

-- quickfix list commands
keymap.set("n", "<C-k>", "<CMD>cnext<CR>zz")
keymap.set("n", "<C-j>", "<CMD>cprev<CR>zz")
--keymap.set("n", "<leader>qk", "<CMD>lnext<CR>zz")
--keymap.set("n", "<leader>qj", "<CMD>lprev<CR>zz")

-- keymap.set("n", "<leader>sr", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]],
--   { noremap = true, desc = "Replace word (file)" })
keymap.set("n", "<leader>vc", "<CMD>e ~/.config/nvim/<CR>", { desc = "Access nvim config" })

-- Window Management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })

-- Move through Neovim splits first; at a split edge, ask Rex to focus
-- a neighboring block. Outside Rex the edge behavior remains a no-op.
local function navigate_split_or_rex(direction, rex_direction)
  return function()
    local block_id = vim.env.REX_BLOCK
    if block_id == nil or block_id == "" then
      local tmux_command = "TmuxNavigate" .. ({ h = "Left", j = "Down", k = "Up", l = "Right" })[direction]
      if vim.fn.exists(":" .. tmux_command) == 2 then
        vim.cmd(tmux_command)
      else
        vim.cmd.wincmd(direction)
      end
      return
    end

    local previous_window = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(direction)
    if vim.api.nvim_get_current_win() ~= previous_window then
      return
    end

    if vim.fn.executable("rex") ~= 1 then
      return
    end

    local code = string.format(
      'local result = rex.call("session.describe_block", { session_id = os.getenv("REX_SESSION"), block_id = %q }); if result == nil or result.block == nil then return nil end; rex.client.queue("pane.focus." .. %q)',
      block_id,
      rex_direction
    )
    local session = vim.env.REX_SESSION
    if session == nil or session == "" then
      return
    end

    local client_id = vim.env.REX_CLIENT
    if client_id == nil or client_id == "" then
      local clients_json = vim.fn.system({ "rex", "client", "ls", "--json", "-s", session })
      if vim.v.shell_error ~= 0 then
        vim.notify("Could not identify the Rex app client: " .. clients_json, vim.log.levels.WARN)
        return
      end
      local ok, clients = pcall(vim.json.decode, clients_json)
      if ok and clients.clients ~= nil then
        for _, client in ipairs(clients.clients) do
          if client.info ~= nil and client.info.kind == "app" then
            client_id = client.client_id
            break
          end
        end
      end
    end
    if client_id == nil or client_id == "" then
      return
    end

    local output = vim.fn.system({ "rex", "-C", client_id, "do", "-e", code, "--json" })
    if vim.v.shell_error ~= 0 then
      vim.notify("Rex pane navigation failed: " .. output, vim.log.levels.WARN)
    end
  end
end

keymap.set("n", "<c-h>", navigate_split_or_rex("h", "left"), { desc = "Navigate split or pane left" })
keymap.set("n", "<c-j>", navigate_split_or_rex("j", "down"), { desc = "Navigate split or pane down" })
keymap.set("n", "<c-k>", navigate_split_or_rex("k", "up"), { desc = "Navigate split or pane up" })
keymap.set("n", "<c-l>", navigate_split_or_rex("l", "right"), { desc = "Navigate split or pane right" })

keymap.set(
  "n",
  "<C-Right>",
  "<CMD>vertical resize +5<CR>",
  { noremap = true, silent = true, desc = "Add 5 width to current window" }
)
keymap.set(
  "n",
  "<C-Left>",
  "<CMD>vertical resize -5<CR>",
  { noremap = true, silent = true, desc = "Remove 5 width to current window" }
)
keymap.set("n", "<C-Up>", "<CMD>resize +5<CR>",
  { noremap = true, silent = true, desc = "Add 5 height to current window" })
keymap.set(
  "n",
  "<C-Down>",
  "<CMD>resize -5<CR>",
  { noremap = true, silent = true, desc = "Remove 5 height to current window" }
)

-- Easily hit escape in terminal mode.
keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

keymap.set("n", "<leader>sd", "<CMD>lua smart_diff()<CR>",
  { noremap = true, silent = true, desc = "Smart diff within Oil" })

keymap.set("n", "<leader>ds",
  "<CMD>diffthis | vert new | setl bt=nofile bh=wipe noswapfile | silent 0put + | file [clipboard] | diffthis <CR>",
  { noremap = true, silent = true, desc = "Diff with Clipboard content" })

keymap.set({ 'n', 'v' }, '<leader>dn', ']c', { desc = 'Diff next hunk' })
keymap.set({ 'n', 'v' }, '<leader>dp', '<CMD>diffput<CR>', { desc = 'Diff put (current -> other)' })
keymap.set({ 'n', 'v' }, '<leader>do', '<CMD>diffget<CR>', { desc = 'Diff get (other -> current)' })
