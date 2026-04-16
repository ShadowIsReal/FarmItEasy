local initializer = {}

function initializer.load_environment(load_data, repo : string)
    getgenv().interface = loadstring(game:HttpGet(repo .. "interface/library.lua"))()

    -- modules
    for module_index in load_data.module_list do
        local module_name = load_data.module_list[module_index]

        getgenv()[module_name] = loadstring( repo .. "modules/" .. module_name .. ".lua")()
    end
end

return initializer
