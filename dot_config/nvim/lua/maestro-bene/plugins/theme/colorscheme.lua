return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    -- load the colorscheme here
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true, -- disables setting the background color.
      show_end_of_buffer = false,    -- shows the '~' characters after the end of buffers
      term_colors = true,            -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false,             -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.90,           -- percentage of the shade to apply to the inactive window
      },
      no_italic = false,             -- Force no italic
      no_bold = false,               -- Force no bold
      no_underline = false,          -- Force no underline
      styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" },     -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {
        mocha = {
          rosewater = "#efc9c2",
          flamingo = "#ebb2b2",
          pink = "#f2a7de",
          mauve = "#b889f4",
          red = "#ea7183",
          maroon = "#ea838c",
          peach = "#f39967",
          yellow = "#eaca89",
          green = "#96d382",
          teal = "#78cec1",
          sky = "#91d7e3",
          sapphire = "#68bae0",
          blue = "#739df2",
          lavender = "#a0a8f6",
          subtext1 = "#a6b0d8",
          subtext0 = "#959ec2",
          overlay2 = "#848cad",
          overlay1 = "#717997",
          overlay0 = "#B4B2C2",
          surface2 = "#505469",
          surface1 = "#6F698D",
          surface0 = "#2c2f40",
          base = "#1a1c2a",
          mantle = "#141620",
          crust = "#0e0f16",
        },
      },
      custom_highlights = {},
      integrations = {
        blink_cmp = {
          style = "bordered",
        },
        blink_indent = true,
        buffon = true,
        cmp = true,
        dadbod_ui = true,
        dashboard = true,
        flash = true,
        fzf = true,
        gitsigns = {
          enabled = true,
          -- align with the transparent_background option by default
          transparent = true,
        },
        grug_far = true,
        harpoon = true,
        lsp_trouble = true,
        markdown = true,
        mason = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        neotest = true,
        noice = true,
        notify = true,
        nvim_surround = true,
        overseer = true,
        render_markdown = true,
        scripts = {
          enabled = true,
          indent_scope_color = "", -- catppuccin color (eg. `lavender`) Default: overlay2
        },
        telescope = {
          enabled = true,
        },
        which_key = true,
        treesitter = true,
      },
    })

    vim.cmd.colorscheme("catppuccin-nvim")
  end,
}
