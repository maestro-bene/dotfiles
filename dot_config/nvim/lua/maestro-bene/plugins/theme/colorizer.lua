return {
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      options = {
        parsers = {
          css = true
        }
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },
}
