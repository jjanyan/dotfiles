set nohlsearch
set titleold=
set nohls
set ignorecase
set smartcase
set cindent
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

" remember where I was in a file
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif


" put all swap files into the .vim/view folder
set dir=~/.vim/view/

" in general, fold on { }
if version >= 600
    set foldenable
    set foldmarker={,}
    set foldmethod=marker
endif

" undo history (even between sessions)
set undofile
set undodir=~/.vim/undodir
