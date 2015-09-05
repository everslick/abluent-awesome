local naughty = require("naughty")

local help = {
--    TYPE    MOD1    MOD2           KEY        TEXT
-------------------------------------------------------------------------------
    { "grp" , "Global Keys"                                                  },
    { "spc"                                                                  },
    { "key" , "Alt" , "Ctrl"       , "Left"  , "view previous tag"           },
    { "key" , "Alt" , "Ctrl"       , "Right" , "view next tag"               },
    { "key" , "Alt" , "Ctrl"       , "Up"    , "switch to previous layout"   },
    { "key" , "Alt" , "Ctrl"       , "Down"  , "switch to next layout"       },
    { "spc"                                                                  },
    { "key" , "Win" , "Ctrl"       , "Up"    , "make master bigger"          },
    { "key" , "Win" , "Ctrl"       , "Down"  , "make master smaller"         },
    { "key" , "Win" , "Ctrl"       , "Left"  , "increment # masters"         },
    { "key" , "Win" , "Ctrl"       , "Right" , "decrement # masters"         },
    { "spc"                                                                  },
    { "key" , "Win" , "Ctrl"       , "r|q"   , "restart/quit awesome"        },
    { "key" , "Win" , "Ctrl"       , "l"     , "lock screen"                 },
    { "key" , "Win" , ""           , "c"     , "toggle awesome panel"        },
    { "key" , "Win" , ""           , "F1"    , "view keyboard help"          },
    { "key" , "Win" , ""           , "Esc"   , "restore tag history"         },
    { "key" , "Win" , ""           , "Tab"   , "focus next client"           },
    { "key" , "Win" , ""           , "PrtSc" , "grab window"                 },
    { "key" , ""    , ""           , "PrtSc" , "grab screen"                 },
    { "spc"                                                                  },
    { "key" , "Win" , ""           , "`"     , "open main menu"              },
    { "key" , "Alt" , ""           , "`"     , "open client menu"            },
    { "key" , ""    , ""           , "Esc"   , "close last menu"             },
    { "spc"                                                                  },
    { "key" , "Win" , ""           , "z|a"   , "spawn tiled/floating xterm"  },
    { "key" , "Win" , ""           , "r|x"   , "run shell/lua code in panel" },
    { "spc"                                                                  },
    { "grp" , "Client Keys"                                                  },
    { "spc"                                                                  },
    { "key" , "Win" , ""           , "t"     , "toggle titlebar"             },
    { "key" , "Win" , ""           , "d"     , "toggle ontop"                },
    { "key" , "Win" , ""           , "s"     , "toggle sticky"               },
    { "key" , "Win" , ""           , "f"     , "toggle fullscreen"           },
    { "key" , "Win" , ""           , "e"     , "toggle floating"             },
    { "key" , "Win" , ""           , "w"     , "toggle maximize"             },
    { "key" , "Win" , ""           , "q"     , "quit client"                 },
    { "spc"                                                                  },
    { "key" , "Win" , "Ctrl"       , "PgUp"  , "send client to previous tag" },
    { "key" , "Win" , "Ctrl"       , "PgDn"  , "send client to next tag"     },
    { "key" , "Alt" , "Ctrl"       , "PgUp"  , "drag client to previous tag" },
    { "key" , "Alt" , "Ctrl"       , "PgDn"  , "drag client to next tag"     },
    { "spc"                                                                  },
    { "grp" , "Number Keys"                                                  },
    { "spc"                                                                  },
    { "key" , "Win" , ""           , "1-9"   , "view this tag only"          },
    { "key" , "Win" , "Ctrl"       , "1-9"   , "toggle tag"                  },
    { "key" , "Win" , "Shift"      , "1-9"   , "send client to tag"          },
    { "key" , "Win" , "Ctrl+Shift" , "1-9"   , "toggle client on tag"        }
-------------------------------------------------------------------------------
}

local notification = nil

local function create_markup()
    local padding = 10
    local longest = 0
    local result = ""

    local function get_mod_and_key(line)
        local mod = ""
        local key = ""

        if line[2] ~= "" then
            mod = line[2]
        end

        if line[3] ~= "" then
            mod = mod .. "+" .. line[3]
        end

        return mod, line[4]
    end

    local function pad(m, k)
        local spaces = longest + padding - string.len(m .. k)

        return string.format("%" .. spaces .. "s ", "")
    end

    for _, line in ipairs(help) do
        if line[1] == "key" then
            local mod, key = get_mod_and_key(line)

            longest = math.max(longest, string.len(mod .. key))
        end
    end

    for _, line in ipairs(help) do
        if line[1] == "key" then
            local mod, key = get_mod_and_key(line)
            local txt = line[5]

            result = result ..
                '<span color="#f06060">' ..
                    pad(mod, key) ..
                    mod .. ' ' ..
                '</span>' ..
                '<span color="#ffffff">' ..
                    key .. '  ' ..
                '</span>' ..
                '<span color="#a8a8d8">' ..
                    txt .. '  ' ..
                '</span>\n'

        elseif line[1] == "grp" then
            local txt = line[2]

            result = result ..
                '<span weight="bold" color="#e0e060">  ' ..
                    txt ..
                '</span>\n'

        elseif line[1] == "spc" then
            result = result ..
               '<span font="DejaVu Sans Mono 3"> </span>\n'
        end
    end

    return result
end

function keyhelp_toggle()
    local function close()
        naughty.destroy(notification)
        notification = nil
    end

    if notification then
        close()
    else
        notification = naughty.notify({
            preset = naughty.config.presets.low,
            text = create_markup(),
            font = "DejaVu Sans Mono 8",
            timeout = 0,
            run = close
        })
    end
end
