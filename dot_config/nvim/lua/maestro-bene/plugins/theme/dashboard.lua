return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    -- Utils: cd helpers selon le scope
    local function cd_to(path)
      if path and #path > 0 then
        vim.cmd("cd " .. vim.fn.fnameescape(path))
      end
    end

    -- Extraire "premier répertoire après base"
    -- ex: base="~/dev", file="~/dev/acme/app/src/main.go" -> cd "~/dev/acme"
    local function cd_first_after_base(base, file)
      local b = vim.fn.expand(base)
      local f = vim.fn.fnamemodify(file, ":p")
      if not vim.startswith(f, b .. "/") then
        return
      end
      local rest = f:sub(#b + 2) -- après "b/"
      local first = rest:match("([^/]+)")
      if first then
        cd_to(b .. "/" .. first)
      end
    end

    -- Telescope wrapper: ouvre puis applique une action de cd optionnelle
    local function picker_with_cd(picker, opts, cd_action)
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      opts = opts or {}
      opts.attach_mappings = function(prompt_bufnr, map)
        local function open_and_maybe_cd()
          local sel = action_state.get_selected_entry()
          actions.select_default(prompt_bufnr) -- ouvre le fichier
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

    -- Récents (pas de cd spécial)
    vim.api.nvim_create_user_command("Zoxide", function()
      require("telescope").extensions.zoxide.list()
    end, { desc = "Fuzzy find zoxide list" })

    -- Récents (pas de cd spécial)
    vim.api.nvim_create_user_command("RecentHere", function()
      picker_with_cd("oldfiles", { cwd_only = false }, nil)
    end, { desc = "Fichiers récents (sans cd spécial)" })

    -- Find Files général (pas de cd spécial)
    vim.api.nvim_create_user_command("FilesHere", function()
      picker_with_cd("find_files", { hidden = true, follow = true }, nil)
    end, { desc = "Find files (sans cd spécial)" })

    -- Scope: ~/.config -> cd au premier dossier après ~/.config
    vim.api.nvim_create_user_command("FilesConfig", function()
      picker_with_cd(
        "find_files",
        { cwd = vim.fn.expand("~/.config"), hidden = true, follow = true },
        function(path)
          cd_first_after_base("~/.config", path)
        end
      )
    end, { desc = "Find files dans ~/.config -> cd premier dir après ~/.config" })

    -- Scope: ~/.config/nvim -> idem (premier dossier après ~/.config) ou après ~/.config/nvim ?
    -- D'après la demande: pour .config on cible 'premier répertoire après .config'.
    -- Donc on réutilise la même règle base=~/.config (et non ~/.config/nvim).
    vim.api.nvim_create_user_command("FilesNvim", function()
      picker_with_cd(
        "find_files",
        { cwd = vim.fn.expand("~/.config/nvim"), hidden = true, follow = true },
        function(path)
          cd_first_after_base("~/.config", path)
        end
      )
    end, { desc = "Find files dans nvim -> cd premier dir après ~/.config" })

    -- Scope: ~/dev -> cd premier dossier après ~/dev (racine projet)
    vim.api.nvim_create_user_command("FilesDev", function()
      picker_with_cd("find_files", { cwd = vim.fn.expand("~/dev"), hidden = true, follow = true }, function(path)
        cd_first_after_base("~/dev", path)
      end)
    end, { desc = "Find files dans ~/dev -> cd racine projet (1er dir)" })

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
