local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
beautiful = require("beautiful")
naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local vicious = require("vicious")

require("debian.menu")

awful.spawn("audiocontrol-awm.sh")
awful.spawn("brightness-awm.sh")
awful.spawn("mpd-notify.sh l")

awful.spawn.with_shell("sleep 2 ; unagi &!")
awful.spawn.with_shell("sleep 2 ; fehw.sh l &!")

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

local home = os.getenv("HOME")
beautiful.init(home .. "/.config/awesome/themes/zenburn.jcpp/theme.lua")
local current_user = 'jcpp'

terminal = "x-terminal-emulator"
--editor = os.getenv("EDITOR") or "editor"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor

explorer = terminal .. " -title explorer -class explorer -e ranger"
taskmanager = terminal .. " -fullscreen -title taskmanager -e htop -u " .. current_user
audiocontrol = terminal .. " -fullscreen -title 'audio control' -e audiocontrol-awm.sh a"

volume = ''
volume_toggle = 'audiocontrol-awm.sh t'
volume_up = 'audiocontrol-awm.sh +'
volume_down = 'audiocontrol-awm.sh -'

brightness = ''
brightness_half = 'brightness-awm.sh h'
brightness_max = 'brightness-awm.sh m'
brightness_up = 'brightness-awm.sh +'
brightness_down = 'brightness-awm.sh -'

mpc = 'mpc --no-status '
music_play = mpc .. 'play'
music_pause = mpc .. 'pause'
music_toggle = mpc .. 'toggle'
music_next = mpc .. 'next'
music_prev = mpc .. 'prev'
music_stop = mpc .. 'stop'

modkey = "Mod4"

awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.fair,
}

local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end, beautiful.hotkeys },
   { "manual", terminal .. " -e man awesome", beautiful.manual },
   { "config", editor_cmd .. " " .. awesome.conffile, beautiful.preferences },
   { "restart", awesome.restart, beautiful.restart },
   { "logout", function() awesome.quit() end, beautiful.logout }
}
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "debian", debian.menu.Debian_menu.Debian, beautiful.debian },
                                    { "terminal", terminal, beautiful.terminal }
                                  }
                        })
menubar.utils.terminal = terminal

widget_volume_img = wibox.widget.imagebox(beautiful.audio_volume_muted)
volume_tooltip = awful.tooltip({ objects = { widget_volume_img }, 
	timer_function = function() return 'Volume ' .. volume end, })
widget_volume_img:buttons(awful.util.table.join(
	awful.button({ }, 1, function() awful.spawn(audiocontrol) end),
	awful.button({ }, 3, function() 
		awful.spawn.with_shell(volume_toggle) 
	end),
	awful.button({ }, 4, function() 
		awful.spawn.with_shell(volume_up) 
	end),
	awful.button({ }, 5, function() 
		awful.spawn.with_shell(volume_down) 
	end)
))

widget_brightness_img = wibox.widget.imagebox(beautiful.level_010)
widget_brightness_img_icon = wibox.widget.imagebox(beautiful.brightness)
brightness_tooltip = awful.tooltip({ objects = { widget_brightness_img, widget_brightness_img_icon }, 
	timer_function = function() return 'Brightness ' .. brightness end, })
widget_brightness_img:buttons(awful.util.table.join(
	awful.button({ }, 1, function() 
		awful.spawn.with_shell(brightness_max) 
	end),
	awful.button({ }, 3, function() 
		awful.spawn.with_shell(brightness_half) 
	end),
	awful.button({ }, 4, function() 
		awful.spawn.with_shell(brightness_up) 
	end),
	awful.button({ }, 5, function() 
		awful.spawn.with_shell(brightness_down) 
	end)
))
widget_brightness_img_icon:buttons(widget_brightness_img:buttons())

widget_music_img = wibox.widget.imagebox(beautiful.music)
widget_music_img:buttons(awful.util.table.join(
	awful.button({ }, 1, function() 
		awful.spawn.with_shell(music_toggle) 
	end),
	awful.button({ }, 3, function() 
		awful.spawn.with_shell(music_stop) 
	end),
	awful.button({ }, 4, function() 
		awful.spawn.with_shell(music_next) 
	end),
	awful.button({ }, 5, function() 
		awful.spawn.with_shell(music_prev) 
	end)
))

widget_mpd = wibox.widget.textbox('MPD')
widget_mpd:buttons(widget_music_img:buttons())

