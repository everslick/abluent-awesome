local awful   = require("awful")
local naughty = require("naughty")

-- Simple function to load additional LUA files from .
function import(name, mod)
    local success
    local result

    -- Which file? In rc/ or in lib/?
    local path = awful.util.getdir("config") .. "/" .. name .. ".lua"

    -- If the module is already loaded, don't load it again
    if mod and package.loaded[mod] then return package.loaded[mod] end

    -- Execute the RC/module file
    success, result = pcall(function() return dofile(path) end)
    if not success then
        naughty.notify({
            title = "Error while loading an RC file",
            text  = "When loading `" .. name ..
                    "`, got the following error:\n" .. result,
            preset = naughty.config.presets.critical
        })

        return print("E: error loading RC file '" .. name .. "': " .. result)
    end

    -- Is it a module?
    if mod then
        return package.loaded[mod]
    end

    return result
end
