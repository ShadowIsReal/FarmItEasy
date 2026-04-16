local initializer = {}

function initializer.load_environment(required_module_list, repo : string)
    getgenv().interface = loadstring(game:HttpGet(repo .. "modules/interface/library.lua"))()

    -- modules
    for module_index in required_module_list do
        local module_name = required_module_list[module_index]

        getgenv()[module_name] = loadstring( repo .. "modules/" .. module_name .. ".lua")()
    end
end

return initializer
