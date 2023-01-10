local wezterm = require 'wezterm'
-- ctrl + shift + x = copy mode where i can use vi commands to copy stuff
return {
  keys = {
    -- this is required to open in home directory on new tabs
    { key = "t", mods = "CMD", action = wezterm.action { SpawnCommandInNewTab = {
      cwd = wezterm.home_dir,
    } } },
  },
  font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Medium", stretch = "Normal", style = "Normal" }),
  font_size = 15.0,
  -- color_scheme = "BirdsOfParadise",
  color_scheme = "ChallengerDeep",
  hyperlink_rules = {
    -- Linkify things that look like URLs and the host has a TLD name.
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    -- http://google.com
    {
      regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
      format = '$0',
    },

    -- linkify email addresses
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    -- bob@jones.com
    {
      regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
      format = 'mailto:$0',
    },

    -- file:// URI
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    -- file:///etc/hosts
    {
      regex = [[\bfile://\S*\b]],
      format = '$0',
    },

    -- E.g. http://127.0.0.1:8000 for a local development server,
    -- or http://192.168.1.1 for the web interface of many routers.
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = '$0',
    },

    -- E.g. http://localhost:8000 for a local development server,
    {
      regex = [[\b\w+://localhost:[\d]{1,3}\S*\b]],
      format = '$0',
    },

    -- linkify linear issues- dev-123
    {
      regex = [[([a-zA-Z]{3,}-\d+)]],
      format = 'https://linear.app/crossbar/issue/$1',
    }
  }
}
