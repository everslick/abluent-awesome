local awful   = require("awful")
local naughty = require("naughty")

local conky_is_active = false -- used to make toggle work
local conky_position  = nil   -- screen postion conky is heading to
local conky_instance  = nil   -- conky client window
local conky_suspend   = nil   -- to let conky sleep when it finished moving out

local function find_client_by_class(class)
    local clients = function(c)
        return awful.rules.match(c, { class = class })
    end

    for c in awful.client.iterate(clients) do
        return (c)
    end
end

local function conky_init()
    local c = find_client_by_class("conky")

    awful.util.spawn("killall -SIGSTOP conky", false)

    conky_is_active = false
    conky_position  = nil
    conky_instance  = nil
    conky_suspend   = nil

    c:geometry({ x = 1024 })

    --c.floating = true
    --c.opacity = 0.85
    --c.ontop = true
    --c.above = true
    --c.sticky = true
    --c.skip_taskbar = true
    --c.border_width = 0
                                
    -- This is not a normal window, don't apply any specific keyboard stuff
    c:buttons({})
    c:keys({})

    conky_delay:stop()
end

local function conky_show()
    local c = find_client_by_class("conky")

    if not c then
        awful.util.spawn("killall -9 conky", false)

        naughty.notify({
            title = "Starting new conky instance...",
            text = "Click again to show it!",
            timeout = 4
        })

        awful.util.spawn("conky", false)

        -- conky_init() will then be called from the conky_delay signal handler
 
        return
    end

    local g = c:geometry()

    awful.util.spawn("killall -SIGCONT conky", false)

    c:geometry({ x = 1024 })

    conky_instance = c
    conky_position = g
    conky_position.x = 1024 - 340
    conky_animation:start()
end

local function conky_hide()
    local c = find_client_by_class("conky")
    local g = c:geometry()

    conky_instance = c
    conky_position = { x = 1024, y = g.y }
    conky_animation:start()
    conky_suspend = function()
        awful.util.spawn("killall -SIGSTOP conky", false)
    end
end

local function conky_move()
    if not conky_instance then
        conky_animation:stop()

        return
    end

    local g = conky_instance:geometry()

    if g.x == conky_position.x and g.y == conky_position.y then
        conky_animation:stop()

        if conky_suspend then
            conky_suspend()
            conky_suspend = nil
        end

        conky_instance = nil
    else
        local x = (conky_position.x - g.x) / 3
        local y = (conky_position.y - g.y) / 3

        if x > -1 and x < 0 then x = -1 end
        if y > -1 and y < 0 then y = -1 end
        if x <  1 and x > 0 then x =  1 end
        if y <  1 and y > 0 then y =  1 end

        awful.client.moveresize(x, y, 0, 0, conky_instance)
    end
end

function conky_toggle()
    if not conky_instance then
        if conky_is_active then
            conky_is_active = false
            conky_hide()
        else
            conky_is_active = true
            conky_show()
        end
    end
end

function conky_start()
    conky_delay:start()
end

-- Timer for the sliding animation
conky_animation = timer({ timeout = 0.05 })
conky_animation:connect_signal("timeout", conky_move)

-- Timer to delay initialization after conky has finished starting
conky_delay = timer({ timeout = 0.01 })
conky_delay:connect_signal("timeout", conky_init)
