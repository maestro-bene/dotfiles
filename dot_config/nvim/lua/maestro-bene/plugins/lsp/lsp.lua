return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    { "saghen/blink.cmp" },
  },
  config = function()
    vim.lsp.config("shfmt", require("lsp.shfmt"))
    vim.lsp.config("intelephense", require("lsp.intelephense"))
    vim.lsp.config("lua_ls", require("lsp.lua_ls"))

    vim.lsp.enable("shfmt")
    vim.lsp.enable("intelephense")
    vim.lsp.enable("jedi_language_server")
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("bashls")

    vim.diagnostic.config({
      -- virtual_lines = true,
      -- virtual_text = false,
      -- underline = true,
      -- update_in_insert = false,
      -- severity_sort = true,
      -- float = {
      --   border = "rounded",
      --   source = true,
      -- },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        --   numhl = {
        --     [vim.diagnostic.severity.ERROR] = "ErrorMsg",
        --     [vim.diagnostic.severity.WARN] = "WarningMsg",
        --   },
      },
    })
  end,
}
