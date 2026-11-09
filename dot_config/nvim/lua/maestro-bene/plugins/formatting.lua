return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        c = { "clang_format" },
        -- cpp = { "astyle" },
        css = { "prettier" },
        elixir = { "mix" },
        -- go = { "gofumpt", "goimports", "golines" },
        html = { "prettier" },
        -- java = { "jdtls" },
        javascript = { "prettier", "eslint_d" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        logstash = { "mustache" },
        markdown = { "prettier" },
        php = { "php_cs_fixer" },
        python = { "isort", "black" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
        bash = { "shfmt" },
        sh = { "shfmt" },
      },
      formatters = {
        mustache = {
          command = "mustache",
          args = { "format", "-w", "$FILENAME" },
          stdin = false,
          -- cwd = require("conform.util").root_file({ ".git" }),
        },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })
  end,
}
