--
-- Abluent Awesome Configuration
-- (C) 2015 Clemens Kirchgatterer
-- Released under GPL3
-- www.1541.org
--

-- Standard awesome library
local gears       = require("gears")
local awful       = require("awful")
      awful.rules = require("awful.rules")
                    require("awful.autofocus")
-- Widget and layout library
local wibox       = require("wibox")
-- Theme handling library
local beautiful   = require("beautiful")
-- Notification library
local naughty     = require("naughty")
-- Widget helper library
local lain        = require("lain")

-------------------------------------------------------------------------------
-- STANDARD ERROR HANDLING                                                   --
-------------------------------------------------------------------------------

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
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

-------------------------------------------------------------------------------
-- BASIC SETUP AND INTITIALIZATION STUFF                                     --
-------------------------------------------------------------------------------

local config_dir = awful.util.getdir("config") .. "/"
local cache_dir  = awful.util.getdir("cache")  .. "/"
local theme_dir  = config_dir .. "theme"       .. "/"
local home_dir   = os.getenv("HOME")           .. "/"

-- Themes define colours, icons, font and wallpapers.
beautiful.init(theme_dir .. "theme.lua")

local titlebar_enabled     = true
local titlebar_size        = 16
local panel_height         = 20
local widget_notifications = false

-- This is used later as the default terminal and editor to run.
local terminal       = "xterm"
local editor         = os.getenv("EDITOR") or "vim"
local editor_cmd     = terminal .. " -e " .. editor

local screenlock_cmd = "xlock -delay 40000 -nice 20 -mode matrix"
local screengrab_cmd = "scrot"

local backlight_cmd  = "xbacklight"
local mixer_gui_cmd  = "aumix"
local mixer_cmd      = "amixer"
local filer_cmd      = "rox"

local iptraf_cmd     = terminal .. " -name Float -g 100x34+30+50 " ..
                                   " -e sudo iptraf-ng -i all"

local xdg_menu_cmd   = "xdg_menu --format awesome --root-menu " ..
                       "/etc/xdg/menus/arch-applications.menu > " ..
                       config_dir .. "appmenu.lua"

-- Default modifier keys
local winkey = "Mod4"
local altkey = "Mod1"

naughty.config.presets.low.opacity      = 0.85
naughty.config.presets.normal.opacity   = 0.85
naughty.config.presets.critical.opacity = 0.85

-- Table of layouts to cover with awful.layout.inc, order matters
local layouts = {
   awful.layout.suit.tile,
   awful.layout.suit.tile.bottom
}

-- Wallpaper
if beautiful.wallpaper then
   for s = 1, screen.count() do
      gears.wallpaper.maximized(beautiful.wallpaper, s, true)
   end
end

 -- Tags and their default layout
local tags = {
   names  = {
      "sys  ",    "su  ",     "www  ",
      "irc  ",    "code ",    "I   ",
      "II   ",    "III   ",   "IV  "
   },
   layout = {
      layouts[2], layouts[1], layouts[1],
      layouts[1], layouts[1], layouts[1],
      layouts[1], layouts[1], layouts[1]
   }
}
 
for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
end

-- Automatic menu generation
awful.util.spawn_with_shell(xdg_menu_cmd)
local app_menu = require("appmenu")

local menu_awesome = {
    { "lock screen", lock_screen      },
    { "restart",     awesome.restart },
    { "quit",        awesome.quit    }
}

local menu_main = awful.menu({
    items = {
        { "awesome", menu_awesome, beautiful.awesome_icon   },
        { "apps",    xdgmenu                                },
        { "xterm",   terminal .. " -name Float"             }
    },
    theme = {
        width = 130
    }
})

-------------------------------------------------------------------------------
-- COMMONLY USED HELPER FUNCTIONS                                            --
-------------------------------------------------------------------------------

local function notify(title, text, time)
    naughty.notify({
        preset = naughty.config.presets.low,
        title = title, text = text, timeout = time or 5
    })
end

local function run_once(prg)
    -- we escape all '+' characters with '\'
    local cmd = string.gsub(prg, "+", "\\+")
    -- otherwise pgrep will not find the process
    local running = os.execute("pgrep -fu $USER '" .. cmd .. "'")

    if not running then
        notify("Starting:        ", prg)
        awful.util.spawn_with_shell(prg)
    end
