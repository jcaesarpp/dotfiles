-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local vicious = require("vicious")

awful.spawn.with_shell("sleep 2 ; unagi &!")
awful.spawn.with_shell("sleep 2 ; fehw.sh l &!")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/jc/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

local current_user = 'jcpp'
local screensaver = terminal .. ' -fullscreen -class screensaver -e asciiquarium'
local explorer = terminal .. ' -title explorer -class explorer -e ranger'
local taskmanager = terminal .. ' -fullscreen -class taskmanager -title taskmanager -e htop -u ' .. current_user
local audiocontrol = terminal .. ' -title audiocontrol -class audiocontrol -e alsamixer -c 1 -V all'
local wicdcurses = terminal .. ' -title wicdcurses -class wicdcurses -e wicd-curses'

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
widget_clock = wibox.widget.textclock('%R')
widget_clock_icon = wibox.widget.imagebox(beautiful.clock)
widget_clock_tooltip = awful.tooltip({
    objects = { widget_clock, widget_clock_icon },
	timer_function = function()
        return os.date("%A %d, %B %Y") .. '\nUptime: ' .. widget_uptime.text .. '\n\n' .. io.popen('/usr/local/bin/todo.sh'):read("*all")
    end,
})

widget_volume = wibox.widget.textbox()
vicious.register(widget_volume, vicious.widgets.volume, "$1", 61, "Master")

widget_volume_status = wibox.widget.textbox()
vicious.register(widget_volume_status, vicious.widgets.volume, "$2", 61, "Master")

widget_volume_icon = wibox.widget.imagebox()
widget_volume_tooltip = awful.tooltip({
    objects = { widget_volume_icon },
	timer_function = function()
        return 'Volume: ' .. widget_volume.text
    end,
})

function updateVolume()
    vicious.force({ widget_volume, widget_volume_status })
    volume_value = tonumber(widget_volume.text)
    volume_icon = beautiful.volume_off

    if volume_value > 100 then
        awful.spawn.with_shell('pactl set-sink-volume 0 100%')
        vicious.force({ widget_volume, widget_volume_status })
        volume_value = tonumber(widget_volume.text)
    end

    if widget_volume_status.text == "♩" then
        volume_icon = beautiful.volume_muted
    else
        if volume_value <= 25 then
            volume_icon = beautiful.volume_off
        elseif volume_value <= 45 then
            volume_icon = beautiful.volume_low
        elseif volume_value <= 75 then
            volume_icon = beautiful.volume_medium
        else
            volume_icon = beautiful.volume_high
        end
    end

    widget_volume_icon.image = volume_icon
end
awful.widget.watch("awesome-client 'updateVolume()'", 16)

local function changeVolume(action)
    if action == '*' then
        awful.spawn('pactl set-sink-mute 0 toggle')
    else
        awful.spawn('pactl set-sink-mute 0 0')
        if action == '+' then
            awful.spawn('pactl set-sink-volume 0 +5%')
        elseif action == '-' then
            awful.spawn('pactl set-sink-volume 0 -5%')
        end
    end
    updateVolume()
end

widget_volume_icon:buttons(awful.util.table.join(
	awful.button({ }, 1, function() awful.spawn(audiocontrol) end),
	awful.button({ }, 3, function() changeVolume('*') end),
	awful.button({ }, 4, function() changeVolume('+') end),
	awful.button({ }, 5, function() changeVolume('-') end)
))

widget_wireless_ssid = wibox.widget.textbox()
vicious.register(widget_wireless_ssid, vicious.widgets.wifi, '${ssid}', 61, "wlp2s0")

widget_wireless_linp = wibox.widget.textbox()
vicious.register(widget_wireless_linp, vicious.widgets.wifi, '${linp}', 61, "wlp2s0")

widget_wireless_icon = wibox.widget.imagebox()
widget_wireless_tooltip = awful.tooltip({
    objects = { widget_wireless_icon },
	timer_function = function()
        return  'Wireless: ' .. widget_wireless_linp.text .. '\n' .. widget_wireless_ssid.text
    end,
})
widget_wireless_icon:buttons(awful.util.table.join( awful.button({ }, 1, function() awful.spawn(wicdcurses) end)))
function updateWireless()
    vicious.force({ widget_wireless_ssid, widget_wireless_linp })
    wireless_linp = tonumber(widget_wireless_linp.text)

    if widget_wireless_ssid.text == "N/A" then
        wireless_icon = beautiful.wireless_disconnected
    else
        if wireless_linp < 5 then
            wireless_icon = beautiful.wireless_none
        elseif wireless_linp < 35 then
            wireless_icon = beautiful.wireless_low
        elseif wireless_linp < 65 then
            wireless_icon = beautiful.wireless_medium
        elseif wireless_linp < 95 then
            wireless_icon = beautiful.wireless_high
        else
            wireless_icon = beautiful.wireless_full
        end
    end

    widget_wireless_icon.image = wireless_icon
