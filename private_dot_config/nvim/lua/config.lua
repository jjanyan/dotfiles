-- treesitter / TS
require 'nvim-treesitter.configs'.setup {
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
  matchup = { -- vim-matchup config
    enable = true, -- mandatory, false will disable the whole extension
    disable = {}, -- optional, list of language that will be disabled
    -- [options]
  },
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

-- require('mini.surround').setup()
require 'nvim-web-devicons'.setup { default = true, }
require("bufferline").setup {}
require 'telescope'.setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = require 'telescope.actions'.move_selection_next,
        ["<C-k>"] = require 'telescope.actions'.move_selection_previous,
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
  },
  pickers = {
    colorscheme = {
      enable_preview = true
    }
  }
}
require("telescope").load_extension "file_browser"
require('telescope').load_extension('coc')
require("telescope").load_extension("emoji")

-- hex colors
require 'colorizer'.setup()

-- sessions
require("persisted").setup({
  use_git_branch = true,
  autoload = true,
})
require("telescope").load_extension("persisted")

-- hop - keybinds are in init.vim
require 'hop'.setup {}


-- local quotes = {
--   { "'", "'" },
--   { '"', '"' },
--   { "`", "`" },
-- }
-- local cycle_quotes = require("ts-node-action.actions.cycle_quotes")(quotes)
-- require("ts-node-action").setup({
--   typescript = {
--     ["string"] = cycle_quotes,
--   },
-- })
-- vim.keymap.set({ "n" }, "\"", function() require("ts-node-action").node_action() end, { desc = "Trigger Node Action" })

-- require("smartcolumn").setup({
--   limit_to_window = true,
-- })

require('nvim-treesitter.configs').setup {
  textsubjects = {
    enable = true,
    prev_selection = ',', -- (Optional) keymap to select the previous selection
    keymaps = {
      ['.'] = 'textsubjects-smart',
      [';'] = 'textsubjects-container-outer',
      ['i;'] = 'textsubjects-container-inner',
    },
  },
}

require('mini.indentscope').setup {
  options = {
    border = "top",
  },
  mappings = {
    -- Textobjects
    object_scope = '',
    object_scope_with_border = '',
    -- Motions (jump to respective border line; if not present - body line)
    goto_top = '',
    goto_bottom = '',
  },
}
