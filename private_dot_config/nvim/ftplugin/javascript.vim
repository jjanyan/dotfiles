" js fold on indent, easy and good enough
" setlocal foldmethod=syntax
" this lets me fold in comments that are at the top of functions/methods
"set foldignore=
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
"setlocal foldcolumn=1
setlocal foldlevelstart=1
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
