local TERMINAL = "com.superlogical.terminal"

local function forwards_navigation(block_id)
  local view = rex.session.view{}
  for _, window in ipairs(view and view.windows or {}) do
    if window.window_id == view.active_window_id then
      for _, layer in ipairs(window.layers or {}) do
        if layer.kind == "floating" then return true end
      end
    end
  end
  if not block_id then return false end
  local process = rex.block.call(TERMINAL, "process", { block_id = block_id })
  for _, entry in ipairs({ process and process.foreground, process and process.child }) do
    for _, value in ipairs(entry and { entry.name, entry.argv0, entry.path } or {}) do
      local executable = value and (value:match("([^/]+)$") or value):lower()
      if executable == "nvim" or executable == "vim" or executable == "view"
          or executable == "fzf" or executable == "tv" then
        return true
      end
    end
  end
  return false
end

local function bind_smart_pane_key(key, direction)
  local action = "pane_focus_or_forward_" .. direction
  rex.action {
    name = action,
    title = "Navigate Pane or Picker " .. direction,
    run = function(ctx)
      if forwards_navigation(ctx.block_id) then
        rex.client.queue("pane.send_key", { key = key })
      else
        rex.client.queue("pane.focus." .. direction)
      end
    end,
  }
  rex.bind(key, action)
end

local M = {}

function M.setup()
  rex.bind("ctrl+shift+c", "pane.send_key", { key = "cmd+c" })
  rex.bind("ctrl+shift+v", "pane.send_key", { key = "cmd+v" })

  rex.bind("ctrl+q>ctrl+q", "pane.send_key", { key = "ctrl+q" })
  rex.bind("ctrl+q>g", "rex_lazygit")
  rex.bind("ctrl+q>u", "tv_rex_urls")
  rex.bind("ctrl+q>w", "tv_rex_tabs")
  rex.bind("ctrl+q>i", "workrex_dashboard")
  rex.bind("ctrl+q>n", "rex_new_tab")
  rex.bind("ctrl+q>space", "tv_sex_sessions")
  rex.bind("alt+o", "rex_last_window")
  rex.bind("alt+j", "client.tab.move.forward")
  rex.bind("alt+k", "client.tab.move.backward")
  rex.bind("alt+h", "client.tab.previous")
  rex.bind("alt+l", "client.tab.next")

  rex.bind("ctrl+q>e", "pane.split.down")
  rex.bind("ctrl+q>r", "pane.split.right")
  rex.bind("ctrl+q>m", "pane.zoom")
  rex.bind("ctrl+q>x", "pane.close")
  bind_smart_pane_key("ctrl+h", "left")
  bind_smart_pane_key("ctrl+j", "down")
  bind_smart_pane_key("ctrl+k", "up")
  bind_smart_pane_key("ctrl+l", "right")
end

return M
