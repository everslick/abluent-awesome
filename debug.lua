local beautiful = require("beautiful")
local naughty   = require("naughty")

local colors = {
    header = beautiful.fg_normal,
    count  = beautiful.fg_focus,
    index  = beautiful.fg_focus,
    name   = beautiful.fg_urgent
}

local function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')

    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

local function client_info(c)
    local v = " "

    -- object
    local c = c or client.focus
    v = v .. tostring(c)

    -- geometry
    local cc = c:geometry()
    local signx = (cc.x > 0 and "+") or ""
    local signy = (cc.y > 0 and "+") or ""

    v = v .. " @ " .. toint(cc.width) .. 'x' .. toint(cc.height) ..
        signx .. toint(cc.x) .. signy .. toint(cc.y) .. "\n\n"

    local inf = {
        "name", "icon_name", "type", "class", "role", "instance", "pid",
        "skip_taskbar", "id", "group_window", "leader_id", "machine",
        "screen", "hidden", "minimized", "size_hints_honor", "titlebar",
        "urgent", "focus", "opacity", "ontop", "above", "below",
        "fullscreen", "transient_for", "maximixed_horizontal",
        "maximixed_vertical", "sticky", "modal", "focusable"
    }

    for i = 1, #inf do
        v = v .. string.format('%2s: <span color="%s">%-20s</span> = ' ..
                               '<span color="%s">%s</span>\n',
			       i,
			       beautiful.fg_normal,
                               inf[i],
			       beautiful.fg_focus,
                               tostring(c[inf[i]]))
    end

    naughty.notify({
        text = string.format('<span font="Monospace 8">%s</span>',
                             v:sub(1, #v-1)),
        timeout = 0,
        margin = 10,
        screen = c.screen
    })
end

local function dbg_get(var, depth, indent)
    local a = ""
    local text = ""
    local name = ""
    local vtype = type(var)
    local vstring = tostring(var)

    if vtype == "table" or vtype == "userdata" then
        if vtype == "userdata" then
            var = getmetatable(var)
        end

        -- element count and longest key
        local count = 0
        local longest_key = 3

        for k,v in pairs(var) do
            count = count + 1
            longest_key = math.max(#tostring(k), longest_key)
        end

        text = text .. vstring .. " <span color='"..
               colors.count .. "'>#" .. count .. "</span>"

        -- descend a table
        if depth > 0 then
            -- sort keys FIXME: messes up sorting number
            local sorted = {}

            for k, v in pairs(var) do
                table.insert(sorted, { k, v })
            end

            table.sort(sorted, function(a, b)
                return tostring(a[1]) < tostring(b[1])
            end)

            -- go through elements
            for _, p in ipairs(sorted) do
                local key = p[1]; local value = p[2]
                -- don't descend _M
                local d; if key ~= "_M" then d = depth - 1 else d = 0 end
                -- get content and add to output
                local content = dbg_get(value, d, indent + longest_key + 1)

                text = text .. '\n' .. string.rep(" ", indent) ..
                       string.format("<span color='".. colors.index ..
                                     "'>%-" .. longest_key ..
                                     "s</span> %s",
                                     tostring(key),
                                     content)
            end
        end
    else
        if vtype == "tag" or vtype == "client" then
            name = " [<span color='" .. colors.name .. "'>" ..
                   (var.name or '…'):sub(1, 10) .. "</span>]"
        end

        text = text .. vstring .. name or ""
    end

    return text
end

function dbg(...)
    local arg = table.pack(...)
    local num = arg.n
    local depth = 2
    local clients = 0
    local text = "<span color='" .. colors.header ..
                    "'>dbg</span> <span color='" .. colors.count ..
                    "'>#" .. num ..
                 "</span>"

    for i = 1, num do
        local desc = dbg_get(arg[i], depth, 3)

        text = text .. string.format("\n<span color='" .. colors.index ..
                                     "'>%2d</span> %s", i, desc)

        if type(arg[i]) == "client" then
	    client_info(arg[i])
	    clients = clients + 1
        end
    end

    -- Display only if we don't have only clients to be displayed
    if clients ~= num then
        naughty.notify({
            text = text,
            timeout = 0,
            hover_timeout = 2,
            screen = screen.count()
        })
    end
end
