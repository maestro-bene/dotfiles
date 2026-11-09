return {
	"ThePrimeagen/refactoring.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		vim.keymap.set("v", "<leader>re", ":Refactor extract", { desc = "Refactor extract" })
		vim.keymap.set("v", "<leader>rf", ":Refactor extract_to_file ", { desc = "Refactor extract to file" })

		vim.keymap.set("v", "<leader>rv", ":Refactor extract_var ", { desc = "Refactor extract variable" })
		vim.keymap.set({ "n", "v" }, "<leader>ri", ":Refactor inline_var", { desc = "Refactor inline variable" })

		vim.keymap.set("v", "<leader>rb", ":Refactor extract_block", { desc = "Refactor extract block" })
		vim.keymap.set(
			"n",
			"<leader>rbf",
			":Refactor extract_block_to_file",
			{ desc = "Refactor extract block to file" }
		)
	end,
}
