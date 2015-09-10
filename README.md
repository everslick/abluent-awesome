# Abluent (Awesome)

This is an [awesome](http://awesome.naquadah.org) configuration
and theme, that strives for modularity as well as cleanness.

It is heavily based on [Vincent Bernat's awesome configuration]
(http://https://github.com/vincentbernat/awesome-configuration),
but has some bits removed and others added. The keybindings
are also very different from the default bindings.

This configuration was tested with _awesome_ 3.5.6

Features
--------

* optimized for netbooks and low screen resolution
* low # of external depedencies
* fast volume and backlight control via scrollwheel and keyboard
* screen grabbing with PrintScreen 
* making clients float toggles their toolbar automatically
* improved keyboard shortcuts with documentation (windows+v)
* hooks for some common function keys (i.e. multimedia keys, ...)
* awesome main launcher opens client window on right mouse butten click
* widgets for calendar, cpu usage/temp, memory, hdd, net traffic and battery
* properly and consistently formatted config file
* conky window slides in and out when clicking cpu widget icon

Dependencies
------------

* awesome (3.5.x)
* scrot (for screen grabing)
* xlock (for screensaver and locking)
* xautolock (for screensaver and locking)
* xdg-menu (for auto generated application menu)
* conky (for system monitoring)
* xterm for drop-down console

Keyboard
--------

The keyboard shortcuts follow some special rational. They are
organized in a way so they can be performed with either one or
two hands depending on the context. Where possible, the key
resambles the function to make memorization easier. Anyway, the
Win+F1 shortcut toggles the keyboard help notification.

```
 MOD1    MOD2           KEY        TEXT
---------------------------------------------------------
 "Global Keys"

 "Alt" , "Ctrl"       , "Left"  , "view previous tag"
 "Alt" , "Ctrl"       , "Right" , "view next tag"
 "Alt" , "Ctrl"       , "Up"    , "switch to previous layout"
 "Alt" , "Ctrl"       , "Down"  , "switch to next layout"

 "Win" , "Ctrl"       , "Up"    , "make master bigger"
 "Win" , "Ctrl"       , "Down"  , "make master smaller"
 "Win" , "Ctrl"       , "Left"  , "increment # masters"
 "Win" , "Ctrl"       , "Right" , "decrement # masters"

 "Win" , "Ctrl"       , "r|q"   , "restart/quit awesome"
 "Win" , "Ctrl"       , "l"     , "lock screen"
 "Win" , ""           , "c"     , "toggle awesome panel"
 "Win" , ""           , "F1"    , "view keyboard help"
 "Win" , ""           , "Esc"   , "restore tag history"
 "Win" , ""           , "Tab"   , "focus next client"
 "Alt" , ""           , "Tab"   , "cycle through tiled clients"
 "Win" , ""           , "PrtSc" , "grab window"
 ""    , ""           , "PrtSc" , "grab screen"

 "Win" , ""           , "`"     , "open main menu"
 "Alt" , ""           , "`"     , "open client menu"
 ""    , ""           , "Esc"   , "close last menu"

 "Win" , ""           , "z|a"   , "spawn tiled/floating xterm"
 "Win" , ""           , "r|x"   , "run shell/lua code in panel"

 "Client Keys"

 "Win" , ""           , "t"     , "toggle titlebar"
 "Win" , ""           , "d"     , "toggle ontop"
 "Win" , ""           , "s"     , "toggle sticky"
 "Win" , ""           , "f"     , "toggle fullscreen"
 "Win" , ""           , "e"     , "toggle floating"
 "Win" , ""           , "w"     , "toggle maximize"
 "Win" , ""           , "q"     , "quit client"

 "Win" , "Ctrl"       , "PgUp"  , "send client to previous tag"
 "Win" , "Ctrl"       , "PgDn"  , "send client to next tag"
 "Alt" , "Ctrl"       , "PgUp"  , "drag client to previous tag"
 "Alt" , "Ctrl"       , "PgDn"  , "drag client to next tag"

 "Number Keys"

 "Win" , ""           , "1-9"   , "view this tag only"
 "Win" , "Ctrl"       , "1-9"   , "toggle tag"
 "Win" , "Shift"      , "1-9"   , "send client to tag"
 "Win" , "Ctrl+Shift" , "1-9"   , "toggle client on tag"
```

ToDo
----

* merge conky and console modules
* test on more then one screen (xrandr)
* nicer icons
* useful functions for fn-keys

Screenshots
-----------

![Screenshot 1](./doc/screenshot_1.png?raw=true "Screenshot 1: xterm + keyboard help")
![Screenshot 2](./doc/screenshot_2.jpg?raw=true "Screenshot 2: audacious + conky")
