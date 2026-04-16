local initializer = {}

function initializer.load_environment(required_module_list, repo : string)
    getgenv().interface = loadstring(game:HttpGet(repo .. "interface/library.lua"))()

    -- modules
    for module_index=1, #required_module_list do
        local module_name = required_module_list[module_index]

        getgenv()[module_name] = loadstring(game:HttpGet(repo .. "modules/" .. module_name .. ".lua"))()
    end
end

return initializer