end
awful.widget.watch("awesome-client 'updateWireless()'", 16)

widget_uptime = wibox.widget.textbox()
vicious.register(widget_uptime, vicious.widgets.uptime, '$1 $2 $3', 61)

widget_uptime_load = wibox.widget.textbox()
vicious.register(widget_uptime_load, vicious.widgets.uptime, '$4 $5 $6', 61)

widget_weather = wibox.widget.textbox()
-- Carrasco Uruguay
--vicious.register(widget_weather, vicious.widgets.weather, 'weather { ${city} ${tempc} ${humid} }', 900, "SUMU")
widget_weather_icon = wibox.widget.imagebox()
widget_weather_tooltip = awful.tooltip({ objects = { widget_weather, widget_weather_icon }, })
awful.widget.watch("openweathermap.sh", 1801)

widget_battery_status = wibox.widget.textbox()
vicious.register(widget_battery_status, vicious.widgets.bat, "$1", 61, "BAT0")
widget_battery_status_text = ''

widget_battery_value = wibox.widget.textbox()
vicious.register(widget_battery_value, vicious.widgets.bat, "$2", 61, "BAT0")

widget_battery_remaining = wibox.widget.textbox()
vicious.register(widget_battery_remaining, vicious.widgets.bat, "$3", 61, "BAT0")

widget_battery_icon = wibox.widget.imagebox()
widget_battery_tooltip = awful.tooltip({
    objects = { widget_battery_icon },
	timer_function = function()
        return widget_battery_status_text .. ': ' .. widget_battery_value.text .. '\nRemaining: ' .. widget_battery_remaining.text
    end,
})

function updateBattery()
    battery_value = tonumber(widget_battery_value.text)
    battery_icon = beautiful.battery_000

    if widget_battery_status.text == '+' then
        widget_battery_status_text = 'Charging'
    elseif widget_battery_status.text == '-' then
        widget_battery_status_text = 'Discharging'
    else
        widget_battery_status_text = 'Charged'
    end

    if battery_value < 10 then
        if widget_battery_status.text == '+' then
            battery_icon = beautiful.battery_000_charging
        else
            battery_icon = beautiful.battery_000
        end
    elseif battery_value < 30 then
        if widget_battery_status.text == '+' then
            battery_icon = beautiful.battery_020_charging
        else
            battery_icon = beautiful.battery_020
        end
    elseif battery_value < 50 then
        if widget_battery_status.text == '+' then
            battery_icon = beautiful.battery_040_charging
        else
            battery_icon = beautiful.battery_040
        end
    elseif battery_value < 70 then
        if widget_battery_status.text == '+' then
            battery_icon = beautiful.battery_060_charging
        else
            battery_icon = beautiful.battery_060
        end
    elseif battery_value < 90 then
        if widget_battery_status.text == '+' then
            battery_icon = beautiful.battery_080_charging
        else
            battery_icon = beautiful.battery_080
        end
    else
        if widget_battery_status.text == '+' then
            battery_icon = beautiful.battery_100_charging
        elseif widget_battery_status.text == '-' then
            battery_icon = beautiful.battery_100
        else
            battery_icon = beautiful.battery_100_charged
        end
    end

    widget_battery_icon.image = battery_icon
end
awful.widget.watch("awesome-client 'updateBattery()'", 16)

widget_ram = wibox.widget.textbox()
vicious.register(widget_ram, vicious.widgets.mem, "$1", 11)

widget_ram_icon = wibox.widget.imagebox(beautiful.ram)

widget_cpu = wibox.widget.textbox()
vicious.register(widget_cpu, vicious.widgets.cpu, "$1", 11)

widget_cpu_icon = wibox.widget.imagebox(beautiful.cpu)

widget_brightness_icon = wibox.widget.imagebox(beautiful.brightness)
widget_brightness_icon_level = wibox.widget.imagebox()