end

local function lock_screen()
    awful.util.spawn(screenlock_cmd, false)
end

local function grab_screen(window)
    local timestamp = os.date("%Y-%m-%d_%H:%M:%S", os.time())
    local filename = home_dir .. "/screenshot_" .. timestamp .. ".png"
    local args = " "

    if window then args = " -ub " end
    awful.util.spawn(screengrab_cmd .. args .. filename, false)
    notify("Saving screenshot to file:", filename)
end

local function menu_client_show()
    if client_menu_instance then
        client_menu_instance:hide()
        client_menu_instance = nil
    else
        client_menu_instance = awful.menu.clients({ theme = { width = 240 } })
    end
end 

local function move_client_to_previous_tag(switch)
    local curidx = awful.tag.getidx()
    local s = client.focus.screen

    if curidx == 1 then
        awful.client.movetotag(tags[s][#tags[s]])
    else
        awful.client.movetotag(tags[s][curidx - 1])
    end

    if switch then awful.tag.viewidx(-1) end
end 

local function move_client_to_next_tag(switch)
    local curidx = awful.tag.getidx()
    local s = client.focus.screen

    if curidx == #tags[s] then
        awful.client.movetotag(tags[s][1])
    else
        awful.client.movetotag(tags[s][curidx + 1])
    end

    if switch then awful.tag.viewidx(1) end
end

-------------------------------------------------------------------------------
-- LOAD EXTERNAL MODULES                                                     --
-------------------------------------------------------------------------------

require("loader")

import("console")
import("icons")
import("xrandr")
import("keyhelp")
import("debug")
import("conky")

for s = 1, screen.count() do
    console[s] = console()
end

-------------------------------------------------------------------------------
-- PANEL (WIBOX) PREPARATION                                                 --
-------------------------------------------------------------------------------

-- Create awesome icon and use it as menu launcher
local btn_widget = wibox.widget.imagebox(beautiful.awesome_icon)
btn_widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function() menu_main:toggle() end),
    awful.button({ }, 3, function() menu_client_show() end)
))

-- Create a textclock widget and attach a calendar
local clk_widget = awful.widget.textclock("%H:%M", 23.371)
lain.widgets.calendar:attach(clk_widget, {
    post_cal = "-m", font = "monospace", font_size = 9
})

-- Create the widget icons
local bkl_widget_icon = wibox.widget.imagebox(beautiful.widget_backlight)
local vol_widget_icon = wibox.widget.imagebox(beautiful.widget_spkr)
local bat_widget_icon = wibox.widget.imagebox(beautiful.widget_bat)
local net_widget_icon = wibox.widget.imagebox(beautiful.widget_net)
local hdd_widget_icon = wibox.widget.imagebox(beautiful.widget_hdd)
local mem_widget_icon = wibox.widget.imagebox(beautiful.widget_mem)
local cpu_widget_icon = wibox.widget.imagebox(beautiful.widget_cpu)
local tmp_widget_icon = wibox.widget.imagebox(beautiful.widget_temp)

-- Fine tune update intervals for minimum CPU usage
local cpu_widget_update_interval = 2.3
local vol_widget_update_interval = 2.3
local net_widget_update_interval = 2.3
local bat_widget_update_interval = 3.7
local mem_widget_update_interval = 3.7
local hdd_widget_update_interval = 4.9
local bkl_widget_update_interval = 4.9
local tmp_widget_update_interval = 4.9

-- Widget icon mouse buttons
vol_widget_icon:buttons(awful.util.table.join(awful.button({ }, 1, function()
    awful.util.spawn_with_shell(mixer_gui_cmd)
end)))

net_widget_icon:buttons(awful.util.table.join(awful.button({ }, 1, function()
    awful.util.spawn_with_shell(iptraf_cmd)
end)))

hdd_widget_icon:buttons(awful.util.table.join(awful.button({ }, 1, function()
    awful.util.spawn_with_shell(filer_cmd)
end)))

cpu_widget_icon:buttons(awful.util.table.join(awful.button({ }, 1,
    conky_toggle))
)

-------------------------------------------------------------------------------
-- BACKLIGHT WIDGET                                                          --
-------------------------------------------------------------------------------

