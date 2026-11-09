-- Rex-native helpers and Television pickers. Keeps Rex integrations in Lua
-- rather than installing Python helper scripts into ~/.local/bin.
local M = {}

local TERMINAL = "com.superlogical.terminal"
local SHELL = TERMINAL .. ".shell"
local URL_PATTERN = "https?://[^%s%\"'<>]+"
local REPO_PATTERN = "([%w][%w%-]*)/([%w_.%-]+)"

local function executable(name)
  local search = os.getenv("PATH") or ""
  for dir in search:gmatch("([^:]+)") do
    local candidate = dir .. "/" .. name
    local file = io.open(candidate, "r")
    if file then file:close(); return candidate end
  end
  local home = os.getenv("HOME") or ""
  for _, candidate in ipairs({
    home .. "/.local/share/mise/shims/" .. name,
    home .. "/.local/bin/" .. name,
    "/opt/homebrew/bin/" .. name,
    "/usr/local/bin/" .. name,
    "/home/linuxbrew/.linuxbrew/bin/" .. name,
    "/usr/bin/" .. name,
  }) do
    local file = io.open(candidate, "r")
    if file then file:close(); return candidate end
  end
end

local function clean(value)
  return tostring(value or ""):gsub("[\t\r\n]", " ")
end

local function terminal_text(session_id, block_id)
  local result, err = rex.call(TERMINAL .. ".format", {
    session_id = session_id,
    block_id = block_id,
    args = { format = "text", unwrap = true },
  })
  if result == nil then error(err or "could not read Rex terminal", 0) end
  return result.content or ""
end

local function canonical_url(url)
  local key = url:gsub("^(https?://)([^/]+)", function(scheme, host)
    return scheme:lower() .. host:lower()
  end):gsub("/$", "")
  if key:match("^https?://github%.com/.+%.git$") then key = key:gsub("%.git$", "") end
  return key
end

local function urls_from_text(text)
  local entries, seen = {}, {}
  local function add(url, label)
    while url ~= "" and url:sub(-1):match("[.,;:!?%)%]%}]") do url = url:sub(1, -2) end
    local key = canonical_url(url)
    if url ~= "" and not seen[key] then
      seen[key] = true
      entries[#entries + 1] = url .. "\t" .. clean(label or url)
    end
  end
  for url in text:gmatch(URL_PATTERN) do add(url) end
  local ignored = {
    app = true, apps = true, bin = true, cmd = true, config = true, configs = true,
    docs = true, examples = true, internal = true, lib = true, lua = true,
    node_modules = true, pkg = true, scripts = true, src = true, test = true,
    tests = true, vendor = true,
  }
  for owner, repo in text:gmatch(REPO_PATTERN) do
    if not ignored[owner:lower()] then
      local path = owner .. "/" .. repo:gsub("%.git$", "")
      local quoted = text:find("[\"']" .. path:gsub("([%.%-])", "%%%1") .. "[\"']", 1)
      local git_suffix = text:find(path .. ".git", 1, true)
      local nvim_spec = text:find('"' .. path:gsub("([%.%-])", "%%%1") .. '"', 1)
      if quoted or git_suffix or nvim_spec then
        add("https://github.com/" .. path, path .. "  (GitHub)")
      end
    end
  end
  return table.concat(entries, "\n")
end

local function block_detail(session_id, block_id)
  if not block_id then return "" end
  local title = rex.call(TERMINAL .. ".title", { session_id = session_id, block_id = block_id })
  if title and title.title ~= "" then return clean(title.title) end
  local process = rex.call(TERMINAL .. ".process", { session_id = session_id, block_id = block_id })
  local foreground = process and process.foreground or nil
  if foreground then return clean(foreground.argv0 or foreground.name) end
  return ""
end

local function session_terminal_blocks(session_id)
  local view, err = rex.call("session.view", { session_id = session_id })
  if not view then error(err or "could not read Rex session", 0) end
  local blocks, seen = {}, {}
  for window_index, window in ipairs(view.windows or {}) do
    for layer_index, layer in ipairs(window.layers or {}) do
      for block_index, block in ipairs(layer.blocks or {}) do
        if block.creator_name == TERMINAL and not seen[block.block_id] then
          seen[block.block_id] = true
          blocks[#blocks + 1] = {
            block_id = block.block_id,
            source = clean(window.label or ("Tab " .. window_index))
              .. " / pane " .. block_index .. " / " .. clean(block.label or "terminal"),
          }
        end
      end
    end
  end
  return blocks
end

local function window_rows(session_id)
  if not session_id then return "" end
  local view, err = rex.call("session.view", { session_id = session_id })
  if not view then error(err or "could not read current Rex session", 0) end
  local rows = {}
  for index, window in ipairs(view.windows or {}) do
    rows[#rows + 1] = table.concat({
      window.window_id or "", clean(window.label or ("Tab " .. index)),
      tostring(index), block_detail(session_id, window.focused_block_id),
    }, "\t")
  end
  return table.concat(rows, "\n")
