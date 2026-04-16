local initializer = {}

function initializer.load_environment(load_data, repo : string)
    if load_data.load_locally then
        getgenv().interface = loadfile("FarmItEasy/dependencies/interface/library.lua")()

       -- modules
        for module_index in load_data.module_list do
            local module_name = load_data.module_list[module_index]

            getgenv()[module_name] = loadfile("FarmItEasy/dependencies/modules/" .. module_name .. ".lua")()
        end
    else
        getgenv().interface = loadstring(game:HttpGet(repo .. "interface/library.lua"))()

        -- modules
        for module_index in load_data.module_list do
            local module_name = load_data.module_list[module_index]

            getgenv()[module_name] = loadstring( repo .. "modules/" .. module_name .. ".lua")()
        end
    end
end

return initializer
