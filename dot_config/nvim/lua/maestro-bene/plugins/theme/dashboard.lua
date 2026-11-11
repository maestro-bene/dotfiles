return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    -- Helpers to change directories based on the selected scope
    local function cd_to(path)
      if path and #path > 0 then
        vim.cmd("cd " .. vim.fn.fnameescape(path))
      end
    end

    -- Extract the first directory below the base path.
    -- Example: base="~/dev", file="~/dev/acme/app/src/main.go" -> cd "~/dev/acme"
    local function cd_first_after_base(base, file)
      local b = vim.fn.expand(base)
      local f = vim.fn.fnamemodify(file, ":p")
      if not vim.startswith(f, b .. "/") then
        return
      end
      local rest = f:sub(#b + 2) -- Skip "b/"
      local first = rest:match("([^/]+)")
      if first then
        cd_to(b .. "/" .. first)
      end
    end

    -- Telescope wrapper: open the selection, then optionally change directories
    local function picker_with_cd(picker, opts, cd_action)
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      opts = opts or {}
      opts.attach_mappings = function(prompt_bufnr, map)
        local function open_and_maybe_cd()
          local sel = action_state.get_selected_entry()
          actions.select_default(prompt_bufnr) -- Open the file
          if sel and sel.path and cd_action then
            cd_action(sel.path)
          end
        end
        map("i", "<CR>", open_and_maybe_cd)
        map("n", "<CR>", open_and_maybe_cd)
        return true
      end

      builtin[picker](opts)
    end

    -- Directory navigation
    vim.api.nvim_create_user_command("Zoxide", function()
      require("telescope").extensions.zoxide.list()
    end, { desc = "Fuzzy find zoxide list" })

    -- Recent files (no special directory change)
    vim.api.nvim_create_user_command("RecentHere", function()
      picker_with_cd("oldfiles", { cwd_only = false }, nil)
    end, { desc = "Recent files (no special directory change)"})

    -- Find files in any location (no special directory change)
    vim.api.nvim_create_user_command("FilesHere", function()
      picker_with_cd("find_files", { hidden = true, follow = true }, nil)
    end, { desc = "Find files (no special directory change)"})

    -- Scope: ~/.config -> change to the first directory below ~/.config
    vim.api.nvim_create_user_command("FilesConfig", function()
      picker_with_cd(
        "find_files",
        { cwd = vim.fn.expand("~/.config"), hidden = true, follow = true },
        function(path)
          cd_first_after_base("~/.config", path)
        end
      )
    end, { desc = "Find files in ~/.config and change to the first subdirectory"})

    -- Scope: ~/.config/nvim -> use the same rule as ~/.config.
    -- The first directory below ~/.config is the target,
    -- so reuse base=~/.config rather than base=~/.config/nvim.
    vim.api.nvim_create_user_command("FilesNvim", function()
      picker_with_cd(
        "find_files",
        { cwd = vim.fn.expand("~/.config/nvim"), hidden = true, follow = true },
        function(path)
          cd_first_after_base("~/.config", path)
        end
      )
    end, { desc = "Find files in nvim and change to the first directory below ~/.config"})

    -- Scope: ~/dev -> change to the first directory below ~/dev (project root)
    vim.api.nvim_create_user_command("FilesDev", function()
      picker_with_cd("find_files", { cwd = vim.fn.expand("~/dev"), hidden = true, follow = true }, function(path)
        cd_first_after_base("~/dev", path)
      end)
    end, { desc = "Find files in ~/dev and change to the project root"})

    require("dashboard").setup({
      theme = "doom",
      config = {
        header = {
          [[]],
          [[]],
          [[]],
          [[      ::::    ::: :::::::::: ::::::::  :::     ::: ::::::::::: ::::    :::::      ]],
          [[      :+:+:   :+: :+:       :+:    :+: :+:     :+:     :+:     +:+:+: :+:+:+      ]],
          [[      :+:+:+  +:+ +:+       +:+    +:+ +:+     +:+     +:+     +:+ +:+:+ +:+      ]],
          [[      +#+ +:+ +#+ +#++:++#  +#+    +:+ +#+     +:+     +#+     +#+  +:+  +#+      ]],
          [[      +#+  +#+#+# +#+       +#+    +#+  +#+   +#+      +#+     +#+       +#+      ]],
          [[      #+#   #+#+# #+#       #+#    #+#   #+#+#+#       #+#     #+#       #+#      ]],
          [[      ###    #### ########## ########      ###     ########### ###       ###      ]],
          [[                                                                                  ]],
          [[                                                                                  ]],
          [[   .-''-.                      .--.  .-. .--------.                      .-''-.   ]],
          [[  /      `'''--..              ||  \/  ||'=====. ||              ..--'''`      \  ]],
          [[ |               '.            || .  . ||  .---' ||            .'               | ]],
          [[ |           ..''` '---.       || |\/|_||  '===. ||       .---' `''..           | ]],
          [[ |        .``           ''''\  ||_|\/|.'       |_||  /''''           ``.        | ]],
          [[ /'..   /`              /    /'|_.'            '._|'\    \              `\   ..'\ ]],
          [[ |   `:'         ___..  \   /  /                  \  \   /  ..___         ':`   | ]],
          [[ '____'__...---'':::::\  '-' ./                    \. '-'  \:::::''---...__'____' ]],
          [[   \::/\ \:::::::::::':  ___/                        \___  :':::::::::::/ /\::/   ]],
          [[    \'| \ '-:::--'`  .' /                                \ '.  `'--:::-' / |'/    ]],
          [[    /'|  \    ....''`__/                                  \__`''....    /  |'\    ]],
          [[    \ |   .   |  .-'`   .------. .------..------. .-. .--.   `'-.  |   .   | /    ]],
          [[     \/::.'   |  |      ||  _   V   _   ||   _   V  \/  ||      |  |   '.::\/     ]],
          [[     \':'_.---|  |      || | |  |  | |  ||  | |  | .  . ||      |  |---._':'/     ]],
          [[      \\      |  |      || | |  |   '|  ||  |'   | |\/| ||      |  |      //      ]],
          [[      \\      |  |      || |' .'|'.   .'||'.   .'|'|\/| ||      |  |      //      ]],
          [[       \\      | |      ||  .'.' '.'.'.'  '.'.'.' '|  | ||      | |      //       ]],
          [[       \\      | |      ||.'.'     '.'      '.'       |.||      | |      //       ]],
          [[        \\     |'       |_.'                          '._|       '|     //        ]],
          [[                                                                                  ]],
          [[]],
        },

        center = {
          {
            icon = "⚡",
            icon_hl = "Title",
            desc = " Zoxide",
            desc_hl = "String",
            key = "z",
            key_hl = "Number",
            key_format = " %s",
            action = "Zoxide",
          },
          {
            icon = " ",
            icon_hl = "Title",
            desc = " Recent Files",
            desc_hl = "String",
            key = "r",
            key_hl = "Number",
            key_format = " %s",
            action = "RecentHere",
          },
          {
            icon = " ",
            icon_hl = "Title",
            desc = " Find Files",
            desc_hl = "String",
            key = "f",
            key_hl = "Number",
            key_format = " %s",
            action = "FilesHere",
          },
          {
            icon = "󰲋 ",
            icon_hl = "Title",
            desc = " Applications",
            desc_hl = "String",
            key = "a",
            key_hl = "Number",
            key_format = " %s",
            action = "FilesDev",
          },
          {
            icon = " ",
            icon_hl = "Title",
            desc = " Neovim",
            desc_hl = "String",
            key = "n",
            key_hl = "Number",
            key_format = " %s",
            action = "FilesNvim",
          },
          {
            icon = " ",
            icon_hl = "Title",
            desc = " Dotfiles",
            desc_hl = "String",
            key = "d",
            key_hl = "Number",
            key_format = " %s",
            action = "FilesConfig",
          },
          {
            icon = "󰊳 ",
            icon_hl = "DiagnosticInfo",
            desc = " Update Lazy",
            desc_hl = "String",
            key = "u",
            key_hl = "Number",
            key_format = " %s",
            action = "Lazy update",
          },
          {
            icon = "󰧵 ",
            icon_hl = "DiagnosticInfo",
            desc = " Update Mason",
            desc_hl = "String",
            key = "m",
            key_hl = "Number",
            key_format = " %s",
            action = "MasonToolsUpdate",
          },
        },

        footer = {
          "Made by maestro-bene",
        },
      },
    })
  end,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim",
  },
}
