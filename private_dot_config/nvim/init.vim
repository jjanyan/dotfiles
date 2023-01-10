
" utf-8 is where it's at
set encoding=UTF-8
" stop vim grabbing the mouse
set mouse=
" no highlighting search
set nohls
" numbers
set number
" let me switch buffers without saving
set hidden
" fixes restoring from /views/ to only folds and cursors, which is all i think
" inspiration: https://github.com/windwp/nvim-autopairs/issues/90
set viewoptions=folds,cursor,curdir
" default to 4 space tabs and use spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" pretty sure this is required for treesitter to work well
syntax enable
set termguicolors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" keeps from hitting top/bottom
set scrolloff=5
" prevent bouncing of gutter
set signcolumn=number


" set the leader key to spacebar
let mapleader = " "
" turn off paren highlighting
let g:loaded_matchparen=1
" yank to system clipboard
noremap <leader>c "*y

" remember where I was in a file
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
" remember folds
augroup remember_folds
  autocmd!
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview
augroup END

" move screen up/down 1 line at a time
" ctrl+j = slide screen down 1 line
" ctrl+k = slide screen up 1 line
nnoremap <C-j> <C-e>
nnoremap <C-k> <C-y>
" shift buffers with H and L
noremap <silent> H :bp<CR>
noremap <silent> L :bn<CR>

" undo history (even between sessions)
set undofile
set undodir=~/.vim/undodir


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

  " fancy icons
  Plug 'nvim-tree/nvim-web-devicons'

  " bufferline (top)
  Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }
  
  " tokyonight theme
  Plug 'folke/tokyonight.nvim', {'branch': 'main'}

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

  " Plugin outside ~/.vim/plugged with post-update hook
  " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

  " Initialize plugin system
  " - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()

" source lua related configs
lua require('config')

" set theme
colorscheme tokyonight


" copilot
imap <silent><script><expr> <C-k> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" COC.NVIM
"set guifont=MesloLGS_Nerd_Font:h11
set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h10
nmap <silent> gd <Plug>(coc-definition)
function! SplitIfNotOpen(...)
  let fname = a:1
  let call = ''
  if a:0 == 2
    let fname = a:2
    let call = a:1
  endif
  let bufnum=bufnr(expand(fname))
  let winnum=bufwinnr(bufnum)
  if winnum != -1
    " Jump to existing split
    exe winnum . "wincmd w"
  else
    " Make new split as usual
    exe "vsplit " . fname
  endif
  " Execute the cursor movement command
  exe call
endfunction
command! -nargs=+ CocSplitIfNotOpen :call SplitIfNotOpen(<f-args>)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
:nnoremap <space>e :CocCommand explorer<CR>
" enter will confirm and not newline when selecting an lsp option
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
" accept suggestions with tab
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
noremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" telescope stuff
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
"nnoremap <leader>fb <cmd>Telescope file_browser<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fo <cmd>Telescope oldfiles<cr>
nnoremap <leader>fs <cmd>Telescope current_buffer_fuzzy_find<cr>

" vim-airline config
" show buffers at the top
let g:airline#extensions#tabline#enabled = 0
" show buffer number in the tab
let g:airline#extensions#tabline#buffer_nr_show = 1


" hop?
map f  <esc>:HopPattern<cr>
nmap f <esc>:HopPattern<cr>
map F  <esc>:HopWord<cr>
nmap F <esc>:HopWord<cr>
map  gl <esc>:HopLine<cr>
nmap gl <esc>:HopLine<cr>