local bkl_widget_last_value = 0
local bkl_widget = lain.widgets.base({
    timeout = bkl_widget_update_interval,
    cmd = backlight_cmd,
    settings = function()
        local backlight = math.floor(tonumber(output))

        if bkl_widget_last_value ~= backlight then
            bkl_widget_last_value = backlight
            widget:set_markup(" " .. backlight .. "% ")
        end
    end
})
 
local function bkl_widget_up()
    awful.util.spawn(backlight_cmd .. " -inc 15 -time 0 -steps 1", false)
    bkl_widget.update()
end

local function bkl_widget_down()
    awful.util.spawn(backlight_cmd .. " -dec 7 -time 0 -steps 1", false)
    bkl_widget.update()
end

bkl_widget:buttons(awful.util.table.join(
    awful.button({ }, 4, bkl_widget_up),
    awful.button({ }, 5, bkl_widget_down)
))
 
-------------------------------------------------------------------------------
-- VOLUME WIDGET                                                             --
-------------------------------------------------------------------------------

local vol_notify_id = nil
local vol_widget_last_value = 0
local vol_widget = lain.widgets.base({
    timeout = vol_widget_update_interval,
    cmd = mixer_cmd .. " sget Master",
    settings = function()
        local volume = tonumber(string.match(output, "%[(%d-)%%%]"))
        local mute = true
        local str = "------"

        if string.find(output, "[on]", 1, true) then
            str = volume .. "%"
            mute = false
        else
            if volume == 100 then str = str .. "- " end
        end

        if vol_widget_last_value ~= str then
            vol_widget_last_value = str
            widget:set_markup(str .. " ")

            if widget_notifications then
                local icon = "high"

                if mute or volume == 0 then
                    icon = "muted"
                elseif volume < 30 then
                    icon = "low"
                elseif volume < 60 then
                    icon = "medium"
                end

                icon = icons.lookup({
                    name = "audio-volume-" .. icon,
                    type = "status"
                })

                vol_notify_id = naughty.notify({
                    text = string.format("%3d %%", volume),
                    icon = icon,
                    font = "Free Sans Bold 24",
                    replaces_id = vol_notify_id
                }).id
            end
        end
    end
})
 
local function vol_widget_up()
    awful.util.spawn(mixer_cmd .. " set Master 3%+", false)
    vol_widget.update()
end

local function vol_widget_down()
    awful.util.spawn(mixer_cmd .. " set Master 3%-", false)
    vol_widget.update()
end

local function vol_widget_toggle()
    awful.util.spawn(mixer_cmd .. " set Master toggle", false)
    vol_widget.update()
end

vol_widget:buttons(awful.util.table.join(
    awful.button({ }, 4, vol_widget_up),
    awful.button({ }, 5, vol_widget_down),
    awful.button({ }, 1, vol_widget_toggle)
))
 
-------------------------------------------------------------------------------
-- BATTERY STATUS WIDGET                                                     --
-------------------------------------------------------------------------------

local bat_widget = lain.widgets.bat({
    timeout = bat_widget_update_interval,
    battery = "BAT1",
    settings = function()
        local bat_perc = 0

        if bat_now.perc == "N/A" or bat_now.status == "Not present" then
            bat_widget_icon:set_image(beautiful.widget_ac)
        elseif bat_now.status == "Charging" then
            bat_perc = tonumber(bat_now.perc)
            bat_widget_icon:set_image(beautiful.widget_ac)
        else
            bat_perc = tonumber(bat_now.perc)

            if bat_perc > 75 then
                bat_widget_icon:set_image(beautiful.widget_batfull)
            elseif bat_perc > 25 then
                bat_widget_icon:set_image(beautiful.widget_batlow)
            else
                bat_widget_icon:set_image(beautiful.widget_batempty)
            end
        end

        widget:set_markup(bat_perc .. "% ")
    end
})

-------------------------------------------------------------------------------
-- SIMPLE WIDGETS                                                            --
-------------------------------------------------------------------------------

local markup = lain.util.markup

