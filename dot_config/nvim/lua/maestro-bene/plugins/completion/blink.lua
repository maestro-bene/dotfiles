return {
  { "L3MON4D3/LuaSnip", keys = {}, build = { "make install_jsregexp" } },
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "mgalliou/blink-cmp-tmux",
      "MahanRahmati/blink-nerdfont.nvim",
      "moyiz/blink-emoji.nvim",
      {
        "bydlw98/blink-cmp-sshconfig",
        build = "make",
      },
      'Kaiser-Yang/blink-cmp-avante',
    },
    build = "cargo build --release", -- for delimiters
    version = "1.*",
    config = function()
      require("blink.cmp").setup({
        snippets = { preset = "luasnip" },
        signature = { enabled = true },
        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = "normal",
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        sources = {
          per_filetype = {
            codecompanion = { "codecompanion" },
            sql = { "snippets", "dadbod", "buffer" },
            oil = { "path" },
          },
          default = {
            "avante",
            "lazydev",
            "lsp",
            "path",
            "snippets",
            "buffer",
            "tmux",
            "nerdfont",
            "emoji",
            "sshconfig",
          },
          providers = {
            avante = {
              module = 'blink-cmp-avante',
              name = 'Avante',
              opts = {
                -- options for blink-cmp-avante
              }
            },
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100,
            },
            cmdline = {
              min_keyword_length = 2,
            },
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            tmux = {
              module = "blink-cmp-tmux",
              name = "tmux",
              -- default options
              opts = {
                -- `panes` option supports these values:
                -- * `window`  - completions from current tmux window panes only
                -- * `session` - completions from current tmux session panes only
                -- * `all`     - completions from all tmux panes
                panes = "session",
                capture_history = false,
                -- only suggest completions from `tmux` if the `trigger_chars` are
                -- used
                triggered_only = false,
                trigger_chars = { "." },
              },
            },
            nerdfont = {
              module = "blink-nerdfont",
              name = "Nerd Fonts",
              score_offset = 15, -- Tune by preference
              opts = {
                insert = true,   -- Insert nerdfont icon (default) or complete its name
                trigger = ";",   -- Customize the trigger. Defaults to ":"
              },
            },
            emoji = {
              module = "blink-emoji",
              name = "Emoji",
              score_offset = 15, -- Tune by preference
              opts = {
                insert = true,   -- Insert emoji (default) or complete its name
                ---@type string|table|fun():table
                trigger = function()
                  return { ":" }
                end,
              },
              should_show_items = function()
                return vim.tbl_contains(
                -- Enable emoji completion only for git commits and markdown.
                -- By default, enabled for all file-types.
                  { "gitcommit", "markdown" },
                  vim.o.filetype
                )
              end,
            },
            sshconfig = {
              name = "SshConfig",
              module = "blink-cmp-sshconfig",
            },
          },
        },
        keymap = {
          ["<C-f>"] = {},
        },
        cmdline = {
          enabled = true,
          completion = { menu = { auto_show = true } },
          keymap = {
            ["<CR>"] = { "fallback" },
          },
        },
        completion = {
          trigger = { prefetch_on_insert = false },
          menu = {
            border = nil,
            scrolloff = 1,
            scrollbar = false,
            draw = {
              columns = {
                { "kind_icon" },
                { "label",      "label_description", gap = 1 },
                { "kind" },
                { "source_name" },
              },
            },
          },
          documentation = {
            window = {
              border = nil,
              scrollbar = false,
              winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
            },
            auto_show = true,
            auto_show_delay_ms = 500,
          },
        },
      })

      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
