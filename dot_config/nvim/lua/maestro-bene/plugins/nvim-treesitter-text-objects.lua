return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = false,
  branch = "main",
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
    vim.g.no_plugin_maps = true

    -- Or, disable per filetype (add as you like)
    -- vim.g.no_python_maps = true
    -- vim.g.no_ruby_maps = true
    -- vim.g.no_rust_maps = true
    -- vim.g.no_go_maps = true
  end,
  config = function()
    local tsto = require("nvim-treesitter-textobjects")
    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")
    local repeatable_move = require("nvim-treesitter-textobjects.repeatable_move")

    tsto.setup({
      select = {
        lookahead = true,
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
      swap = {},
    })

    -- =========================
    -- SELECT
    -- =========================
    vim.keymap.set({ "x", "o" }, "a=", function() select.select_textobject("@assignment.outer", "textobjects") end,
      { desc = "Select outer part of an assignment" })
    vim.keymap.set({ "x", "o" }, "i=", function() select.select_textobject("@assignment.inner", "textobjects") end,
      { desc = "Select inner part of an assignment" })
    vim.keymap.set({ "x", "o" }, "l=", function() select.select_textobject("@assignment.lhs", "textobjects") end,
      { desc = "Select left hand side of an assignment" })
    vim.keymap.set({ "x", "o" }, "r=", function() select.select_textobject("@assignment.rhs", "textobjects") end,
      { desc = "Select right hand side of an assignment" })

    vim.keymap.set({ "x", "o" }, "a:", function() select.select_textobject("@property.outer", "textobjects") end,
      { desc = "Select outer part of an object property" })
    vim.keymap.set({ "x", "o" }, "i:", function() select.select_textobject("@property.inner", "textobjects") end,
      { desc = "Select inner part of an object property" })
    vim.keymap.set({ "x", "o" }, "l:", function() select.select_textobject("@property.lhs", "textobjects") end,
      { desc = "Select left part of an object property" })
    vim.keymap.set({ "x", "o" }, "r:", function() select.select_textobject("@property.rhs", "textobjects") end,
      { desc = "Select right part of an object property" })

    vim.keymap.set({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end,
      { desc = "Select outer part of a parameter/argument" })
    vim.keymap.set({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end,
      { desc = "Select inner part of a parameter/argument" })

    vim.keymap.set({ "x", "o" }, "ai", function() select.select_textobject("@conditional.outer", "textobjects") end,
      { desc = "Select outer part of a conditional" })
    vim.keymap.set({ "x", "o" }, "ii", function() select.select_textobject("@conditional.inner", "textobjects") end,
      { desc = "Select inner part of a conditional" })

    vim.keymap.set({ "x", "o" }, "al", function() select.select_textobject("@loop.outer", "textobjects") end,
      { desc = "Select outer part of a loop" })
    vim.keymap.set({ "x", "o" }, "il", function() select.select_textobject("@loop.inner", "textobjects") end,
      { desc = "Select inner part of a loop" })

    vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@call.outer", "textobjects") end,
      { desc = "Select outer part of a function call" })
    vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@call.inner", "textobjects") end,
      { desc = "Select inner part of a function call" })

    vim.keymap.set({ "x", "o" }, "am", function() select.select_textobject("@function.outer", "textobjects") end,
      { desc = "Select outer part of a method/function definition" })
    vim.keymap.set({ "x", "o" }, "im", function() select.select_textobject("@function.inner", "textobjects") end,
      { desc = "Select inner part of a method/function definition" })

    vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end,
      { desc = "Select outer part of a class" })
    vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end,
      { desc = "Select inner part of a class" })

    -- =========================
    -- SWAP
    -- =========================
    vim.keymap.set("n", "<leader>na", function() swap.swap_next("@parameter.inner") end,
      { desc = "Swap parameter with next" })
    vim.keymap.set("n", "<leader>n:", function() swap.swap_next("@property.outer") end,
      { desc = "Swap property with next" })
    vim.keymap.set("n", "<leader>nm", function() swap.swap_next("@function.outer") end,
      { desc = "Swap function with next" })

    vim.keymap.set("n", "<leader>pa", function() swap.swap_previous("@parameter.inner") end,
      { desc = "Swap parameter with prev" })
    vim.keymap.set("n", "<leader>p:", function() swap.swap_previous("@property.outer") end,
      { desc = "Swap property with prev" })
    vim.keymap.set("n", "<leader>pm", function() swap.swap_previous("@function.outer") end,
      { desc = "Swap function with prev" })

    -- =========================
    -- MOVE
    -- =========================
    vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@call.outer", "textobjects") end,
      { desc = "Next function call start" })
    vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end,
      { desc = "Next method/function def start" })
    vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end,
      { desc = "Next class start" })
    vim.keymap.set({ "n", "x", "o" }, "]i", function() move.goto_next_start("@conditional.outer", "textobjects") end,
      { desc = "Next conditional start" })
    vim.keymap.set({ "n", "x", "o" }, "]l", function() move.goto_next_start("@loop.outer", "textobjects") end,
      { desc = "Next loop start" })
    vim.keymap.set({ "n", "x", "o" }, "]s", function() move.goto_next_start("@scope", "locals") end,
      { desc = "Next scope" })
    vim.keymap.set({ "n", "x", "o" }, "]z", function() move.goto_next_start("@fold", "folds") end,
      { desc = "Next fold" })

    vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@call.outer", "textobjects") end,
      { desc = "Next function call end" })
    vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end,
      { desc = "Next method/function def end" })
    vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end,
      { desc = "Next class end" })
    vim.keymap.set({ "n", "x", "o" }, "]I", function() move.goto_next_end("@conditional.outer", "textobjects") end,
      { desc = "Next conditional end" })
    vim.keymap.set({ "n", "x", "o" }, "]L", function() move.goto_next_end("@loop.outer", "textobjects") end,
      { desc = "Next loop end" })

    vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@call.outer", "textobjects") end,
      { desc = "Prev function call start" })
    vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end,
      { desc = "Prev method/function def start" })
    vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end,
      { desc = "Prev class start" })
    vim.keymap.set({ "n", "x", "o" }, "[i", function() move.goto_previous_start("@conditional.outer", "textobjects") end,
      { desc = "Prev conditional start" })
    vim.keymap.set({ "n", "x", "o" }, "[l", function() move.goto_previous_start("@loop.outer", "textobjects") end,
      { desc = "Prev loop start" })

    vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@call.outer", "textobjects") end,
      { desc = "Prev function call end" })
    vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end,
      { desc = "Prev method/function def end" })
    vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end,
      { desc = "Prev class end" })
    vim.keymap.set({ "n", "x", "o" }, "[I", function() move.goto_previous_end("@conditional.outer", "textobjects") end,
      { desc = "Prev conditional end" })
    vim.keymap.set({ "n", "x", "o" }, "[L", function() move.goto_previous_end("@loop.outer", "textobjects") end,
      { desc = "Prev loop end" })

    -- Repeat move
    vim.keymap.set({ "n", "x", "o" }, ";", repeatable_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", repeatable_move.repeat_last_move_opposite)
  end,
}
