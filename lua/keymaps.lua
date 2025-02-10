local keymap = vim.keymap.set
local noremap = { noremap = true, silent = false }
local snoremap = { noremap = true, silent = true }

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
keymap("n", "<space>d", vim.diagnostic.open_float)
keymap("n", "[d", vim.diagnostic.goto_prev)
keymap("n", "]d", vim.diagnostic.goto_next)
keymap("n", "<space>q", vim.diagnostic.setloclist)

-- Using Telescope functions
keymap("n", "<space>ff", function()
		vim.cmd 'wa'
		require("telescope.builtin").find_files()
	end, noremap)
keymap("n", "<space>fg", function()
		vim.cmd 'wa'
		require("telescope.builtin").live_grep()
	end, noremap)
keymap("n", "<space>fb", function() 
		vim.cmd 'wa'
		require("telescope.builtin").current_buffer_fuzzy_find()
	end, noremap)

keymap("n", "<space>ee", function() require("dap").repl.open() end, snoremap)
keymap("n", "<space>tb", function() require("dap").toggle_breakpoint() end, snoremap)
keymap("n", "<space>ts", function() require("dap").close() end, snoremap)
keymap("n", "<space>cc", function() require("dap").continue() end, snoremap)
keymap("n", "<space>pp", function() require("dap").pause() end, snoremap)

-- Setup mapping to call :FloatermNew
keymap("n", "<space>gg", function() vim.cmd(string.format('FloatermNew --disposable --width=1000 --height=1800 gitui -d %s',vim.api.nvim_buf_get_name(1))) end, snoremap)
keymap("n", "<C-c>", function() vim.cmd 'FloatermKill' end, snoremap)


-- Navigation
keymap("n", "<space>e", function()
		vim.cmd 'w'
		vim.cmd 'e.'
	end, noremap)
keymap("n", "<space>E", function()
		vim.cmd 'w'
		vim.cmd 'Ex'
	end, noremap)

-- Escape to write
keymap("i", "<C-c>", "<Esc>", noremap)
