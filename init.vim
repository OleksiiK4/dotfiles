call plug#begin(stdpath('data') . '/plugged')
Plug 'kdheepak/lazygit.nvim'

Plug 'Abstract-IDE/Abstract-cs'

Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'} " Replace <CurrentMajor> by the latest released major (first number of latest release)

Plug 'williamboman/mason.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-plenary'
Plug 'nvim-neotest/neotest-python'

Plug 'Pocco81/auto-save.nvim'
call plug#end()

" FIXME overwrite python env
let g:python3_host_prog = 'C:/Python311/python'
lua <<EOF
  require('dap-python').setup('C:/Python311/python')

  require('dap-python').test_runner = 'pytest'
EOF

lua <<EOF
  local async = require "plenary.async"

  require('mason').setup({
  	pickers = {
    		current_buffer_fuzzy_find = { sorting_strategy = 'ascending' },
  	},
  })

 require('telescope').setup{
  defaults = {
    file_sorter =  require'telescope.sorters'.get_fzy_sorter,
    generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
  }
 }

  require("neotest").setup({
    adapters = {
      require("neotest-python")({
        dap = { justMyCode = false },
	run = "pytest",
      }),
      require("neotest-plenary")
    },
  })
EOF

lua <<EOF
-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>d', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>fr', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping.select_next_item(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
EOF

colorscheme abscs

set clipboard+=unnamedplus	

set nobackup       "no backup files
set nowritebackup  "only in case you don't want a backup file while editing
set autoread
set noswapfile     "no swap files
lua <<EOF
  vim.opt.shadafile="NONE"
EOF

	
" set signcolumn=no


" Using Telescope functions
nnoremap <space>ff :wa<cr>:lua require('telescope.builtin').find_files()<cr>
nnoremap <space>fg :wa<cr>:lua require('telescope.builtin').live_grep()<cr>
nnoremap <space>fb :wa<cr>:lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>

nnoremap <silent> <space>tm <cmd>wa<cr>:lua require('dap-python').test_method()<CR>
nnoremap <silent> <space>tc <cmd>wa<cr>:lua require('dap-python').test_class()<CR>
nnoremap <silent> <space>ee :lua require('dap').repl.open()<CR>
nnoremap <silent> <space>tb :lua require('dap').toggle_breakpoint()<CR>
nnoremap <silent> <space>ts :lua require('dap').close()<CR>
nnoremap <silent> <space>cc :lua require('dap').continue()<CR>
nnoremap <silent> <space>pp :lua require('dap').pause()<CR>

" setup mapping to call :LazyGit
nnoremap <silent> <space>gg :LazyGit<CR>

nnoremap <space>e <cmd>w<cr><cmd>e.<cr>
nnoremap <space>E <cmd>w<cr><cmd>Ex<cr>