-- Network widget
local net_widget = lain.widgets.net({
    timeout = net_widget_update_interval,
    settings = function()
        widget:set_markup(
            markup("#7AC82E", "↓" .. net_now.received)
            .. " " ..
            markup("#EE3434", "↑" .. net_now.sent .. " ")
        )
    end
})

-- Memory usage widget
local mem_widget = lain.widgets.mem({
    timeout = mem_widget_update_interval,
    settings = function()
        widget:set_text(mem_now.used .. "MB ")
    end
})

-- CPU temperatur widget
local tmp_widget = lain.widgets.temp({
    timeout = tmp_widget_update_interval,
    settings = function()
        widget:set_text(coretemp_now .. "°C ")
    end
})

-- Harddisk usage widget
local hdd_widget = lain.widgets.fs({
    notification_preset = { font = "monospace 9" },
    timeout = hdd_widget_update_interval,
    partition = "/",
    settings = function()
        widget:set_markup(fs_now.used .. "% ")
    end
})

-- CPU load widget
local cpu_widget = lain.widgets.cpu({
    timeout = cpu_widget_update_interval,
    settings = function()
        widget:set_markup(cpu_now.usage .. "% ")
    end
})

-- Start with valid values for some widgets
bkl_widget.update()
vol_widget.update()

-------------------------------------------------------------------------------
-- AWESOME PANEL (WIBOX)                                                     --
-------------------------------------------------------------------------------

-- Panel with launcher, taglist, widgets, systray, clock and layout switcher
local awesome_panel = {}
local prompt_box = {}
local layout_box = {}
local tag_widget = {}

-- Space and seperator widgets for the panel
local spc_widget = wibox.widget.textbox()
spc_widget:set_text("   ")

local sep_widget = wibox.widget.textbox()
sep_widget:set_text("|")

-- Handle mouse buttons on the taglist
tag_widget.buttons = awful.util.table.join(
    awful.button({        }, 1, awful.tag.viewonly),
    awful.button({ winkey }, 1, awful.client.movetotag),
    awful.button({        }, 3, awful.tag.viewtoggle),
    awful.button({ winkey }, 3, awful.client.toggletag),
    awful.button({        }, 4, function(t)
        awful.tag.viewnext(awful.tag.getscreen(t))
    end),
    awful.button({        }, 5, function(t)
        awful.tag.viewprev(awful.tag.getscreen(t))
    end)
)

-- Create a panel for each screen and add it
for s = 1, screen.count() do
    -- Create a promptbox for each screen
    prompt_box[s] = awful.widget.prompt()

    -- We need one layoutbox per screen.
    layout_box[s] = awful.widget.layoutbox(s)
    layout_box[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function() awful.layout.inc(layouts,  1) end),
        awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function() awful.layout.inc(layouts,  1) end),
        awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)
    ))

    -- Create a taglist widget
    tag_widget[s] = awful.widget.taglist(
        s,
        awful.widget.taglist.filter.all,
        tag_widget.buttons
    )

    -- Create the wibox (this is the panel on top)
    awesome_panel[s] = awful.wibox({
        position = "top",
        screen = s,
        height = panel_height,
        ontop = false
    })

    local left_layout   = wibox.layout.fixed.horizontal()
    local center_layout = wibox.layout.fixed.horizontal()
    local right_layout  = wibox.layout.fixed.horizontal()

    -- Widgets that are aligned to the left
    left_layout:add(btn_widget)
    left_layout:add(spc_widget)
    left_layout:add(tag_widget[s])
    left_layout:add(spc_widget)
    left_layout:add(prompt_box[s])

    -- Only the first screen has widgets, a systray and a clock
    if s == 1 then
        -- Widgets that are centered
        center_layout:add(bkl_widget_icon)
        center_layout:add(bkl_widget)
        center_layout:add(sep_widget)
        center_layout:add(vol_widget_icon)
        center_layout:add(vol_widget)
        center_layout:add(sep_widget)
        center_layout:add(bat_widget_icon)
        center_layout:add(bat_widget)
        center_layout:add(sep_widget)
        center_layout:add(hdd_widget_icon)
        center_layout:add(hdd_widget)
        center_layout:add(sep_widget)
        center_layout:add(mem_widget_icon)
        center_layout:add(mem_widget)
        center_layout:add(sep_widget)
        center_layout:add(net_widget_icon)
        center_layout:add(net_widget)
        center_layout:add(sep_widget)
        center_layout:add(cpu_widget_icon)
        center_layout:add(cpu_widget)
        center_layout:add(sep_widget)
        center_layout:add(tmp_widget_icon)
        center_layout:add(tmp_widget)

        -- Widgets that are aligned to the right
        right_layout:add(wibox.widget.systray())
        right_layout:add(spc_widget)
        right_layout:add(clk_widget)
        right_layout:add(spc_widget)
    end

    -- The layout box is the last widget on every panel
    right_layout:add(layout_box[s])

    -- Now bring it all together (with the lain widgets in the middle)
    local layout = wibox.layout.align.horizontal()

    layout:set_left(left_layout)
    layout:set_middle(center_layout)
    layout:set_right(right_layout)

    awesome_panel[s]:set_widget(layout)
