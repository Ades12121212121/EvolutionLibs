-- EvolutionLibs Loader principal (compatible con loadstring y GitHub)

-- Configuración global
_G.EvoLibsCache = _G.EvoLibsCache or {}
_G.EvoLibsConfig = _G.EvoLibsConfig or {
    BASE_URL = "https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/main/EvolutionLibs/",
    DEBUG = false
}

local function loadModule(moduleName, path)
    if _G.EvoLibsCache[moduleName] then
        return _G.EvoLibsCache[moduleName]
    end

    local success, result = pcall(function()
        return loadstring(game:HttpGet(_G.EvoLibsConfig.BASE_URL .. path))()
    end)

    if success then
        _G.EvoLibsCache[moduleName] = result
        if _G.EvoLibsConfig.DEBUG then
            print("[EvolutionLibs] Módulo cargado:", moduleName)
        end
        return result
    else
        warn("[EvolutionLibs] Error al cargar módulo", moduleName .. ":", result)
        return nil
    end
end

-- Carga de módulos principales
local Utils = loadModule("Utils", "Utils/Utils.lua")
local Designs = loadModule("Designs", "Designs/Designs.lua")
local Window = loadModule("Window", "Window/Window.lua")
local Elements = loadModule("Elements", "Elements/Elements.lua")

-- Carga lazy de módulos secundarios
local function getSidebar()
    return loadModule("Sidebar", "Sidebar/Sidebar.lua")
end

local function getToast()
    return loadModule("Toast", "Toast/Toast.lua")
end

local function getTab()
    return loadModule("Tab", "Tabs/Tab.lua")
end

-- API principal
local EvolutionLibs = {
    Version = "2.0.0",
    Utils = Utils,
    Designs = Designs,
    Window = Window,
    Elements = Elements,

    -- Módulos con carga lazy
    Sidebar = setmetatable({}, {
        __index = function(_, k)
            local module = getSidebar()
            return module and module[k]
        end
    }),
    Toast = setmetatable({}, {
        __index = function(_, k)
            local module = getToast()
            return module and module[k]
        end
    }),
    Tab = setmetatable({}, {
        __index = function(_, k)
            local module = getTab()
            return module and module[k]
        end
    }),

    -- API simplificada
    Setup = function(themeName, options)
        if not Designs then return end
        return Designs.Simple.Setup(themeName, options)
    end,

    Create = function(componentType, parent, config)
        if not Designs then return end
        return Designs.Simple.Create(componentType, parent, config)
    end,

    ApplyTheme = function(themeName)
        if not Designs then return end
        return Designs.Simple.ApplyGlobalTheme(themeName)
    end,

    CustomTheme = function(baseColor, name)
        if not Designs then return end
        return Designs.Simple.CustomTheme(baseColor, name)
    end,

    -- API directa
    CreateWindow = function(config)
        if not Window then return end
        return Window.new(config)
    end,

    CreateTab = function(window, name, icon)
        local tabModule = getTab()
        if not tabModule then return end
        return tabModule.new(window, name, icon)
    end,

    CreateLabel = function(parent, text, config)
        if not Elements then return end
        return Elements.Label(parent, text, config)
    end,

    CreateButton = function(parent, text, callback, config)
        if not Elements then return end
        return Elements.Button(parent, text, callback, config)
    end,

    CreateToggle = function(parent, text, default, callback, config)
        if not Elements then return end
        return Elements.Toggle(parent, text, default, callback, config)
    end,

    CreateSlider = function(parent, text, min, max, default, callback, config)
        if not Elements then return end
        return Elements.Slider(parent, text, min, max, default, callback, config)
    end,

    CreateDropdown = function(parent, text, options, default, callback, config)
        if not Elements then return end
        return Elements.Dropdown(parent, text, options, default, callback, config)
    end,

    CreateTextbox = function(parent, text, placeholder, callback, config)
        if not Elements then return end
        return Elements.Textbox(parent, text, placeholder, callback, config)
    end,

    CreateColorPicker = function(parent, text, default, callback, config)
        if not Elements then return end
        return Elements.ColorPicker(parent, text, default, callback, config)
    end,

    Notify = function(text, type, duration, parent)
        local toastModule = getToast()
        if not toastModule then return end
        return toastModule.show(text, type, duration, parent)
    end,

    -- Utilidades
    SetDebug = function(enabled)
        _G.EvoLibsConfig.DEBUG = enabled
    end,

    SetBaseURL = function(url)
        _G.EvoLibsConfig.BASE_URL = url
    end,

    ClearCache = function()
        _G.EvoLibsCache = {}
        collectgarbage()
    end
}

return EvolutionLibs