end

local function pane_cwd(block_id)
  if not block_id then return nil end
  local process = rex.call(TERMINAL .. ".process", { block_id = block_id })
  if not process then return nil end
  for _, entry in ipairs({ process.foreground, process.child }) do
    if entry and entry.cwd then return entry.cwd end
  end
end

local function shell_quote(value)
  return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function layout_rects(node, rects)
  if not node then return end
  if node.block_id then
    rects[node.block_id] = node.rect
  elseif node.split then
    layout_rects(node.split.before, rects)
    layout_rects(node.split.after, rects)
  end
end

local function render_window(session_id, window, tab_index, active)
  local width, height = 100, 36
  local canvas, styles = {}, {}
  local function utf8_chars(text)
    local chars, index = {}, 1
    while index <= #text do
      local first = text:byte(index)
      local length = first < 0x80 and 1 or first < 0xE0 and 2 or first < 0xF0 and 3 or 4
      chars[#chars + 1] = text:sub(index, index + length - 1)
      index = index + length
    end
    return chars
  end
  local palette = {
    "\27[38;5;39m", "\27[38;5;214m", "\27[38;5;135m",
    "\27[38;5;42m", "\27[38;5;203m", "\27[38;5;81m",
  }
  local function paint(y, x, text, style)
    local used = 0
    for _, char in ipairs(utf8_chars(text)) do
      if x + used > width then break end
      canvas[y][x + used] = char
      styles[y][x + used] = style
      used = used + 1
    end
  end
  local function ansi_lines(content)
    local lines, line, line_styles = {}, {}, {}
    local current_style = "\27[0m"
    local index = 1
    while index <= #content do
      local byte = content:byte(index)
      if byte == 27 and content:sub(index + 1, index + 1) == "[" then
        local finish = content:find("[@-~]", index + 2)
        if finish then
          local code = content:sub(index + 2, finish - 1)
          if content:sub(finish, finish) == "m" then
            if code == "" or code == "0" then current_style = "\27[0m"
            else current_style = "\27[" .. code .. "m" end
          end
          index = finish + 1
        else index = index + 1 end
      elseif byte == 13 then
        index = index + 1
      elseif byte == 10 then
        lines[#lines + 1] = { text = table.concat(line), styles = line_styles }
        line, line_styles = {}, {}
        index = index + 1
      else
        local first = byte
        local length = first < 0x80 and 1 or first < 0xE0 and 2 or first < 0xF0 and 3 or 4
        local char = content:sub(index, index + length - 1)
        line[#line + 1] = char
        line_styles[#line_styles + 1] = current_style
        index = index + length
      end
    end
    if #line > 0 then lines[#lines + 1] = { text = table.concat(line), styles = line_styles } end
    return lines
  end
  for y = 1, height do
    canvas[y], styles[y] = {}, {}
    for x = 1, width do canvas[y][x] = " " end
  end
  local layer
  for _, candidate in ipairs(window.layers or {}) do
    if candidate.kind == "tiled" then layer = candidate; break end
  end
  if not layer or not layer.layout then return "No tiled layout to preview." end
  local rects = {}
  layout_rects(layer.layout, rects)
  local panes = 0
  for _, block in ipairs(layer.blocks or {}) do
    if block.creator_name == TERMINAL then
      local rect = rects[block.block_id]
      if rect then
        panes = panes + 1
        local x = math.floor((rect[1] or 0) * width) + 1
        local y = math.floor((rect[2] or 0) * height) + 1
        local w = math.max(1, math.floor((rect[3] or 1) * width + 0.5))
        local h = math.max(1, math.floor((rect[4] or 1) * height + 0.5))
        local right, bottom = math.min(width, x + w - 1), math.min(height, y + h - 1)
        local label = clean(block.label or ("Pane " .. panes))
        local focused = block.block_id == window.focused_block_id
        local title = (focused and "* " or "  ") .. label
        paint(y, x, title, palette[(panes - 1) % #palette + 1])
        for col = x, right do
          if y + 1 <= height then canvas[y + 1][col] = "─" end
        end
        local result = rex.call(TERMINAL .. ".format", {
          session_id = session_id, block_id = block.block_id,
          args = { format = "vt", trim = true, unwrap = true },
        })
        local content = (result and result.content) or ""
        local size = rex.call(TERMINAL .. ".size", {
          session_id = session_id, block_id = block.block_id,
        })
        local lines = ansi_lines(content)
        if size and size.rows and size.rows > 0 then
          local screen_rows = math.min(size.rows, #lines)
          for _ = 1, #lines - screen_rows do table.remove(lines, 1) end
        end
        local pane_rows = math.max(0, bottom - y - 1)
        if #lines > pane_rows then
          for _ = 1, #lines - pane_rows do table.remove(lines, 1) end
        end
        for row, line in ipairs(lines) do
          local target_y = y + 1 + row
          if target_y <= bottom then
            local column = 0
            for _, char in ipairs(utf8_chars(line.text)) do
              if x + column > right then break end
              canvas[target_y][x + column] = char
              styles[target_y][x + column] = line.styles[column + 1]
              column = column + 1
            end
          end
        end
      end
    end
  end
  if panes == 0 then return "No terminal panes in this tab." end
  local output = { ("Tab %d: %s%s"):format(
    tab_index, clean(window.label or ("Tab " .. tab_index)), active and " (active)" or ""
  ) }
  for y = 1, height do
    local row, current_style = {}, nil
    for x = 1, width do
      local style = styles[y][x]
      if style ~= current_style then
        row[#row + 1] = style or "\27[0m"
        current_style = style
      end
      row[#row + 1] = canvas[y][x]
    end
    row[#row + 1] = "\27[0m"
    output[#output + 1] = table.concat(row):gsub("%s+$", "")
  end
  return table.concat(output, "\n")
end

local function target_window(view, block_id)
  if not block_id then return nil end
  for _, window in ipairs(view.windows or {}) do
    for _, layer in ipairs(window.layers or {}) do
      for _, block in ipairs(layer.blocks or {}) do
        if block.block_id == block_id then return window end
      end
    end
  end
end

local function open_picker(ctx, tv, channel, extra_env, restore_focus)
  local view, err = rex.session.view{}
  if not view then error(err or "could not read current Rex session", 0) end
  local window = target_window(view, ctx.block_id)
  if not window then error("Rex did not provide a focused pane in the current session", 0) end
  local command = { "env" }
  for key, value in pairs(extra_env or {}) do command[#command + 1] = key .. "=" .. value end
  local restore = restore_focus == false and "" or ("; rex do -s " .. shell_quote(ctx.session_id)
    .. " rex_picker_restore block_id=" .. shell_quote(ctx.block_id))
  local script = tv .. " " .. shell_quote(channel)
    .. "; picker_status=$?" .. restore .. "; exit $picker_status"
  command[#command + 1], command[#command + 2], command[#command + 3] = "sh", "-lc", script
  local layer, layer_err = rex.session.new_layer{
    window_id = window.window_id,
    bounds = { x = 0.08, y = 0.08, w = 0.84, h = 0.84 },
    focus = true,
    layout = rex.layout.block{
      flavor = SHELL,
      options = { command = command, cwd = pane_cwd(ctx.block_id) },
    },
  }
  if not layer then error(layer_err or "could not create Television layer", 0) end
  return { layer_id = layer.layer_id }
end

local function register_actions()
  rex.action{
    name = "rex_picker_restore", title = "Restore the pane that opened Television",
    args = { block_id = "string" },
    run = function(ctx, args)
      local result, err = rex.call("session.focus_block", {
        session_id = ctx.session_id,
        block_id = args.block_id,
      })
      if not result then error(err or "could not restore the original Rex pane", 0) end
      return true
    end,
  }
  rex.action{
    name = "rex_url_source", title = "List URLs for the Television channel",
    run = function(ctx)
      local session_id = os.getenv("REX_URL_SOURCE_SESSION") or ctx.session_id
      local block_id = os.getenv("REX_URL_SOURCE_BLOCK") or ctx.block_id
      if not session_id then return "" end
      local blocks = session_terminal_blocks(session_id)
      if block_id then
        for index, candidate in ipairs(blocks) do
          if candidate.block_id == block_id then
            table.remove(blocks, index)
            table.insert(blocks, 1, candidate)
            break
          end
        end
      end
      local entries, seen = {}, {}
      for _, candidate in ipairs(blocks) do
        for entry in urls_from_text(terminal_text(session_id, candidate.block_id)):gmatch("[^\n]+") do
          local url, label = entry:match("^([^\t]+)\t([^\t]+)")
          local key = url and canonical_url(url)
          if url and not seen[key] then
            seen[key] = true
            entries[#entries + 1] = table.concat({ url, label }, "\t")
          end
        end
      end
      return table.concat(entries, "\n")
    end,
  }
  rex.action{
    name = "rex_url_open", title = "Open a URL selected from Rex",
    args = { url = "string" },
    run = function(_, args)
      local url = args.url
      if not url or not url:match("^https?://") then error("refusing invalid HTTP(S) URL", 0) end
      local command
      if os.getenv("WSL_DISTRO_NAME") then
        command = { "wslview", url }
      else
        local open = executable("open")
        local xdg_open = executable("xdg-open")
        command = open and { open, url } or xdg_open and { xdg_open, url }
      end
      if not command then error("could not find a system browser opener (open or xdg-open)", 0) end
      local result, err = rex.exec(command, { timeout = 20 })
      if not result or not result.ok then error(err or (result and result.stderr) or "browser opener failed", 0) end
      return true
    end,
  }
  rex.action{
    name = "rex_tab_list", title = "List Rex tabs for Television",
    run = function(ctx) return window_rows(ctx.session_id) end,
  }
  rex.action{
    name = "rex_tab_preview", title = "Preview a Rex tab",
    args = { window_id = "string" },
    run = function(ctx, args)
      local session_id = ctx.session_id
      local window_id = args.window_id
      if not session_id then return "Select a terminal tab to preview its contents." end
      local view, err = rex.call("session.view", { session_id = session_id })
      if not view then error(err or "could not read Rex session", 0) end
      for index, window in ipairs(view.windows or {}) do
        if window.window_id == window_id then
          return render_window(session_id, window, index, window.window_id == view.active_window_id)
        end
      end
      error("Rex tab not found in the current session", 0)
    end,
  }
  rex.action{
    name = "rex_tab_select", title = "Select a Rex tab",
    args = { window_id = "string" },
    run = function(ctx, args)
      local clients = rex.call("session.list_clients", { session_id = ctx.session_id }).clients or {}
      for _, client in ipairs(clients) do
        if client.info and client.info.kind == "app" and client.connection_state ~= "lost" then
          local _, err = rex.call("client.perform", {
            client_id = client.client_id,
            action = "session.select",
            args = { session_id = ctx.session_id, window_id = args.window_id },
          })
          if err then error(err, 0) end
          return true
        end
      end
      error("no connected Rex app client can select the tab", 0)
    end,
  }
  rex.action{
    name = "rex_sex_connect", title = "Open a Rex session or directory",
    args = { kind = "string", name = "string", path = "string", session_id = "string" },
    run = function(ctx, args)
      local clients = rex.call("session.list_clients", { session_id = ctx.session_id }).clients or {}
      local client_id
      for _, client in ipairs(clients) do
        if client.info and client.info.kind == "app" and client.connection_state == "connected" then
          client_id = client.client_id
          break
        end
      end
      if not client_id then error("no connected Rex app client can switch sessions", 0) end

      local session_id = args.session_id
      if args.kind == "zoxide" then
        local created, create_err = rex.call("session.create", {
          label = args.name,
          initial_windows = {{
            window_label = "Terminal",
            layout = { block = { flavor = SHELL, options = { cwd = args.path } } },
          }},
        })
        if not created then error(create_err or "could not create Rex session", 0) end
        session_id = created.session_id
      elseif args.kind ~= "rex" then
        error("unsupported sex entry type: " .. tostring(args.kind), 0)
      end
      if not session_id or session_id == "" then error("missing Rex session ID", 0) end
      local _, switch_err = rex.call("client.perform", {
        client_id = client_id,
        action = "session.select",
        args = { session_id = session_id },
      })
      if switch_err then error(switch_err, 0) end
      return true
    end,
  }

  local tv = executable("tv")
  rex.action{
    name = "tv_sex_sessions", title = "Television: Sessions and Directories",
    description = "Browse Rex sessions, sesh sessions, and zoxide directories with sex.",
    category = "Television", keywords = "television tv sex sessions zoxide directories",
    run = function(ctx)
      if not tv then error("Television is unavailable: tv was not found in Rex's PATH", 0) end
      return open_picker(ctx, tv, "sex")
    end,
  }
  rex.action{
    name = "tv_rex_urls", title = "Television: URLs in This Pane",
    description = "Pick an HTTP(S) URL from the current terminal pane and open it in a browser.",
    category = "Television", keywords = "television tv url link browser",
    run = function(ctx)
      if not tv then error("Television is unavailable: tv was not found in Rex's PATH", 0) end
      if not ctx.block_id then error("no terminal pane is focused", 0) end
      return open_picker(ctx, tv, "rex-urls", {
        REX_URL_SOURCE_BLOCK = ctx.block_id,
        REX_URL_SOURCE_SESSION = ctx.session_id or "",
      })
    end,
  }
  rex.action{
    name = "tv_rex_tabs", title = "Television: Rex Tabs",
    description = "Pick, preview, and switch tabs in the current Rex session.",
    category = "Television", keywords = "television tv rex tabs windows",
    run = function(ctx)
      if not tv then error("Television is unavailable: tv was not found in Rex's PATH", 0) end
      return open_picker(ctx, tv, "rex-tabs", nil, false)
    end,
  }
  local lazygit = executable("lazygit")
  if lazygit then
    rex.action{
      name = "rex_lazygit", title = "Open lazygit",
      description = "Open lazygit in a floating layer at this pane's working directory.",
      category = "Rex", keywords = "git lazygit floating popup",
      run = function(ctx)
        local view, err = rex.session.view{}
        if not view then error(err or "could not read current Rex session", 0) end
        local window = target_window(view, ctx.block_id)
        if not window then error("no window to open lazygit in", 0) end
        local layer, layer_err = rex.session.new_layer{
          window_id = window.window_id,
          bounds = { x = 0.08, y = 0.08, w = 0.84, h = 0.84 }, focus = true,
          layout = rex.layout.block{
            flavor = SHELL,
            options = { command = { lazygit }, cwd = pane_cwd(ctx.block_id) },
          },
        }
        if not layer then error(layer_err or "could not create lazygit layer", 0) end
        return { layer_id = layer.layer_id }
      end,
    }
  end

  rex.action{
    name = "rex_last_window",
    title = "Last Rex Window",
    description = "Toggle to the previously active window in this session.",
    category = "Rex",
    keywords = "last previous window tab",
    run = function()
      local view, err = rex.session.view{}
      if not view then error(err or "could not read current Rex session", 0) end
      if not view.active_window_id then error("no active window", 0) end
      local _, focus_err = rex.call("session.focus_previous_window", {
        session_id = view.session_id,
      })
      if focus_err then error(focus_err, 0) end
      return { window_id = view.active_window_id }
    end,
  }

  rex.action{
    name = "rex_new_tab",
    title = "New Rex Tab",
    description = "Open a new shell tab in the current working directory.",
    category = "Rex",
    keywords = "new tab window",
    run = function(ctx)
      local window, err = rex.session.new_window{
        layout = rex.layout.block{
          flavor = SHELL,
          options = { cwd = pane_cwd(ctx.block_id) },
        },
      }
      if not window then error(err or "could not create Rex tab", 0) end
      return { window_id = window.window_id }
    end,
  }

end

function M.setup()
  register_actions()
end

return M
