return {
	"harrisoncramer/gitlab.nvim",
	lazy = true,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
		"nvim-tree/nvim-web-devicons",
	},
	enabled = true,
	keys = {
		{
			"glr",
			function()
				require("gitlab").review()
			end,
			desc = "Review",
			mode = "n",
		},
		{
			"gls",
			function()
				require("gitlab").summary()
			end,
			desc = "Summary",
			mode = "n",
		},
		{
			"glA",
			function()
				require("gitlab").approve()
			end,
			desc = "Approve",
			mode = "n",
		},
		{
			"glR",
			function()
				require("gitlab").revoke()
			end,
			desc = "Revoke",
			mode = "n",
		},
		{
			"glc",
			function()
				require("gitlab").create_comment()
			end,
			desc = "Create Comment",
			mode = "n",
		},
		{
			"glO",
			function()
				require("gitlab").create_mr()
			end,
			desc = "Create MR",
			mode = "n",
		},
		{
			"glm",
			function()
				require("gitlab").move_to_discussion_tree_from_diagnostic()
			end,
			desc = "Move to Discussion Tree",
			mode = "n",
		},
		{
			"gln",
			function()
				require("gitlab").create_note()
			end,
			desc = "Create Note",
			mode = "n",
		},
		{
			"gld",
			function()
				require("gitlab").toggle_discussions()
			end,
			desc = "Toggle Discussions",
			mode = "n",
		},
		{
			"glaa",
			function()
				require("gitlab").add_assignee()
			end,
			desc = "Add Assignee",
			mode = "n",
		},
		{
			"glad",
			function()
				require("gitlab").delete_assignee()
			end,
			desc = "Delete Assignee",
			mode = "n",
		},
		{
			"glla",
			function()
				require("gitlab").add_label()
			end,
			desc = "Add Label",
			mode = "n",
		},
		{
			"glld",
			function()
				require("gitlab").delete_label()
			end,
			desc = "Delete Label",
			mode = "n",
		},
		{
			"glra",
			function()
				require("gitlab").add_reviewer()
			end,
			desc = "Add Reviewer",
			mode = "n",
		},
		{
			"glrd",
			function()
				require("gitlab").delete_reviewer()
			end,
			desc = "Delete Reviewer",
			mode = "n",
		},
		{
			"glp",
			function()
				require("gitlab").pipeline()
			end,
			desc = "Pipeline",
			mode = "n",
		},
		{
			"glo",
			function()
				require("gitlab").open_in_browser()
			end,
			desc = "Open in Browser",
			mode = "n",
		},
		{
			"glM",
			function()
				require("gitlab").merge()
			end,
			desc = "Merge",
			mode = "n",
		},

		-- Visual mode
		{
			"glc",
			function()
				require("gitlab").create_multiline_comment()
			end,
			desc = "Create Multiline Comment",
			mode = "v",
		},
		{
			"glC",
			function()
				require("gitlab").create_comment_suggestion()
			end,
			desc = "Create Comment Suggestion",
			mode = "v",
		},
	},
	build = function()
		require("gitlab.server").build(true)
	end, -- Builds the Go binary
	config = function()
		local gitlab = require("gitlab")
		-- local gitlab_server = require("gitlab.server")

		gitlab.setup({
			debug = { go_request = false, go_response = false },
			-- For Gitlab server self-hosted with another port : in the .git/config file, under [core], add :
			-- sshCommand = ssh -p <PORT>
			-- and remove in the ssh url the :PORT as such :
			-- 	url = ssh://git@<gitURL>:PORT/namespace/project.git
			-- 	to
			--  url = ssh://git@<gitURL>/namespace/project.git
		})

		-- vim.keymap.set("n", "glr", gitlab.review, { desc = "Review" })
		-- vim.keymap.set("n", "gls", gitlab.summary, { desc = "Summary" })
		-- vim.keymap.set("n", "glA", gitlab.approve, { desc = "Approve" })
		-- vim.keymap.set("n", "glR", gitlab.revoke, { desc = "Revoke" })
		-- vim.keymap.set("n", "glc", gitlab.create_comment, { desc = "Create Comment" })
		-- vim.keymap.set("v", "glc", gitlab.create_multiline_comment, { desc = "Create Multiline Comment" })
		-- vim.keymap.set("v", "glC", gitlab.create_comment_suggestion, { desc = "Create Comment Suggestion" })
		-- vim.keymap.set("n", "glO", gitlab.create_mr, { desc = "Create Merge Request" })
		-- vim.keymap.set(
		-- 	"n",
		-- 	"glm",
		-- 	gitlab.move_to_discussion_tree_from_diagnostic,
		-- 	{ desc = "Move to Discussion Tree from Diagnostic" }
		-- )
		-- vim.keymap.set("n", "gln", gitlab.create_note, { desc = "Create Note" })
		-- vim.keymap.set("n", "gld", gitlab.toggle_discussions, { desc = "Toggle Discussions" })
		-- vim.keymap.set("n", "glaa", gitlab.add_assignee, { desc = "Add Assignee" })
		-- vim.keymap.set("n", "glad", gitlab.delete_assignee, { desc = "Delete Assignee" })
		-- vim.keymap.set("n", "glla", gitlab.add_label, { desc = "Add Label" })
		-- vim.keymap.set("n", "glld", gitlab.delete_label, { desc = "Delete Label" })
		-- vim.keymap.set("n", "glra", gitlab.add_reviewer, { desc = "Add Reviewer" })
		-- vim.keymap.set("n", "glrd", gitlab.delete_reviewer, { desc = "Delete Reviewer" })
		-- vim.keymap.set("n", "glp", gitlab.pipeline, { desc = "Pipeline" })
		-- vim.keymap.set("n", "glo", gitlab.open_in_browser, { desc = "Open in Browser" })
		-- vim.keymap.set("n", "glM", gitlab.merge, { desc = "Merge" })
	end,
}
