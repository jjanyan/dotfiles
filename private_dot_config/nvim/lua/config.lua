
-- treesitter / TS
require'nvim-treesitter.configs'.setup {
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true
    },
    -- rainbow = {
    --     enable = true,
    --     extended_mode = true, -- Alsococ-snippets highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    --     max_file_lines = nil, -- Do not enable for files with more than n lines, int
    --     colors = {
    --         "#bd93f9",
    --         "#ffb86c",
    --         "#ff79c6",
    --         "#50fa7b",
    --         "#f1fa8c",
    --         "#8be9fd"
    --     }
    --     -- colors = {}, -- table of hex strings
    --     -- termcolors = {} -- table of colour name strings
    -- },
    -- matchup = { -- vim-matchup config
    --     enable = true,              -- mandatory, false will disable the whole extension
    --     disable = {},  -- optional, list of language that will be disabled
    --     -- [options]
    -- },
  incremental_selection = {
    enable = true,
    -- this lets you select larger chunks of code to manipulate
    keymaps = {
      init_selection = "<C-n>",
      node_incremental = "<C-n>",
      scope_incremental = "<C-s>",
      node_decremental = "<C-r>",
    },
  },
}

require'nvim-web-devicons'.setup { default = true; }
require("bufferline").setup{}
require'telescope'.setup{
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = require'telescope.actions'.move_selection_next,
                ["<C-k>"] = require'telescope.actions'.move_selection_previous,
            },
        },
    },
    extensions = {
      file_browser = {
      },
      coc = {
        theme = 'ivy',
        prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
      }
    }
}
require("telescope").load_extension "file_browser"
require('telescope').load_extension('coc')

-- hex colors
require'colorizer'.setup()

-- hop - keybinds are in init.vim
require'hop'.setup { }
