local has_dap_py, dap_py = pcall(require,"dap-python")
if has_dap_py then
  dap_py.setup("python")
  dap_py.test_runner = "pytest"
  vim.keymap.set('n', '<Leader>tm', function()
     vim.cmd('wa')
     dap_py.test_method()
  end)
  vim.keymap.set('n', '<Leader>tc', function()
     vim.cmd('wa')
     dap_py.test_class()
  end)
end

require("mason").setup(
    {
        pickers = {
            current_buffer_fuzzy_find = {sorting_strategy = "ascending"},
            ensure_installed = {"pyright", "clangd", "jdtls", "cpplint", "cpptools", "rust-analyzer"}
        }
    }
)

local neotest_adapters = {}
local required_adapters = {
				{"neotest-python", function (name) require(name)( { dap = {justMyCode = false}, run = "pytest" }) end },
				{ "neotest-plenary" ,function (name) require(name) end }
			   }
for idx=1, #required_adapters do 
	local adapter = required_adapters[idx][1]
	local has_adapter, neotest_py = pcall(require, adapter)
	if has_adapter then
		neotest_adapters[idx] = required_adapters[idx][2](adapter)
	end
end

require("neotest").setup(
    {
        adapters = neotest_adapters
    }
)

require("auto-save")

require("plenary.async")

-- Setup language servers.
local lspconfig = require("lspconfig")	
lspconfig.ts_ls.setup({
 init_options = { 
    preferences = { 
      -- other preferences... 
      importModuleSpecifierPreference = 'relative', 
      importModuleSpecifierEnding = 'minimal', 
    },  
  } 
})
lspconfig.rust_analyzer.setup({})
lspconfig.pyright.setup(
    {
        capabilities = require("cmp_nvim_lsp").default_capabilities()
    }
)	
lspconfig.clangd.setup({
    cmd = {
    "clangd",
    "--fallback-style=llvm",
     "--background-index",
     "-j=12",
     "--clang-tidy",
     "--clang-tidy-checks=*",
     "--all-scopes-completion",
     "--cross-file-rename",
     "--completion-style=detailed",
     "--header-insertion-decorators",
     "--header-insertion=iwyu",
     "--pch-storage=memory",
  },
})

local actions = require("telescope.actions")
require("telescope").setup(
    {
        defaults = {
            file_sorter = require("telescope.sorters").get_fzy_sorter,
            generic_sorter = require("telescope.sorters").get_fzy_sorter
        },
        file_ignore_patterns = {
            '^.git/', '^target/', '^node%_modules/', '^.npm/', '^build/', '%[Cc]ache/', '%-cache',
            '^.dropbox/', '^.dropbox_trashed/', '%.py[co]', '%.sw?', '%~', '%.a', "%.npz", "^.vscode",
            '%.sql', '%.tags', '%.gemtags', '%.csv', '%.tsv', '%.tmp', '%.exe', "%.dat", "^dist",
            '%.old', '%.plist', '%.pdf', '%.log', '%.jpg', '%.jpeg', '%.png', "%.obj", "^release",
            '%.tar.gz', '%.tar', '%.zip', '%.class', '%.pdb', '%.dll', '%.bak', "%.lib", "^.idea",
            '%.scan', '%.mca', '__pycache__', '^.mozilla/', '^.electron/', '%.bin', "^debug",
            '^.vpython-root/', '^.gradle/', '^.nuget/', '^.cargo/', '^.evernote/', "^Debug",
            '^.azure-functions-core-tools/', '^yay/', '%.class', '%.o', '%.so', "^Release"
        },
        path_display = { "smart" },
            mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<CR>"] = actions.select_default,
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-c>"] = actions.close,
                ["<C-t>"] = actions.select_tab,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            },
            n = {
                ["<esc>"] = actions.close,
                ["<CR>"] = actions.select_default,
                ["s"] = actions.select_horizontal,
                ["v"] = actions.select_vertical,
                ["t"] = actions.select_tab,
                ["K"] = actions.preview_scrolling_up,
                ["J"] = actions.preview_scrolling_down,
                ["n"] = actions.cycle_history_next,
                ["p"] = actions.cycle_history_prev,
                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,
                ["c"] = actions.close,
                ["H"] = actions.move_to_top,
                ["M"] = actions.move_to_middle,
                ["L"] = actions.move_to_bottom,
                ["gg"] = actions.move_to_top,
                ["G"] = actions.move_to_bottom,
                ["q"] = actions.send_to_qflist + actions.open_qflist,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            },
            }
    }
)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd(
    "LspAttach",
    {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = {buffer = ev.buf}
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
            vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set(
                "n",
                "<space>wl",
                function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end,
                opts
            )
            vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
            vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set({"n", "v"}, "<space>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set(
                "n",
                "<space>fr",
                function()
                    vim.lsp.buf.format {async = true}
                end,
                opts
            )
        end
    }
)

local cmp = require("cmp")
cmp.setup(
    {
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            end
        },
        window = {},
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert(
            {
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({select = true}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<Tab>"] = cmp.mapping.select_next_item()
            }
        ),
        sources = cmp.config.sources(
            {
                {name = "nvim_lsp"},
                {name = "vsnip"} -- For vsnip users.
                -- { name = 'luasnip' }, -- For luasnip users.
                -- { name = 'ultisnips' }, -- For ultisnips users.
                -- { name = 'snippy' }, -- For snippy users.
            },
            {
                {name = "buffer"}
            }
        )
    }
)

-- Set configuration for specific filetype.
cmp.setup.filetype(
    "gitcommit",
    {
        sources = cmp.config.sources(
            {
                {name = "git"} -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
            },
            {
                {name = "buffer"}
            }
        )
    }
)

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
    {"/", "?"},
    {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            {name = "buffer"}
        }
    }
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
    ":",
    {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
            {
                {name = "path"}
            },
            {
                {name = "cmdline"}
            }
        )
    }
)

vim.cmd 'colorscheme melange'

vim.opt.shadafile = 'NONE'
vim.opt.termguicolors = true
vim.o.clipboard = 'unnamedplus'	
vim.opt.writebackup = false
vim.opt.autoread = true
vim.opt.swapfile = false -- no swap file
vim.opt.shiftwidth = 2
