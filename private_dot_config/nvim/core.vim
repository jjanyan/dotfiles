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
" default unfolded
set foldlevel=99
" smart search (mostly case insensitive) - it needs ignorecase to work
set ignorecase
set smartcase
"set guifont=MesloLGS_Nerd_Font:h11
set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h10


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

" only needed if using sessions
set sessionoptions+=blank,buffers,curdir,folds,help,options,tabpages,winsize,resize,winpos,terminal
