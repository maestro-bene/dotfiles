local internal_regex = vim.env.GITLAB_INTERNAL_REGEX or "^gitlab%.com$"
local internal_host = vim.env.GITLAB_INTERNAL_HOST or "https://gitlab.com/"
return {
  "linrongbin16/gitlinker.nvim",
  lazy = false,
  cmd = "GitLink",
  opts = {
    router = {
      browse = {
        [internal_regex] = internal_host
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blob/"
            .. "{_A.REV}/"
            .. "{_A.FILE}"
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
      },
      blame = {
        [internal_regex] = internal_host
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blame/"
            .. "{_A.REV}/"
            .. "{_A.FILE}"
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
      },
    },
  },
  keys = {
    { "<leader>gy", "<cmd>GitLink<cr>",  mode = { "n", "v" }, desc = "Yank git link" },
    { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
  },
}
