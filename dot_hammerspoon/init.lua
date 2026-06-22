-- global
local hyper = { "cmd", "alt", "ctrl", "shift" }
local hotkey = require "hs.hotkey"
local window = require "hs.window"
local alert = require "hs.alert"
local application = require "hs.application"
local spotify = require "hs.spotify"
local timer = require "hs.timer"
local notify = require "hs.notify"
local webview = require "hs.webview"
local eventtap = require "hs.eventtap"
local keycodes = require "hs.keycodes"
local drawing = require "hs.drawing"

local hyperHotkeys = {}
local hyperGroups = {
  { id = "apps", title = "Apps" },
  { id = "windows", title = "Windows" },
  { id = "system", title = "System" },
}

local helpView = nil
local helpEscapeTap = nil

local function bindHyper(key, group, label, note, pressedfn)
  local binding = hotkey.bind(hyper, key, pressedfn)

  if binding then
    table.insert(hyperHotkeys, {
      key = key,
      group = group,
      label = label,
      note = note,
    })
  end

  return binding
end

-- fullscreen
bindHyper("K", "windows", "Fullscreen", "Current display", function()
  local win = window.focusedWindow()
  if not win then
    return
  end
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
bindHyper("J", "windows", "Left half", "Current display", function()
  local win = window.focusedWindow()
  if not win then
    return
  end
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
bindHyper("L", "windows", "Right half", "Current display", function()
  local win = window.focusedWindow()
  if not win then
    return
  end
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
bindHyper("N", "windows", "Bottom center", "50% x 50%", function()
  local win = hs.window.focusedWindow()
  if not win then
    return
  end
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
      return app and app:mainWindow() and app:mainWindow():frame()
    end,
    function()
      local app = hs.application.get(appName)
      local win = app:mainWindow()
      if win then
        -- Add a small delay to ensure window is fully ready
        hs.timer.doAfter(0.2, function()
          local targetMonitor
          if monitorType == "external" then
            targetMonitor = hs.screen.find("LG ULTRAWIDE")
          else
            targetMonitor = hs.screen.primaryScreen()
          end
          
          if targetMonitor then
            -- Move window to target monitor first if it's not already there
            if win:screen() ~= targetMonitor then
              win:moveToScreen(targetMonitor)
              -- Wait a bit more after moving to different screen
              hs.timer.doAfter(0.1, function()
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
                win:focus()
              end)
            else
              -- Window is already on target monitor, just resize
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
              win:focus()
            end
          end
        end)
      end
    end,
    0.1 -- Check every 100ms
  )
end

-- show Codex
bindHyper("C", "apps", "Codex", "Launch or focus", function()
  application.launchOrFocus('Codex')
  -- application.launchOrFocus('Google Chrome')
  -- application.launchOrFocus('Claude')
end)
-- show editor
bindHyper("I", "apps", "Claude", "Launch or focus", function()
  application.launchOrFocus('Claude')
end)
bindHyper("T", "apps", "iTerm", "Launch or focus", function()
  -- launchAndPositionApp('WezTerm', "full", "internal")
  -- hs.application.launchOrFocus('WezTerm')
  -- hs.application.launchOrFocus('Ghostty')
  hs.application.launchOrFocus('iTerm')
end)
-- show current spotify track
bindHyper("Y", "apps", "Spotify track", "Show current", function()
  spotify.displayCurrentTrack()
end)

bindHyper("O", "apps", "Obsidian", "Launch or focus", function()
  application.launchOrFocus('Obsidian')
end)
bindHyper("D", "apps", "DataGrip", "Right external", function()
  launchAndPositionApp('DataGrip', "right", "external")
end)

bindHyper("S", "apps", "Slack", "Full built-in", function()
  -- application.launchOrFocus('Slack')
  launchAndPositionApp('Slack', 'full', 'internal')
end)

bindHyper("G", "apps", "ChatGPT", "Launch or focus", function()
  application.launchOrFocus('ChatGPT')
end)

-- Lock computer
bindHyper("Q", "system", "Lock computer", "Immediate lock", function()
  hs.caffeinate.lockScreen()
end)

-- alert and hopefully override default period
--hotkey.bind(hyper, ".", function()
--  hs.alert.show("Override default period")
--end)

-- i don't have meetings that much anymore
-- hotkey.bind(hyper, "M", function()
--   local shortcutName = "Meeting"
--   local command = 'shortcuts run "' .. shortcutName .. '"'
--   hs.execute(command)
-- end)

-- Reload Hammerspoon configuration
bindHyper("R", "system", "Reload config", "hs.reload()", function()
  -- hs.alert.show("Hammerspoon config reloaded")
  hs.reload()
end)


-- top half
bindHyper("U", "windows", "Top half", "Current display", function()
  local win = window.focusedWindow()
  if not win then
    return
  end
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)
-- 
-- hotkey.bind(hyper, "P", function()
--   local filePath = os.getenv("HOME") .. "/.password"
--   local file = io.open(filePath, "r")
--   if file then
--     local content = file:read("*all")
--     file:close()
--     content = content:gsub("^%s*(.-)%s*$", "%1")
--     hs.pasteboard.setContents(content)
--     hs.alert.show("Password copied to clipboard")
--   else
--     hs.alert.show("Failed to open password file")
--   end
-- end)

-- Function to move the current window to the external monitor named "LG ULTRAWIDE"
bindHyper("E", "windows", "External full", "LG Ultrawide", function()
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

function centerHalfHeightExternal()
  local win = hs.window.focusedWindow()
  if not win then return end
  
  -- Find LG ULTRAWIDE specifically
  local external = hs.screen.find("LG ULTRAWIDE")
  
  if external then
      -- Get external screen frame
      local frame = external:frame()
      -- Keep current width
      local currentWidth = win:frame().w
      -- Calculate half height
      local newHeight = frame.h / 2
      
      win:setFrame({
          x = frame.x + (frame.w - currentWidth) / 2, -- center horizontally
          y = frame.y + (frame.h - newHeight) / 2,    -- center vertically
          w = currentWidth,                           -- keep current width
          h = newHeight                               -- half height
      })
  else
      -- Fallback to regular centerHalfHeight if no external monitor
      centerHalfHeight()
  end
end

-- Add this to your key bindings section
bindHyper("V", "windows", "External middle", "Half height", centerHalfHeightExternal)

-- Add this to your key bindings section
bindHyper("B", "windows", "External center", "Half width", centerHalfExternal)

-- center 2/3 width
bindHyper("M", "windows", "Center width", "Two-thirds", function()
  local win = window.focusedWindow()
  if not win then return end

  local max = win:screen():frame()
  local w = max.w * (2 / 3)

  win:setFrame({
    x = max.x + (max.w - w) / 2,
    y = max.y,
    w = w,
    h = max.h
  })
end)


-- Function to move the current window to the built-in monitor and make it take the full width and height of the screen
bindHyper("F", "windows", "Built-in full", "Primary display", function()
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

-- nope
-- local username = "josh.anyan@crossbar.org"
-- local passwordFilePath = os.getenv("HOME") .. "/.password"
-- 
-- hs.hotkey.bind(hyper, "A", function()
--     -- Read password from file
--     local file = io.open(passwordFilePath, "r")
--     if not file then
--         hs.alert.show("Failed to open password file")
--         return
--     end
-- 
--     local password = file:read("*all"):gsub("^%s*(.-)%s*$", "%1")
--     file:close()
-- 
--     -- Create the osascript command with proper escaping
--     local script = string.format([[
--     osascript <<EOF
--     tell application "Google Chrome"
--         set t to active tab of window 1
--         execute t javascript "
--             (function() {
--                 var form = document.getElementById('login_form');
--                 if (form) {
--                     var emailInput = form.querySelector('input[name=\"email\"]');
--                     var passwordInput = form.querySelector('input[name=\"password\"]');
--                     if (emailInput && passwordInput) {
--                         emailInput.value = '%s';
--                         passwordInput.value = '%s';
--                         form.submit();
--                     } else {
--                         alert('Email or password input not found.');
--                     }
--                 } else {
--                     alert('Login form not found.');
--                 }
--             })();
--         "
--     end tell
--     EOF
--     ]], username, password)
-- 
--     -- Execute the script
--     local success, output, rawOutput = hs.execute(script)
--     if not success then
--         hs.alert.show("Login script failed")
--     end
-- end)

local function escapeHtml(value)
  local escaped = tostring(value or "")
  escaped = escaped:gsub("&", "&amp;")
  escaped = escaped:gsub("<", "&lt;")
  escaped = escaped:gsub(">", "&gt;")
  escaped = escaped:gsub('"', "&quot;")
  escaped = escaped:gsub("'", "&#39;")
  return escaped
end

local function buildShortcutGroupsHtml()
  local parts = {}

  for _, group in ipairs(hyperGroups) do
    table.insert(parts, '<section class="group ' .. escapeHtml(group.id) .. '">')
    table.insert(parts, "<h2>" .. escapeHtml(group.title) .. "</h2>")
    table.insert(parts, '<div class="list">')

    for _, shortcut in ipairs(hyperHotkeys) do
      if shortcut.group == group.id then
        table.insert(parts, '<div class="item">')
        table.insert(parts, '<div class="key">' .. escapeHtml(shortcut.key) .. "</div>")
        table.insert(parts, "<div>")
        table.insert(parts, '<div class="label">' .. escapeHtml(shortcut.label) .. "</div>")
        table.insert(parts, '<div class="note">' .. escapeHtml(shortcut.note) .. "</div>")
        table.insert(parts, "</div>")
        table.insert(parts, "</div>")
      end
    end

    table.insert(parts, "</div>")
    table.insert(parts, "</section>")
  end

  return table.concat(parts, "\n")
end

local function clamp(value, minValue, maxValue)
  return math.max(minValue, math.min(maxValue, value))
end

local function buildHyperHelpHtml(uiScale)
  local rootFontSize = string.format("%.1fpx", 16 * (uiScale or 1))

  return [=[
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    :root {
      color-scheme: dark;
      font-size: ]=] .. rootFontSize .. [=[;
      --panel: rgba(25, 27, 31, 0.94);
      --row: rgba(255, 255, 255, 0.045);
      --row-hot: rgba(255, 255, 255, 0.075);
      --line: rgba(255, 255, 255, 0.12);
      --text: #f3f1eb;
      --muted: rgba(243, 241, 235, 0.62);
      --quiet: rgba(243, 241, 235, 0.42);
      --green: #62d8ac;
      --blue: #7eb0ff;
      --gold: #edc46f;
      font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Segoe UI", sans-serif;
    }

    * {
      box-sizing: border-box;
    }

    html,
    body {
      width: 100%;
      height: 100%;
      margin: 0;
      overflow: hidden;
      background: transparent;
      color: var(--text);
    }

    body {
      display: grid;
      place-items: center;
      padding: 0.625rem;
    }

    .overlay {
      width: 100%;
      border: 1px solid var(--line);
      border-radius: 1rem;
      overflow: hidden;
      background: var(--panel);
      box-shadow: 0 30px 90px rgba(0, 0, 0, 0.48), inset 0 1px 0 rgba(255, 255, 255, 0.07);
      -webkit-backdrop-filter: blur(22px);
      backdrop-filter: blur(22px);
    }

    .top {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1rem;
      padding: 0.9375rem 1.0625rem 0.875rem;
      border-bottom: 1px solid var(--line);
      background: rgba(255, 255, 255, 0.035);
    }

    .brand {
      display: grid;
      grid-template-columns: auto 1fr;
      align-items: center;
      gap: 0.6875rem;
      min-width: 0;
    }

    .badge {
      width: 2rem;
      height: 2rem;
      display: grid;
      place-items: center;
      border: 1px solid rgba(255, 255, 255, 0.14);
      border-radius: 0.625rem;
      background: linear-gradient(135deg, rgba(98, 216, 172, 0.24), rgba(126, 176, 255, 0.16));
      color: var(--green);
      font-weight: 850;
    }

    h1 {
      margin: 0;
      font-size: 1.0625rem;
      line-height: 1.1;
      letter-spacing: 0;
    }

    .subtitle {
      margin-top: 0.1875rem;
      color: var(--muted);
      font-size: 0.75rem;
      line-height: 1.25;
    }

    .chord {
      color: var(--quiet);
      font-size: 0.75rem;
      white-space: nowrap;
    }

    .body {
      display: grid;
      grid-template-columns: 1fr 1.35fr 0.78fr;
      gap: 0.8125rem;
      padding: 1rem;
    }

    .group {
      min-width: 0;
    }

    .group h2 {
      margin: 0 0 0.5rem;
      color: var(--quiet);
      font-size: 0.625rem;
      font-weight: 800;
      letter-spacing: 0.1em;
      line-height: 1.1;
      text-transform: uppercase;
    }

    .list {
      display: grid;
      gap: 0.375rem;
    }

    .apps .list,
    .windows .list {
      grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .item {
      min-height: 2.25rem;
      display: grid;
      grid-template-columns: 1.875rem 1fr;
      align-items: center;
      gap: 0.5625rem;
      padding: 0.3125rem 0.5rem 0.3125rem 0.3125rem;
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 0.5625rem;
      background: var(--row);
    }

    .item:hover {
      background: var(--row-hot);
    }

    .key {
      width: 1.875rem;
      height: 1.625rem;
      display: grid;
      place-items: center;
      border: 1px solid rgba(255, 255, 255, 0.15);
      border-radius: 0.4375rem;
      background: rgba(255, 255, 255, 0.07);
      box-shadow: inset 0 -1px 0 rgba(0, 0, 0, 0.38);
      color: var(--text);
      font-family: "SF Mono", Menlo, monospace;
      font-size: 0.8125rem;
      font-weight: 800;
    }

    .apps .key {
      color: var(--green);
    }

    .windows .key {
      color: var(--blue);
    }

    .system .key {
      color: var(--gold);
    }

    .label {
      min-width: 0;
      overflow: hidden;
      color: var(--text);
      font-size: 0.75rem;
      font-weight: 720;
      line-height: 1.2;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .note {
      margin-top: 0.0625rem;
      overflow: hidden;
      color: var(--quiet);
      font-size: 0.65625rem;
      line-height: 1.2;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .foot {
      display: flex;
      justify-content: space-between;
      gap: 0.875rem;
      padding: 0.6875rem 1rem 0.8125rem;
      border-top: 1px solid var(--line);
      background: rgba(0, 0, 0, 0.12);
      color: var(--quiet);
      font-size: 0.71875rem;
      line-height: 1.3;
    }

    .live {
      color: var(--green);
      font-weight: 760;
    }

    @media (max-width: 760px) {
      html,
      body {
        overflow: auto;
      }

      .body {
        grid-template-columns: 1fr;
      }

      .system .list {
        grid-template-columns: 1fr;
      }

      .chord {
        display: none;
      }
    }

    @media (max-width: 430px) {
      .apps .list,
      .windows .list {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>
  <section class="overlay" aria-label="Hyper help">
    <header class="top">
      <div class="brand">
        <div class="badge">H</div>
        <div>
          <h1>Hyper Help</h1>
          <div class="subtitle">]=] .. #hyperHotkeys .. [=[ active shortcuts from the current registry</div>
        </div>
      </div>
      <div class="chord">hyper + H</div>
    </header>
    <div class="body">
]=] .. buildShortcutGroupsHtml() .. [=[
    </div>
    <footer class="foot">
      <div><span class="live">Available now</span>: generated from enabled bindings.</div>
      <div>Esc closes</div>
    </footer>
  </section>
</body>
</html>
]=]
end

local function clearHyperHelpState()
  if helpEscapeTap then
    helpEscapeTap:stop()
    helpEscapeTap = nil
  end

  helpView = nil
end

local function hideHyperHelp()
  local view = helpView
  clearHyperHelpState()

  if view then
    view:delete(false, 0.08)
  end
end

local function showHyperHelp()
  if helpView and helpView:isVisible() then
    helpView:bringToFront(true)
    return
  end

  if helpView then
    hideHyperHelp()
  end

  local focusedWindow = window.focusedWindow()
  local targetScreen = focusedWindow and focusedWindow:screen() or hs.screen.mainScreen()
  local frame = targetScreen:frame()
  local uiScale = clamp(math.min(frame.w / 1512, frame.h / 982), 0.82, 1.32)
  local availableWidth = math.max(360, frame.w - 48)
  local availableHeight = math.max(360, frame.h - 48)
  local helpWidth = math.floor(math.min(availableWidth, 1680 * uiScale, frame.w * 0.78))
  local helpHeight = math.floor(math.min(availableHeight, 780 * uiScale, math.max(540 * uiScale, frame.h * 0.68)))

  helpView = webview.new({
    x = frame.x + (frame.w - helpWidth) / 2,
    y = frame.y + (frame.h - helpHeight) / 2,
    w = helpWidth,
    h = helpHeight,
  }, {
    javaScriptEnabled = false,
    javaScriptCanOpenWindowsAutomatically = false,
  })

  helpView:windowStyle({ "borderless" })
  helpView:deleteOnClose(true)
  helpView:transparent(true)
  helpView:shadow(false)
  helpView:level(drawing.windowLevels.floating)
  helpView:windowCallback(function(action)
    if action == "closing" then
      clearHyperHelpState()
    end
  end)
  helpView:html(buildHyperHelpHtml(uiScale))

  helpEscapeTap = eventtap.new({ eventtap.event.types.keyDown }, function(event)
    if event:getKeyCode() == keycodes.map.escape then
      hideHyperHelp()
      return true
    end

    return false
  end)

  helpEscapeTap:start()
  helpView:show(0.08):bringToFront(true)
end

bindHyper("H", "system", "Show help", "Escape to close", showHyperHelp)
