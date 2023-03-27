-- global
local hyper = { "cmd", "alt", "ctrl", "shift" }
local hotkey = require "hs.hotkey"
local window = require "hs.window"
local alert = require "hs.alert"
local application = require "hs.application"
local spotify = require "hs.spotify"
local timer = require "hs.timer"
local notify = require "hs.notify"

-- fullscreen
hotkey.bind(hyper, "K", function()
  local win = window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)

-- left
hotkey.bind(hyper, "J", function()
  local win = window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- right
hotkey.bind(hyper, "L", function()
  local win = window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  -- new macbook is 755, previous was 740
  f.x = 755 -- max.x / 2
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- show firefox
hotkey.bind(hyper, "C", function()
  application.launchOrFocus('Google Chrome')
end)
-- show kitty terminal
hotkey.bind(hyper, "T", function()
  application.launchOrFocus('kitty')
end)
-- show current spotify track
hotkey.bind(hyper, "Y", function()
  spotify.displayCurrentTrack()
end)

hotkey.bind(hyper, "O", function()
  application.launchOrFocus('Obsidian')
end)

hotkey.bind(hyper, "D", function()
  application.launchOrFocus('DataGrip')
end)

hotkey.bind(hyper, "S", function()
  application.launchOrFocus('Slack')
end)

hotkey.bind(hyper, "H", function()
  alert.show(
    "C - Chrome\nT - Kitty\nY - Spotify\nO - Obsidian\nD - DataGrip\nS - Slack\nR - Restart BetterTouchTool\nH - Help")
end)

function restartApp(appName)
  local app = application.find(appName)

  if app then
    app:kill() -- Terminate the app
    timer.doAfter(1, function() -- Wait for a second
      application.open(appName) -- Launch the app again
    end)
  else
    notify.show("Application not found", "", "The application '" .. appName .. "' is not running or not found.")
  end
end

-- restart BetterTouchTool
hotkey.bind(hyper, "R", function()
  restartApp('BetterTouchTool')
end)
