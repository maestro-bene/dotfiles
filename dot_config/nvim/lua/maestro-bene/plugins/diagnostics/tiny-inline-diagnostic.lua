return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      options = {
        add_messages = {
          display_count = true,
        },
        multilines = {
          enabled = true,
        },
      },
    })
  end,
}