widget_brightness_tooltip = awful.tooltip({
    objects = { widget_brightness_icon, widget_brightness_icon_level },
	timer_function = function()
        return 'Brightness: ' .. io.popen('printf "%.0f" `xbacklight -get`'):read("*all")
    end,
})
function updateBrightness()
    brightness_value = tonumber(io.popen('sleep 1; printf "%.0f" `xbacklight -get`'):read("*all"))

    if brightness_value < 10 then
        brightness_icon_level = beautiful.brightness_010
    elseif brightness_value < 20 then
        brightness_icon_level = beautiful.brightness_020
    elseif brightness_value < 30 then
        brightness_icon_level = beautiful.brightness_030
    elseif brightness_value < 40 then
        brightness_icon_level = beautiful.brightness_040
    elseif brightness_value < 50 then
        brightness_icon_level = beautiful.brightness_050
    elseif brightness_value < 60 then
        brightness_icon_level = beautiful.brightness_060
    elseif brightness_value < 70 then
        brightness_icon_level = beautiful.brightness_070
    elseif brightness_value < 80 then
        brightness_icon_level = beautiful.brightness_080
    elseif brightness_value < 90 then
        brightness_icon_level = beautiful.brightness_090
    else
        brightness_icon_level = beautiful.brightness_100
    end

    widget_brightness_icon_level.image = brightness_icon_level
end
awful.widget.watch("awesome-client 'updateBrightness()'", 31)

local function changeBrightness(value)
    if value == 'f' then
        awful.spawn('xbacklight =100')
    elseif value == 't' then
        awful.spawn('xbacklight =75')
    elseif value == 'q' then
        awful.spawn('xbacklight =25')
    elseif value == 'm' then
        awful.spawn('xbacklight =50')
    elseif value == '+' then
        awful.spawn('xbacklight +5')
    elseif value == '-' then
        awful.spawn('xbacklight -5')
    end
    updateBrightness()
end

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "f", "e", "w", "n", "c", "d", "r", "v", "m" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s , height = 20 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --mylauncher,
            s.mylayoutbox,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            widget_cpu_icon,
            widget_cpu,
            widget_ram_icon,
            widget_ram,
            widget_weather_icon,
            widget_weather,
            widget_brightness_icon,
            widget_brightness_icon_level,
            widget_wireless_icon,
            widget_clock_icon,
            widget_clock,
            widget_battery_icon,
            widget_volume_icon,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    -- custom keys
    awful.key({ "Control", "Shift" }, "Escape", function () awful.spawn(taskmanager) end,
        {description = "taskmanager", group = "taskmanager"}),
    awful.key({ modkey }, "e", function () awful.spawn(explorer) end,
        {description = "Explorer", group = "explorer"}),

    awful.key({ }, "XF86AudioRaiseVolume", function() changeVolume('+') end,
        {description = "Volume Up", group = "volume"}),
    awful.key({ }, "XF86AudioLowerVolume", function() changeVolume('-') end,
        {description = "Volume Down", group = "volume"}),
    awful.key({ }, "XF86AudioMute", function() changeVolume('*') end,
        {description = "Volume Toggle", group = "volume"}),

    awful.key({ modkey }, "Pause", function() awful.spawn(screensaver) end,
              {description = "Screensaver", group = "screensaver"}),

    awful.key({ }, "XF86MonBrightnessUp", function() changeBrightness('+') end,
              {description = "Brightness Up", group = "brightness"}),
    awful.key({ "Control" }, "XF86MonBrightnessUp", function() changeBrightness('f') end,
              {description = "Brightness Full", group = "brightness"}),
    awful.key({ "Shift" }, "XF86MonBrightnessUp", function() changeBrightness('t') end,
              {description = "Brightness T", group = "brightness"}),
    awful.key({ }, "XF86MonBrightnessDown", function() changeBrightness('-') end,
              {description = "Brightness Down", group = "brightness"}),
    awful.key({ "Control" }, "XF86MonBrightnessDown", function() changeBrightness('m') end,
              {description = "Brightness Medium", group = "brightness"}),
    awful.key({ "Shift" }, "XF86MonBrightnessDown", function() changeBrightness('q') end,
              {description = "Brightness Q", group = "brightness"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    { rule = { class = "UXTerm" }, properties = { opacity = 0.95 } },
    { rule = { class = "XTerm" }, properties = { opacity = 0.95 } },
    { rule = { class = "Firefox" }, properties = { tag = "w" } },
    { rule = { class = "Zathura" }, properties = { tag = "r" } },
    { rule = { class = "Spotify" }, properties = { tag = "m" } },
    { rule = { class = "audiocontrol" }, properties = { opacity = 0.9 } },
    { rule = { class = "explorer" }, properties = { tag = "f", floating = true, opacity = 0.95 } },
    { rule = { class = "screensaver" }, properties = { opacity = 0.25 } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

