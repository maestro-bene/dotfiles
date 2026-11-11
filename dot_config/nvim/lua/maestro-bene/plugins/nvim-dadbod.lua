return {
	"tpope/vim-dadbod",
	opt = false,
	requires = {
		"kristijanhusak/vim-dadbod-ui",
		"kristijanhusak/vim-dadbod-completion",
	},
	config = function()
		-- Save UI files under <stdpath("config")>/db_ui
		vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"

		-- Omni completion for dadbod (fallback when nvim-cmp is unavailable)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "sql" },
			command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
		})
	end,
}
