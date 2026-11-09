return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
        install_dir = vim.fn.stdpath('data') .. '/site',
      })
      if vim.env.TREE_SITTER_LOGSTASH_PATH and vim.env.TREE_SITTER_LOGSTASH_PATH ~= "" then
        vim.api.nvim_create_autocmd('User', {
          pattern = 'TSUpdate',
          callback = function()
            require('nvim-treesitter.parsers').logstash = {
              install_info = {
                path = vim.env.TREE_SITTER_LOGSTASH_PATH,
                generate = true,
                generate_from_json = false,
                queries = 'queries/logstash',
              },
            }
          end,
        })
      end

      vim.treesitter.language.register('logstash', { 'logstash' })
      require('nvim-treesitter').install {
        "bash",
        "c",
        "css",
        "dockerfile",
        "gitignore",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "logstash",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "python",
        "query",
        "regex",
        "ruby",
        "vim",
        "vimdoc",
        "yaml",
      }
      -- Highlight TS auto pour tous les buffers "normaux"
      vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufNewFile" }, {
        callback = function(args)
          local bufnr = args.buf
          local bt = vim.bo[bufnr].buftype
          local ft = vim.bo[bufnr].filetype

          -- skip buffers spéciaux
          if bt ~= "" then
            return
          end
          if ft == "" then
            return
          end

          pcall(vim.treesitter.start, bufnr)
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
      })
    end,
  },
}
