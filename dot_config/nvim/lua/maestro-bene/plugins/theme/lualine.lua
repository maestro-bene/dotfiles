return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = "catppuccin-nvim",
      },
      sections = {
        lualine_x = {
          {
            cond = lazy_status.has_updates,
            lazy_status.updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
      extensions = { "quickfix", "fugitive", "fzf", "lazy", "man", "mason", "nvim-tree", "trouble" },
    })
  end,
}