end

-------------------------------------------------------------------------------
-- MOUSE BUTTONS                                                             --
-------------------------------------------------------------------------------

-- On the desktop
root.buttons(awful.util.table.join(
    awful.button({ }, 1, function() menu_main:toggle() end),
    awful.button({ }, 3, function() menu_client_show() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- On a client window
local clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function(c)
        client.focus = c; c:raise()
    end),
    awful.button({ winkey }, 1, awful.mouse.client.move),
    awful.button({ winkey }, 3, awful.mouse.client.resize)
)

-------------------------------------------------------------------------------
-- GLOBAL KEYS                                                               --
-------------------------------------------------------------------------------

local globalkeys = awful.util.table.join(
    -- Function keys
    awful.key({ }, "XF86Launch1",              function() -- F5
        notify("Unused keybord shortcut:", "Launch1")
    end),

    awful.key({ }, "XF86Launch2",              function() -- F7
        notify("Unused keybord shortcut:", "Launch2")
    end),

    awful.key({ }, "XF86Launch3",              function() -- F8
        notify("Unused keybord shortcut:", "Launch3")
    end),

    awful.key({ }, "XF86WLAN",                 function() -- F9
        notify("Unused keybord shortcut:", "WLAN")
    end),

    awful.key({ }, "XF86Display",              xrandr             ),

    awful.key({ }, "XF86AudioRaiseVolume",     vol_widget_up      ),
    awful.key({ }, "XF86AudioLowerVolume",     vol_widget_down    ),
    awful.key({ }, "XF86AudioMute",            vol_widget_toggle  ),

    awful.key({ }, "XF86MonBrightnessUp",      bkl_widget_up      ),
    awful.key({ }, "XF86MonBrightnessDown",    bkl_widget_down    ),

    -- Two handed
    awful.key({ altkey, "Control" }, "Left",   awful.tag.viewprev ),
    awful.key({ altkey, "Control" }, "Right",  awful.tag.viewnext ),

    awful.key({ altkey, "Control" }, "Up",     function()
       awful.layout.inc(layouts,  1)
    end),
    awful.key({ altkey, "Control" }, "Down",   function()
       awful.layout.inc(layouts, -1)
    end),

    awful.key({ winkey, "Control" }, "Up",     function()
       awful.tag.incmwfact( 0.02)
    end),
    awful.key({ winkey, "Control" }, "Down",   function()
       awful.tag.incmwfact(-0.02)
    end),
    awful.key({ winkey, "Control" }, "Left",   function()
       awful.tag.incnmaster( 1)
    end),
    awful.key({ winkey, "Control" }, "Right",  function()

    end),

    awful.key({ winkey, "Control" }, "l",      lock_screen               ),
    awful.key({ winkey, "Control" }, "r",      awesome.restart           ),

    -- Single handed
    awful.key({ winkey            }, "Escape", awful.tag.history.restore ),

    awful.key({                   }, "Print",  grab_screen               ),
    awful.key({ winkey            }, "Print",  function()
        grab_screen(true)
    end),
 
    awful.key({ winkey            }, "Tab",    function()
        awful.client.focus.byidx(1)
        if client.focus then
            client.focus:raise()
        end
    end),

    -- Standard terminal program
    awful.key({ winkey            }, "z",      function()
        awful.util.spawn(terminal)
    end),
    awful.key({ winkey            }, "a",      function()
        awful.util.spawn(terminal .. " -name Float")
    end),

    awful.key({ winkey            }, "F1",     keyhelp_toggle ),
    awful.key({ altkey            }, "F1",     keyhelp_toggle ),
    awful.key({ winkey            }, "F2",     conky_toggle   ),
    awful.key({ altkey            }, "F2",     conky_toggle   ),
    awful.key({ altkey            }, "Escape", function()
        console[mouse.screen]:toggle()
    end),

    -- Prompt
    awful.key({ winkey            }, "r",      function()
        prompt_box[mouse.screen]:run()
    end),
    awful.key({ winkey            }, "x",      function()
        awful.prompt.run({ prompt = "Lua: " },
        prompt_box[mouse.screen].widget,
        awful.util.eval, nil,
        cache_dir .. "history_eval")
    end),

    -- Menus
    awful.key({ altkey            }, "`",      function()
        menu_client_show()
    end),
    awful.key({ winkey            }, "`",      function()
        menu_main:toggle()
    end),

    -- Toggle awesome wibox (panel)
    awful.key({ winkey,           }, "c",      function()
        local s = mouse.screen

        awesome_panel[s].visible = not awesome_panel[s].visible
    end)
)

-------------------------------------------------------------------------------
-- CLIENT KEYS                                                               --
-------------------------------------------------------------------------------

local clientkeys = awful.util.table.join(
    awful.key({ winkey,           }, "i",      function(c)
        dbg(c)
    end),

    awful.key({ winkey,           }, "t",      function(c)
        if titlebar_enabled then
            awful.titlebar.toggle(c)
        end
    end),

    awful.key({ winkey,           }, "d",      function(c)
        c.ontop = not c.ontop
    end),

    awful.key({ winkey,           }, "s",      function(c)
        c.sticky = not c.sticky
    end),

    awful.key({ winkey            }, "f",      function(c)
        c.fullscreen = not c.fullscreen
    end),

    awful.key({ winkey,           }, "e",      function(c)
        awful.client.floating.toggle()
    end),

    awful.key({ winkey            }, "q",      function(c)
        c:kill()
    end),

    awful.key({ winkey            }, "w",      function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end),

    awful.key({ winkey            }, " ",      function(c)
        awful.client.togglemarked(c)
    end),

    awful.key({ winkey, "Control" }, "Prior",  function(c)
        move_client_to_previous_tag()
    end),

    awful.key({ winkey, "Control" }, "Next",   function(c)
        move_client_to_next_tag()
    end),

    awful.key({ altkey, "Control" }, "Prior",  function(c)
        move_client_to_previous_tag(true)
    end),

    awful.key({ altkey, "Control" }, "Next",   function(c)
        move_client_to_next_tag(true)
    end)
)

-------------------------------------------------------------------------------
-- GLOBAL NUMBER KEYS                                                        --
-------------------------------------------------------------------------------

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View this tag only
        awful.key({ winkey }, "#" .. i + 9, function()
            local s = mouse.screen

            local tag = awful.tag.gettags(s)[i]

            if tag then
                awful.tag.viewonly(tag)
            end
        end),
        -- Toggle tag
        awful.key({ winkey, "Control" }, "#" .. i + 9, function()
            local s = mouse.screen

            local tag = awful.tag.gettags(s)[i]

            if tag then
                awful.tag.viewtoggle(tag)
            end
        end),
        -- Move client to tag
        awful.key({ winkey, "Shift" }, "#" .. i + 9, function()
           if client.focus then
               local tag = awful.tag.gettags(client.focus.screen)[i]

               if tag then
                   awful.client.movetotag(tag)
               end
           end
        end),
        -- Toggle client on tag
        awful.key({ winkey, "Control", "Shift" }, "#" .. i + 9, function()
           if client.focus then
               local tag = awful.tag.gettags(client.focus.screen)[i]

               if tag then
                   awful.client.toggletag(tag)
               end
           end
        end)
    )
