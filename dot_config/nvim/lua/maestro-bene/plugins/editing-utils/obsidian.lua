local obsidian_vault = vim.env.OBSIDIAN_VAULT
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "Notes",
        path = obsidian_vault or (vim.fn.stdpath("data") .. "/obsidian-vault"),
      },
    },
    templates = {
      folder = "Templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
      customizations = {
        meeting = {
          notes_subdir = "Meetings",
          note_id_func = function(title)
            --local date = os.date("%d-%m-%Y")
            title = title or "meeting"
            local clean = title:gsub('[%c%p/\\:*?"<>|]', ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
            return string.format("%s", clean)
          end,
        },
        daily = {
          notes_subdir = "Journal",
          note_id_func = function(_)
            local days = {
              Sunday = "dimanche",
              Monday = "lundi",
              Tuesday = "mardi",
              Wednesday = "mercredi",
              Thursday = "jeudi",
              Friday = "vendredi",
              Saturday = "samedi",
            }
            local date = os.date("%d-%m-%Y")
            local day_en = os.date("%A")
            local day = days[day_en] or day_en
            return string.format("%s-%s", date, day)
          end,
        },
      },
    },
    ui = {
      enable = false,
    },
  },
}
