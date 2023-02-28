-- global
local hyper = { "cmd", "alt", "ctrl", "shift" }
local log = hs.logger.new('hammerspoon', 'debug')


-- fullscreen
hs.hotkey.bind(hyper, "K", function()
  local win = hs.window.focusedWindow()
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
hs.hotkey.bind(hyper, "J", function()
  local win = hs.window.focusedWindow()
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
hs.hotkey.bind(hyper, "L", function()
  local win = hs.window.focusedWindow()
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
hs.hotkey.bind(hyper, "C", function()
  hs.application.launchOrFocus('Google Chrome')
end)
-- show iterm
hs.hotkey.bind(hyper, "I", function()
  hs.application.launchOrFocus('Iterm')
end)
-- show current spotify track
hs.hotkey.bind(hyper, "Y", function()
  hs.spotify.displayCurrentTrack()
end)