end

-- Set keys
root.keys(globalkeys)

-------------------------------------------------------------------------------
-- SIGNALS                                                                   --
-------------------------------------------------------------------------------

client.disconnect_signal("request::activate", awful.ewmh.activate)
function awful.ewmh.activate(c)
    if c:isvisible() then
        client.focus = c
        c:raise()
    end
end
client.connect_signal("request::activate", awful.ewmh.activate)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)

        -- Map windows in a smart way only if they
	-- do not set an initial position.
        if not c.size_hints.user_position
        and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    if titlebar_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Buttons for the titlebar
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

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()

        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()

        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)

        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()

        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c, { size = titlebar_size }):set_widget(layout)

        -- Hide titlebar from non-floating windows
        if not awful.client.floating.get(c) then
            awful.titlebar.hide(c)
        end

        -- Hide titlebar from certain clients
        if c.class    == "conky"
        or c.name     == "Audacious"
        or c.name     == "Audacious Equalizer"
        or c.name     == "Audacious Playlist Editor"
        or c.instance == "DropDownConsole" then
            awful.titlebar.hide(c)
        end

        if c.class == "conky" then
            conky_start()
        end

        -- Show titlebar when window becomes floating and vice versa
        c:connect_signal("property::floating", function(c)
            if awful.client.floating.get(c) then
                awful.titlebar.show(c)
            else
                awful.titlebar.hide(c)
            end
        end)
    end
