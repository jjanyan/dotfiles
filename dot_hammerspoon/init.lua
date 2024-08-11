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

  -- Position the window on the right half of the screen
  f.x = max.x + (max.w / 2) -- This dynamically calculates the x position
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- center bottom with 50% width
hotkey.bind(hyper, "N", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  -- Set width to 50% of screen width
  f.w = max.w * 0.5
  -- Keep height as full height of the screen
  f.h = max.h * 0.5
  -- Center horizontally
  f.x = max.x + (max.w - f.w) / 2
  -- Position at the bottom of the screen
  f.y = max.y + max.h - f.h

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

-- hotkey.bind(hyper, "D", function()
--   application.launchOrFocus('DataGrip')
-- end)
-- Move DataGrip window to the right half of the external monitor if available, otherwise to the right half of the current screen
hotkey.bind(hyper, "D", function()
  -- Launch or focus DataGrip
  hs.application.launchOrFocus('DataGrip')
  
  -- Repeatedly check until the application window is available
  hs.timer.waitUntil(
      function()
          local app = hs.application.get("DataGrip")
          return app and app:mainWindow()
      end,
      function()
          local app = hs.application.get("DataGrip")
          local win = app:mainWindow()
          if win then
              local externalMonitor = hs.screen.find("LG ULTRAWIDE")
              if externalMonitor then
                  local f = win:frame()
                  local max = externalMonitor:frame()

                  f.x = max.x + (max.w / 2) -- Move to right half of the external monitor
                  f.y = max.y
                  f.w = max.w / 2
                  f.h = max.h
                  win:setFrame(f)
              end
              win:focus()
          end
      end,
      0.1 -- Check every 100ms
  )
end)

hotkey.bind(hyper, "S", function()
  application.launchOrFocus('Slack')
end)

hotkey.bind(hyper, "G", function()
  application.launchOrFocus('ChatGPT')
end)

-- Lock computer
hotkey.bind(hyper, "Q", function()
  hs.caffeinate.lockScreen()
end)

hotkey.bind(hyper, "M", function()
  local shortcutName = "Meeting"
  local command = 'shortcuts run "' .. shortcutName .. '"'
  hs.execute(command)
end)

-- Reload Hammerspoon configuration
hotkey.bind(hyper, "R", function()
  -- hs.alert.show("Hammerspoon config reloaded")
  hs.reload()
end)


hotkey.bind(hyper, "U", function()
  hs.pasteboard.setContents("chris.degroat@crossbar.org")
  hs.alert.show("Username copied to clipboard")
end)

hotkey.bind(hyper, "P", function()
  local filePath = os.getenv("HOME") .. "/.password"
  local file = io.open(filePath, "r")
  if file then
    local content = file:read("*all")
    file:close()
    content = content:gsub("^%s*(.-)%s*$", "%1")
    hs.pasteboard.setContents(content)
    hs.alert.show("Password copied to clipboard")
  else
    hs.alert.show("Failed to open password file")
  end
end)

-- Function to move the current window to the external monitor named "LG ULTRAWIDE"
hotkey.bind(hyper, "E", function()
  local externalMonitor = hs.screen.find("LG ULTRAWIDE")
  if externalMonitor then
    local win = hs.window.focusedWindow()
    if win then
      local f = win:frame()
      local max = externalMonitor:frame()

      f.x = max.x
      f.y = max.y
      f.w = max.w
      f.h = max.h
      win:setFrame(f)
      win:focus()
    else
      hs.alert.show("No active window to move")
    end
  else
    hs.alert.show("External monitor 'LG ULTRAWIDE' not found")
  end
end)

-- Function to move the current window to the built-in monitor and make it take the full width and height of the screen
hotkey.bind(hyper, "F", function()
  local builtInMonitor = hs.screen.primaryScreen()  -- This targets the primary screen
  if builtInMonitor then
    local win = hs.window.focusedWindow()
    if win then
      local f = win:frame()
      local max = builtInMonitor:frame()

      f.x = max.x
      f.y = max.y
      f.w = max.w
      f.h = max.h
      win:setFrame(f)
      win:focus()
    else
      hs.alert.show("No active window to move")
    end
  else
    hs.alert.show("Built-in monitor not found")
  end
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

hotkey.bind(hyper, "H", function()
  alert.show(
    "C - Chrome\n" ..
    "T - Kitty\n" ..
    "Y - Spotify\n" ..
    "O - Obsidian\n" ..
    "D - DataGrip\n" ..
    "S - Slack\n" ..
    "R - Reload Hammerspoon config\n" ..
    "H - Help\n" ..
    "E - Move window to External Display\n" ..
    "F - Move window to Primary Built-in Retina Display\n" ..
    "M - Toggle Meeting focus\n" ..
    "U - Copy username\n" ..
    "P - Copy password\n" ..
    "Q - Lock Computer"
    )
end)