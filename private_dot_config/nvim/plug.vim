" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()
  " Make sure you use single quotes
  " treesitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " coc.nvim - the good stuff
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " copilot
  Plug 'github/copilot.vim', {'branch': 'release'}

  " telescope stuff
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-file-browser.nvim'

  " telescope extension for coc.nvim
  Plug 'fannheyward/telescope-coc.nvim'

  " fancy icons
  Plug 'nvim-tree/nvim-web-devicons'

  " bufferline (top)
  Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }
  
  " tokyonight theme
  "Plug 'folke/tokyonight.nvim', {'branch': 'main'}
  " noctis theme
  Plug 'talha-akram/noctis.nvim'

  " match up parens and other stuff
  Plug 'andymass/vim-matchup'

  " airline (bottom bar)
  Plug 'vim-airline/vim-airline'

  " hex colors
  Plug 'norcalli/nvim-colorizer.lua'

  " gotta git blame that
  Plug 'tpope/vim-fugitive'

  " move around more efficiently
  Plug 'phaazon/hop.nvim'

  " surround stuff
  Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }

  " which-key
  "Plug 'folke/which-key.nvim'
  Plug 'liuchengxu/vim-which-key'

  " ts-node-action
  " Plug 'ckolkey/ts-node-action'

  " Plugin outside ~/.vim/plugged with post-update hook
  " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

  " Initialize plugin system
  " - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