end)

client.connect_signal("property::floating", function(c)
    if awful.client.floating.get(c) then
        c:raise()
    end
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-------------------------------------------------------------------------------
-- RULES                                                                     --
-------------------------------------------------------------------------------

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     maximized_horizontal = false,
                     maximized_vertical   = false,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    -- Launch certein programs as floating
    { rule = { name = "Page Unresponsive" }, -- this is for Chromium
      properties = { floating = true  } },
    { rule = { class = "conky" },
      properties = { floating = true,
                     border_width = 0,
                     ontop = true,
                     above = true,
                     sticky = true,
                     skip_taskbar = true } },
    { rule = { class = "ROX-Filer" },
      properties = { floating = true  } },
    { rule = { class = "MPlayer" },
      properties = { floating = true  } },
    { rule = { class = "Gpicview" },
      properties = { floating = true  } },
    { rule = { class = "Gxmessage" },
      properties = { floating = true  } },
    { rule = { class = "Xmessage" },
      properties = { floating = true  } },
    { rule = { class = "Aumix" },
      properties = { floating = true  } },
    { rule = { class = "Audacious" },
      properties = { floating = true  } },
    { rule = { name = "Audacious" },
      properties = { border_width = 0 } },
    { rule = { name = "About Audacious" },
      properties = { border_width = 1 } },
    { rule = { name = "Audacious Settings" },
      properties = { border_width = 1 } },
    -- Launch certein programs on their own tags
    { rule = { class = "Chromium" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Hexchat" },
      properties = { tag = tags[1][4] } },
    -- Launch xterms on different tags (use -name TagX|Float)
    { rule = { instance = "Tag1" },
      properties = { tag = tags[1][1] } },
    { rule = { instance = "Tag2" },
      properties = { tag = tags[1][2] } },
    { rule = { instance = "Tag3" },
      properties = { tag = tags[1][3] } },
    { rule = { instance = "Tag4" },
      properties = { tag = tags[1][4] } },
    { rule = { instance = "Tag5" },
      properties = { tag = tags[1][5] } },
    { rule = { instance = "Tag6" },
      properties = { tag = tags[1][6] } },
    { rule = { instance = "Tag7" },
      properties = { tag = tags[1][7] } },
    { rule = { instance = "Tag8" },
      properties = { tag = tags[1][8] } },
    { rule = { instance = "Tag9" },
      properties = { tag = tags[1][9] } },
    { rule = { instance = "Float" },
      properties = { floating = true  } }
}

-------------------------------------------------------------------------------
-- AUTOSTART APPLICATIONS                                                    --
-------------------------------------------------------------------------------

--run_once("chromium")
--run_once("xterm -name Float -geometry 96x39+0+29 -e su -")
run_once("xcompmgr -FfC -I 0.045 -O 0.055")
run_once("xterm -name Tag1 -geometry 145x19 -e dmesg -Hwu")
run_once("xterm -name Tag1 -geometry 145x19 -e dmesg -Hwk")
run_once("xterm -name Tag2 -e su -")
run_once("xterm -name Tag5")
run_once("hexchat")
run_once("conky")
