return {
	"tpope/vim-dadbod",
	opt = false,
	requires = {
		"kristijanhusak/vim-dadbod-ui",
		"kristijanhusak/vim-dadbod-completion",
	},
	config = function()
		-- Sauvegarde des UI files dans: <stdpath("config")>/db_ui
		vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"

		-- Omni completion pour dadbod (fallback si pas de nvim-cmp)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "sql" },
			command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
		})
	end,
}
