return {
	"nat-418/boole.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("boole").setup({
			mappings = {
				increment = "<leader>ic",
				decrement = "<leader>id",
			},
			-- User defined loops
			additions = {
				{ "foo", "bar" },
				{ "tic", "tac", "toe" },
				{
					"Janvier",
					"Février",
					"Mars",
					"Avril",
					"Mai",
					"Juin",
					"Juillet",
					"Août",
					"Septembre",
					"Octobre",
					"Novembre",
					"Décembre",
				},
				{
					"Lundi",
					"Mardi",
					"Mercredi",
					"Jeudi",
					"Vendredi",
					"Samedi",
					"Dimanche",
				},
				{
					"January",
					"February",
					"March",
					"April",
					"May",
					"June",
					"July",
					"August",
					"September",
					"October",
					"November",
					"December",
				},
			},
			allow_caps_additions = {
				{ "enable", "disable" },
				-- enable → disable
				-- Enable → Disable
				-- ENABLE → DISABLE
			},
		})
	end,
}
