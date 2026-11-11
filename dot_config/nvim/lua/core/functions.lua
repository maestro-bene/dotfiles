function smart_diff()
	if vim.bo.filetype == "oil" then
		local oil = require("oil")
		local current_dir = oil.get_current_dir():gsub("/$", "")
		local other_dir = vim.fn.input("Compare with: ", current_dir, "dir"):gsub("/$", "")

		if other_dir ~= "" and other_dir ~= current_dir then
			local output = vim.fn.system(string.format("diff -ru '%s' '%s'", current_dir, other_dir))

			-- Create a new empty buffer
			local new_buf = vim.api.nvim_create_buf(false, true)

			-- Open a split and switch to the new buffer
			vim.cmd("vsplit")
			vim.api.nvim_set_current_buf(new_buf)

			-- Configure the buffer
			vim.bo.filetype = "diff"
			vim.bo.buftype = "nofile"
			vim.bo.swapfile = false

			-- Insert the content
			vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, vim.split(output, "\n"))
			vim.bo.modifiable = false

			-- Add mappings to close the buffer
			vim.keymap.set("n", "q", ":q<CR>", { buffer = new_buf })
			vim.keymap.set("n", "<C-w>q", ":q<CR>", { buffer = new_buf })
		end
	else
		-- Handle regular buffers
		local current_file = vim.api.nvim_buf_get_name(0)
		if current_file == "" then
			return
		end

		local buffers = {}
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			local name = vim.api.nvim_buf_get_name(buf)
			if vim.api.nvim_buf_is_loaded(buf) and name ~= "" and name ~= current_file then
				table.insert(buffers, name)
			end
		end

		if #buffers == 0 then
			vim.notify("No other buffers to compare")
			return
		end

		local target = #buffers == 1 and buffers[1] or vim.fn.input("Compare with: ", "", "file")

		if target ~= "" then
			local output = vim.fn.system(string.format("diff -u '%s' '%s'", current_file, target))

			-- Create a new empty buffer
			local new_buf = vim.api.nvim_create_buf(false, true)

			-- Open a split and switch to the new buffer
			vim.cmd("vsplit")
			vim.api.nvim_set_current_buf(new_buf)

			-- Configure the buffer
			vim.bo.filetype = "diff"
			vim.bo.buftype = "nofile"
			vim.bo.swapfile = false

			-- Insert the content
			vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, vim.split(output, "\n"))
			vim.bo.modifiable = false

			-- Add mappings to close the buffer
			vim.keymap.set("n", "q", ":q<CR>", { buffer = new_buf })
			vim.keymap.set("n", "<C-w>q", ":q<CR>", { buffer = new_buf })
		end
	end
end
