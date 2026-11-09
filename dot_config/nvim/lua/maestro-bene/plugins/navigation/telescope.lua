return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  tag = "v0.2.1",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/popup.nvim",

    -- Fuzzy finder
    "ibhagwan/fzf-lua",
    "nvim-telescope/telescope-fzf-native.nvim",

    -- Git Conflicts
    "Snikimonkd/telescope-git-conflicts.nvim",

    -- Clipboard manager
    "AckslD/nvim-neoclip.lua",

    -- Notify
    "rcarriga/nvim-notify",

    -- Zoxide
    "jvgrootveld/telescope-zoxide",
  },

  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")
    local z_utils = require("telescope._extensions.zoxide.utils")

    local exclude_dirs = {
      ".asdf",
      ".cache",
      ".obsidian",
      ".vim/bundle",
      ".docker",
      "__pycache__",
      "node_modules",
      "Library",
      "Downloads",
      ".local",
      ".cache",
      ".git",
      ".npm",
      ".rustup",
      "Movies",
      ".cargo/registry",
      "go",
      "Applications",
      "deps",
      "data",
      ".meta",
      "vendor",
      ".venv",
    }

    local exclude_globs = {
      "!**/public/bundles/**",
      "!**/var/cache/**",
      "!**__init__.py",
    }

    local binary_exts = {
      "png",
      "jpg",
      "jpeg",
      "gif",
      "pdf",
      "csv",
      "bmp",
      "ico",
      "svg",
      "webp",
      "tiff",
      "psd",
      "mp4",
      "mkv",
      "avi",
      "mov",
      "webm",
      "flv",
      "wmv",
      "mpeg",
      "mp3",
      "wav",
      "ogg",
      "flac",
      "aac",
      "m4a",
      "zip",
      "tar",
      "gz",
      "bz2",
      "xz",
      "rar",
      "7z",
      "tgz",
      "tar.gz",
      "exe",
      "dll",
      "so",
      "bin",
      "o",
      "a",
      "out",
      "class",
      "jar",
      "pyc",
      "pyo",
      "apk",
      "dylib",
      "app",
      "deb",
      "rpm",
      "msi",
      "ttf",
      "otf",
      "woff",
      "woff2",
      "iso",
      "img",
      "vmdk",
      "kbx",
      "qcow2",
    }

    local find_command = { "rg", "--files", "--hidden" }

    -- Exclude directories
    for _, dir in ipairs(exclude_dirs) do
      table.insert(find_command, "--glob")
      table.insert(find_command, "!" .. dir)
    end

    -- Exclude custom globs
    for _, glob in ipairs(exclude_globs) do
      table.insert(find_command, "--glob")
      table.insert(find_command, glob)
    end

    -- Exclude binary extensions
    for _, ext in ipairs(binary_exts) do
      table.insert(find_command, "--glob")
      table.insert(find_command, "!**." .. ext)
    end

    telescope.setup({
      pickers = {
        find_files = {
          hidden = true,
          find_command = find_command,
        },
        lsp_references = {
          show_line = false,
          include_declaration = false,
        },
        lsp_definitions = {
          show_line = false,
        },
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-g>"] = function(prompt_bufnr)
              local selection = require("telescope.actions.state").get_selected_entry()
              local dir = vim.fn.fnamemodify(selection.path, ":p:h")
              require("telescope.actions").close(prompt_bufnr)
              -- Depending on what you want put `cd`, `lcd`, `tcd`
              vim.cmd(string.format("silent lcd %s/..", dir))
            end,
            ["<C-p>"] = function(prompt_bufnr)
              local selection = require("telescope.actions.state").get_selected_entry()
              local dir = vim.fn.fnamemodify(selection.path, ":p:h")
              require("telescope.actions").close(prompt_bufnr)
              -- Depending on what you want put `cd`, `lcd`, `tcd`
              vim.cmd(string.format("silent lcd %s", dir))
            end,
          },
          n = {
            ["cd"] = function(prompt_bufnr)
              local selection = require("telescope.actions.state").get_selected_entry()
              local dir = vim.fn.fnamemodify(selection.path, ":p:h")
              require("telescope.actions").close(prompt_bufnr)
              -- Depending on what you want put `cd`, `lcd`, `tcd`
              vim.cmd(string.format("silent lcd %s", dir))
            end,
          },
        },
      },
      extensions = {
        zoxide = {
          event = "VeryLazy",
          prompt_title = "[ Zoxide List ]",

          -- Zoxide list command with score
          list_command = "zoxide query -ls",
          mappings = {
            default = {
              action = function(selection)
                vim.cmd.cd(selection.path)
              end,
              after_action = function(selection)
                vim.notify("Directory changed to " .. selection.path)
              end,
            },
            ["<C-s>"] = { action = z_utils.create_basic_command("split") },
            ["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
            ["<C-e>"] = { action = z_utils.create_basic_command("edit") },
            ["<C-f>"] = {
              keepinsert = true,
              action = function(selection)
                builtin.find_files({ cwd = selection.path })
              end,
            },
            ["<C-t>"] = {
              action = function(selection)
                vim.cmd.tcd(selection.path)
              end,
            },
          },
        },
      },
    })

    require("neoclip").setup({
      initial_mode = 'normal',
    })
  end,
}