widget_battery = wibox.widget.textbox()
vicious.register(widget_battery, vicious.widgets.bat, "$2", 61, "BAT0")
widget_battery_watch = awful.widget.watch('bash -c "battery-awm.sh"', 61)
widget_battery_img = wibox.widget.imagebox(beautiful.battery_000)
battery_tooltip = awful.tooltip({ objects = { widget_battery_img }, 
	timer_function = function() return 'Battery ' .. widget_battery.text .. '%' end, })

widget_clock = wibox.widget.textclock("%R")
widget_clock_img = wibox.widget.imagebox(beautiful.clock)
clock_tooltip = awful.tooltip({ objects = { widget_clock, widget_clock_img }, 
	timer_function = function() return os.date("%A %d, %B %Y") end, })

local taglist_buttons = awful.util.table.join(
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

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag({ "f", "e", "w", "n", "s", "d", "r" }, s, awful.layout.layouts[1])

--    local file = awful.tag.find_by_name(awful.screen.focused(), "f") 
--    file.icon = beautiful.file

    local email = awful.tag.find_by_name(awful.screen.focused(), "e") 
--    email.icon = beautiful.email
    email.layout = awful.layout.layouts[2]

    local browser = awful.tag.find_by_name(awful.screen.focused(), "w") 
--    browser.icon = beautiful.browser
    browser.layout = awful.layout.layouts[2]

    local news = awful.tag.find_by_name(awful.screen.focused(), "n") 
--    news.icon = beautiful.news
    news.layout = awful.layout.layouts[2]

    local social = awful.tag.find_by_name(awful.screen.focused(), "s") 
--    social.icon = beautiful.social
    social.layout = awful.layout.layouts[2]

    local develop = awful.tag.find_by_name(awful.screen.focused(), "d") 
--    develop.icon = beautiful.develop
    develop.layout = awful.layout.layouts[2]

    local read = awful.tag.find_by_name(awful.screen.focused(), "r") 
--    read.icon = beautiful.read
    read.layout = awful.layout.layouts[2]

    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)
    s.mywibox = awful.wibar({ height = 20, position = "top", screen = s })
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
	    widget_music_img,
	    widget_mpd,
	    widget_brightness_img,
	    widget_brightness_img_icon,
            widget_clock_img,
            widget_clock,
	    widget_battery_img,
	    widget_volume_img,
        },
    }
end)

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

globalkeys = awful.util.table.join(
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
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

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
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    awful.key({ modkey }, "q", client_menu_toggle_fn()),
    awful.key({ modkey }, "y", function () awful.spawn.with_shell('fehw.sh') end),
    awful.key({ modkey, "Shift" }, "y", function () awful.spawn.with_shell('fehw.sh d') end),
    awful.key({ modkey }, "e", function () awful.spawn(explorer) end),
    awful.key({ }, "XF86AudioPrev", function () awful.spawn.with_shell(music_prev) end),
    awful.key({ }, "XF86AudioPlay", function () awful.spawn.with_shell(music_toggle) end),
    awful.key({ }, "XF86AudioNext", function () awful.spawn.with_shell(music_next) end),
    awful.key({ }, "XF86AudioMute", function () awful.spawn.with_shell(volume_toggle) end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.spawn.with_shell(volume_down) end),
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.spawn.with_shell(volume_up) end),
    awful.key({ }, "XF86MonBrightnessUp", function () awful.spawn.with_shell(brightness_up) end),
    awful.key({ "Control" }, "XF86MonBrightnessUp", function () awful.spawn.with_shell(brightness_max) end),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.spawn.with_shell(brightness_down) end),
    awful.key({ "Control" }, "XF86MonBrightnessDown", function () awful.spawn.with_shell(brightness_half) end),
    awful.key({ "Control", "Shift" }, "Escape", function () awful.spawn(taskmanager) end)
)

clientkeys = awful.util.table.join(
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
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
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

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

root.keys(globalkeys)

awful.rules.rules = {
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

    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    { rule = { class = "UXTerm" }, properties = { opacity = 0.95 } },
    { rule = { class = "XTerm" }, properties = { opacity = 0.95 } },
    { rule = { class = "Firefox" }, properties = { tag = "w" } },
    { rule = { class = "Kiwix" }, properties = { tag = "w" } },
    { rule = { class = "Zathura" }, properties = { tag = "r" } },
    { rule = { class = "explorer" }, properties = { tag = "f", floating = true, opacity = 0.95 } },
    { rule = { class = "screensaver" }, properties = { opacity = 0.5 } },
}

client.connect_signal("manage", function (c)
    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", function(c)
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
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

client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

