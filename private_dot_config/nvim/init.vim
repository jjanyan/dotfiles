source ~/.config/nvim/core.vim
source ~/.config/nvim/plug.vim

" source lua related configs
lua require('config')

" set theme
"colorscheme tokyonight
colorscheme noctis_uva
colorscheme noctis_obscuro

" copilot
imap <silent><script><expr> <C-k> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

source ~/.config/nvim/plugin_configs/coc.vim
source ~/.config/nvim/plugin_configs/telescope.vim
source ~/.config/nvim/plugin_configs/airline.vim

" vim-matchup
let g:matchup_matchparen_deferred = 1 " speed up moving around

source ~/.config/nvim/plugin_configs/hop.vim
source ~/.config/nvim/plugin_configs/which-key.vim
