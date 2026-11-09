return {
  "mason-org/mason.nvim",
  lazy = false,
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "󰌚 ",
          package_uninstalled = "✗",
        },
        border = "rounded",
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "clangd",
        "cssls",
        -- "elixirls",
        -- "golangci_lint_ls",
        -- "gopls",
        "html",
        "lua_ls",
        "pyright",
        -- "jdtls",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "ast-grep",     -- used for c and cpp, but also
        "black",        -- python formatter
        "clang-format", -- c formatter
        "eslint_d",     -- js linter
        -- "gofumpt",      -- go formatter
        -- "goimports",    -- go imports formatter
        -- "golines",      -- go lines formatter
        "isort",        -- python formatter
        "prettier",     -- prettier formatter
        "php-cs-fixer", -- php formatter
        "trivy",        -- code security
        "shfmt",        -- shell and bash formatter
      },
    })
  end,
}
