
vim.cmd [[packadd packer.nvim]]
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
use "wbthomason/packer.nvim"

use 'savq/melange-nvim'
use {'gen740/SmoothCursor.nvim',
  config = function()
    require('smoothcursor').setup()
  end
}
use 'andymass/vim-matchup'
use 'antoinemadec/FixCursorHold.nvim'
use 'Pocco81/auto-save.nvim'

use 'nvim-telescope/telescope-fzy-native.nvim'
use 'nvim-telescope/telescope.nvim'
use 'nvim-lua/plenary.nvim'
use 'nvim-treesitter/nvim-treesitter'
use 'voldikss/vim-floaterm'

use 'neovim/nvim-lspconfig'
use 'yioneko/nvim-vtsls'
use 'mrcjkb/rustaceanvim'
use 'williamboman/mason.nvim'

use 'hrsh7th/cmp-nvim-lsp'
use 'hrsh7th/cmp-buffer'
use 'hrsh7th/cmp-path'
use 'hrsh7th/cmp-cmdline'
use 'hrsh7th/nvim-cmp'
use 'hrsh7th/cmp-vsnip'
use 'hrsh7th/vim-vsnip'

use {'mfussenegger/nvim-jdtls', ft = {'java'}}
use 'mfussenegger/nvim-dap'
use {'mfussenegger/nvim-dap-python', ft = {'py'}}
use 'nvim-neotest/nvim-nio'
use 'nvim-neotest/neotest'
use 'nvim-neotest/neotest-plenary'
use {'nvim-neotest/neotest-python', ft = {'py'}}

end)


