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


function launchAndPositionApp(appName, screenPosition, monitorType)
  -- Launch or focus the application
  hs.application.launchOrFocus(appName)
  
  -- Repeatedly check until the application window is available
  hs.timer.waitUntil(
    function()
      local app = hs.application.get(appName)
      return app and app:mainWindow()
    end,
    function()
      local app = hs.application.get(appName)
      local win = app:mainWindow()
      if win then
        local targetMonitor
        if monitorType == "external" then
          targetMonitor = hs.screen.find("LG ULTRAWIDE")
        else
          targetMonitor = hs.screen.primaryScreen()
        end
        
        if targetMonitor then
          local f = win:frame()
          local max = targetMonitor:frame()

          if screenPosition == "full" then
            f.x, f.y, f.w, f.h = max.x, max.y, max.w, max.h
          elseif screenPosition == "left" then
            f.x, f.y, f.w, f.h = max.x, max.y, max.w / 2, max.h
          elseif screenPosition == "right" then
            f.x, f.y, f.w, f.h = max.x + (max.w / 2), max.y, max.w / 2, max.h
          end
          
          win:setFrame(f)
        end
        win:focus()
      end
    end,
    0.1 -- Check every 100ms
  )
end

-- show chrome
hotkey.bind(hyper, "C", function()
  -- application.launchOrFocus('Google Chrome')
  application.launchOrFocus('Claude')
end)
-- show edItor (currently cursor)
hotkey.bind(hyper, "I", function()
  launchAndPositionApp('Cursor', "full", "external")
end)
-- show kitty terminal
hotkey.bind(hyper, "T", function()
  -- launchAndPositionApp('WezTerm', "full", "internal")
  -- hs.application.launchOrFocus('WezTerm')
  hs.application.launchOrFocus('Ghostty')
end)
-- show current spotify track
hotkey.bind(hyper, "Y", function()
  spotify.displayCurrentTrack()
end)

hotkey.bind(hyper, "O", function()
  application.launchOrFocus('Obsidian')
end)
hotkey.bind(hyper, "D", function()
  launchAndPositionApp('DataGrip', "right", "external")
end)

hotkey.bind(hyper, "S", function()
  -- application.launchOrFocus('Slack')
  launchAndPositionApp('Slack', 'full', 'internal')
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
  hs.pasteboard.setContents("josh.anyan@crossbar.org")
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


-- Add this new function near your other window management functions
function centerHalfExternal()
    local win = hs.window.focusedWindow()
    if not win then return end
    
    -- Find LG ULTRAWIDE specifically
    local external = hs.screen.find("LG ULTRAWIDE")
    
    if external then
        -- Get external screen frame
        local frame = external:frame()
        -- Calculate one third width
        local newWidth = frame.w / 2
        -- Center the window
        local newX = frame.x + (frame.w - newWidth) / 2
        
        win:setFrame({
            x = newX,
            y = frame.y,
            w = newWidth,
            h = frame.h
        })
    else
        -- Maximize on current screen if no external monitor
        win:maximize()
    end
end

-- Add this to your key bindings section
hs.hotkey.bind(hyper, "B", centerHalfExternal)

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

local username = "josh.anyan@crossbar.org"
local passwordFilePath = os.getenv("HOME") .. "/.password"

hs.hotkey.bind(hyper, "A", function()
    -- Read password from file
    local file = io.open(passwordFilePath, "r")
    if not file then
        hs.alert.show("Failed to open password file")
        return
    end

    local password = file:read("*all"):gsub("^%s*(.-)%s*$", "%1")
    file:close()

    -- Create the osascript command with proper escaping
    local script = string.format([[
    osascript <<EOF
    tell application "Google Chrome"
        set t to active tab of window 1
        execute t javascript "
            (function() {
                var form = document.getElementById('login_form');
                if (form) {
                    var emailInput = form.querySelector('input[name=\"email\"]');
                    var passwordInput = form.querySelector('input[name=\"password\"]');
                    if (emailInput && passwordInput) {
                        emailInput.value = '%s';
                        passwordInput.value = '%s';
                        form.submit();
                    } else {
                        alert('Email or password input not found.');
                    }
                } else {
                    alert('Login form not found.');
                }
            })();
        "
    end tell
    EOF
    ]], username, password)

    -- Execute the script
    local success, output, rawOutput = hs.execute(script)
    if not success then
        hs.alert.show("Login script failed")
    end
end)

hotkey.bind(hyper, "H", function()
  alert.show(
    "C - Chrome\n" ..
    "I - IDE (Editor)\n" ..
    "T - Terminal\n" ..
    "Y - Spotify\n" ..
    "O - Obsidian\n" ..
    "D - DataGrip\n" ..
    "S - Slack\n" ..
    "R - Reload Hammerspoon config\n" ..
    "H - Help\n" ..
    "B - Center window on external monitor\n" ..
    "E - Move window to External Display\n" ..
    "F - Move window to Primary Built-in Retina Display\n" ..
    "M - Toggle Meeting focus\n" ..
    "U - Copy username\n" ..
    "P - Copy password\n" ..
    "Q - Lock Computer"
    )
end)
