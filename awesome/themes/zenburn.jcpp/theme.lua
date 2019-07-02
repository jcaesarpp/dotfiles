local theme = {}
local home = os.getenv("HOME")
local awmd = home .. '/.config/awesome'
local mythemes = awmd .. '/themes'

local thistheme =  mythemes .. '/zenburn.jcpp'

local icons = thistheme .. '/icons/'
local layouts = thistheme .. '/layouts/'
local taglist = thistheme .. '/taglist/'

--theme.font = "Monospace 13"
theme.font = "Inconsolata 16"
--theme.font = "Hack 13"
theme.wallpaper = thistheme .. "/background.png"

theme.fg_normal  = "#DCDCCC"
theme.fg_focus   = "#F0DFAF"
theme.fg_urgent  = "#CC9393"
theme.bg_normal  = "#3F3F3Fcc"
theme.bg_focus   = "#1E2320cc"
theme.bg_urgent  = "#3F3F3Fcc"
theme.bg_systray = theme.bg_normal
theme.menu_bg_focus = theme.bg_focus
theme.menu_bg_normal = theme.bg_normal
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_bg_empty = theme.bg_normal

theme.useless_gap   = 0
theme.border_width  = 2
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#6F6F6F"
theme.border_marked = "#CC9393"

theme.mouse_finder_color = "#CC9393"

theme.taglist_squares_sel   = taglist .. "squarefz.png"
theme.taglist_squares_unsel = taglist .. "squarez.png"

theme.awesome_icon           = icons .. "awesome.svg"
theme.menu_height = 18
theme.menu_width  = 180

theme.debian           = icons .. "debian.png"
theme.menu_submenu_icon      = icons .. "submenu.png"
theme.terminal      = icons .. "terminal.svg"
theme.logout      = icons .. "logout.svg"
theme.restart      = icons .. "session-reboot.svg"
theme.preferences      = icons .. "preferences.svg"
theme.hotkeys      = icons .. "hotkeys.svg"
theme.manual      = icons .. "manual.svg"
theme.file      = icons .. "file.svg"
theme.email      = icons .. "email.svg"
theme.browser      = icons .. "browser.svg"
theme.news      = icons .. "news.svg"
theme.social      = icons .. "social.svg"
theme.develop      = icons .. "develop.svg"
theme.read      = icons .. "read.svg"

theme.layout_fairv      = layouts .. 'fairv.png'
theme.layout_floating   = layouts .. 'floating.png'

theme.clock = icons .. 'clock.svg'
theme.calendar = icons .. 'calendar.svg'
theme.system_monitor = icons .. 'system.monitor.svg'
theme.brightness = icons .. 'brightness.png'
theme.music = icons .. 'music.svg'

theme.audio_volume_muted = icons .. 'audio.volume.muted.svg'
theme.audio_volume_min = icons .. 'audio.volume.min.svg'
theme.audio_volume_low = icons .. 'audio.volume.low.svg'
theme.audio_volume_med = icons .. 'audio.volume.med.svg'
theme.audio_volume_max = icons .. 'audio.volume.max.svg'

theme.battery_000 = icons .. 'battery.000.svg'
theme.battery_020 = icons .. 'battery.020.svg'
theme.battery_040 = icons .. 'battery.040.svg'
theme.battery_060 = icons .. 'battery.060.svg'
theme.battery_080 = icons .. 'battery.080.svg'
theme.battery_100 = icons .. 'battery.100.svg'
theme.battery_charged_ac = icons .. 'battery.charged.ac.svg'

theme.level_010 = icons .. 'level.010.png'
theme.level_020 = icons .. 'level.020.png'
theme.level_030 = icons .. 'level.030.png'
theme.level_040 = icons .. 'level.040.png'
theme.level_050 = icons .. 'level.050.png'
theme.level_060 = icons .. 'level.060.png'
theme.level_070 = icons .. 'level.070.png'
theme.level_080 = icons .. 'level.080.png'
theme.level_090 = icons .. 'level.090.png'
theme.level_100 = icons .. 'level.100.png'

-- awesome-wm-widgets
theme.widget_main_color = "#74aeab"
theme.widget_red = "#e53935"
theme.widget_yellow = "#c0ca33"
theme.widget_green = "#43a047"
theme.widget_black = "#000000"
theme.widget_transparent = "#00000000"

return theme

