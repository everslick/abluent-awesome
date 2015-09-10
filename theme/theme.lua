---------------------------
-- Abulent awesome theme --
---------------------------

theme               = {}
--theme.dir           = awful.util.getdir("config") .. "/theme/"
theme.dir           = "~/.config/awesome/theme/"
theme.wallpaper     = theme.dir .. "wallpaper.jpg"
theme.titlebar      = theme.dir .. "titlebar/"
theme.layouts       = theme.dir .. "layouts/"
theme.icons         = theme.dir .. "icons/"

--theme.font        = "monospace 7"
theme.font          = "sans 8"

theme.bg_normal     = "#101040d0"
theme.bg_focus      = "#101080d0"
theme.bg_urgent     = "#901080d0"
theme.bg_minimize   = "#404040d0"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#a8a8d8"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffa8a8"
theme.fg_minimize   = theme.fg_focus

theme.border_width  = 1
theme.border_normal = "#222222"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

theme.taglist_bg_focus      = "#202080d0"
theme.taglist_bg_urgent     = "#602020d0"
theme.taglist_squares_sel   = theme.icons .. "square_a.png"
theme.taglist_squares_unsel = theme.icons .. "square_b.png"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
-- theme.taglist_bg_focus = "#ff0000"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_border_width     = 1
theme.menu_border_color     = theme.border_normal
theme.menu_bg_normal        = "#080010c0"
theme.menu_bg_focus         = "#201040d0"
theme.menu_fg_normal        = "#9090f0"
theme.menu_fg_focus         = theme.menu_fg_normal
theme.menu_height           = 18
theme.menu_width            = 120
theme.menu_submenu_icon     = theme.icons .. "submenu.png"
theme.awesome_icon          = theme.icons .. "awesome.png"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal              = theme.titlebar .. "close_normal.png"
theme.titlebar_close_button_focus               = theme.titlebar .. "close_focus.png"

theme.titlebar_ontop_button_normal_inactive     = theme.titlebar .. "ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.titlebar .. "ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.titlebar .. "ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme.titlebar .. "ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = theme.titlebar .. "sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.titlebar .. "sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.titlebar .. "sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme.titlebar .. "sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = theme.titlebar .. "floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.titlebar .. "floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.titlebar .. "floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme.titlebar .. "floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme.titlebar .. "maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.titlebar .. "maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.titlebar .. "maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme.titlebar .. "maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh      = theme.layouts .. "fairhw.png"
theme.layout_fairv      = theme.layouts .. "fairvw.png"
theme.layout_floating   = theme.layouts .. "floatingw.png"
theme.layout_magnifier  = theme.layouts .. "magnifierw.png"
theme.layout_max        = theme.layouts .. "maxw.png"
theme.layout_fullscreen = theme.layouts .. "fullscreenw.png"
theme.layout_tilebottom = theme.layouts .. "tilebottomw.png"
theme.layout_tileleft   = theme.layouts .. "tileleftw.png"
theme.layout_tile       = theme.layouts .. "tilew.png"
theme.layout_tiletop    = theme.layouts .. "tiletopw.png"
theme.layout_spiral     = theme.layouts .. "spiralw.png"
theme.layout_dwindle    = theme.layouts .. "dwindlew.png"

theme.widget_temp       = theme.icons .. "temp.png"
theme.widget_ac         = theme.icons .. "ac.png"
theme.widget_cpu        = theme.icons .. "cpu.png"
theme.widget_dish       = theme.icons .. "dish.png"
theme.widget_mem        = theme.icons .. "mem.png"
theme.widget_disk       = theme.icons .. "disk.png"
theme.widget_hdd        = theme.icons .. "hdd.png"
theme.widget_fan        = theme.icons .. "fan.png"
theme.widget_note       = theme.icons .. "note.png"
theme.widget_note_on    = theme.icons .. "note_on.png"
theme.widget_netdown    = theme.icons .. "net_down.png"
theme.widget_netup      = theme.icons .. "net_up.png"
theme.widget_net        = theme.icons .. "net.png"
theme.widget_netwired   = theme.icons .. "net_wired.png"
theme.widget_mail       = theme.icons .. "mail.png"
theme.widget_bat        = theme.icons .. "bat.png"
theme.widget_batfull    = theme.icons .. "bat_full.png"
theme.widget_batlow     = theme.icons .. "bat_low.png"
theme.widget_batempty   = theme.icons .. "bat_empty.png"
theme.widget_clock      = theme.icons .. "clock.png"
theme.widget_spkr       = theme.icons .. "spkr.png"
theme.widget_backlight  = theme.icons .. "backlight.png"
theme.widget_bg         = theme.icons .. "widget_bg.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
