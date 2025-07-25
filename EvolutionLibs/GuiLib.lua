-- EvolutionLibs Loader principal (compatible con loadstring y GitHub)

-- Configuración global
_G.EvoLibsCache = _G.EvoLibsCache or {}
_G.EvoLibsConfig = _G.EvoLibsConfig or {
    BASE_URL = "https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/main/EvolutionLibs/",
    DEBUG = false
}

-- Sistema de carga de módulos mejorado
local function loadModule(moduleName, path, required)
    if _G.EvoLibsCache[moduleName] then
        return _G.EvoLibsCache[moduleName]
    end

    local success, result = pcall(function()
        return loadstring(game:HttpGet(_G.EvoLibsConfig.BASE_URL .. path))()
    end)

    if success and result then
        _G.EvoLibsCache[moduleName] = result
        if _G.EvoLibsConfig.DEBUG then
            print("[EvolutionLibs] Módulo cargado:", moduleName)
        end
        return result
    else
        warn("[EvolutionLibs] Error al cargar módulo", moduleName .. ":", result)
        if required then
            error("[EvolutionLibs] No se pudo cargar el módulo requerido: " .. moduleName)
        end
        return nil
	end
end

-- Carga de módulos principales (requeridos)
local Utils = loadModule("Utils", "Utils/Utils.lua", true)
local Designs = loadModule("Designs", "Designs/Designs.lua", true)
local Window = loadModule("Window", "Window/Window.lua", true)
local Elements = loadModule("Elements", "Elements/Elements.lua", true)
local Hotkeys = loadModule("Hotkeys", "hotkeys/instakey.lua", true)

if not (Utils and Designs and Window and Elements and Hotkeys) then
    error("[EvolutionLibs] No se pudieron cargar los módulos principales")
end

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

local function getKeyCode(keyName)
    if not keyName or keyName == "None" then return nil end
    if Enum.KeyCode[keyName] then
        return Enum.KeyCode[keyName]
    end
    return nil
end

-- API principal
local EvolutionLibs = {
    Version = "2.0.0",
    Utils = Utils,
    Designs = Designs,
    Window = Window,
    Elements = Elements,
    Hotkeys = Hotkeys,

    -- Módulos con carga lazy y verificación
    Sidebar = setmetatable({}, {
        __index = function(_, k)
            local module = getSidebar()
            if not module then
                warn("[EvolutionLibs] No se pudo acceder al módulo Sidebar")
                return nil
            end
            return module[k]
        end
    }),
    Toast = setmetatable({}, {
        __index = function(_, k)
            local module = getToast()
            if not module then
                warn("[EvolutionLibs] No se pudo acceder al módulo Toast")
                return nil
            end
            return module[k]
        end
    }),
    Tab = setmetatable({}, {
        __index = function(_, k)
            local module = getTab()
            if not module then
                warn("[EvolutionLibs] No se pudo acceder al módulo Tab")
                return nil
            end
            return module[k]
        end
    }),

    -- API simplificada con verificación
    Setup = function(themeName, options)
        if not Designs then
            warn("[EvolutionLibs] No se pudo acceder al módulo Designs")
            return nil
        end
        return Designs.Simple.Setup(themeName, options)
    end,

    Create = function(componentType, parent, config)
        if not Designs then
            warn("[EvolutionLibs] No se pudo acceder al módulo Designs")
            return nil
        end
        return Designs.Simple.Create(componentType, parent, config)
    end,

    ApplyTheme = function(themeName)
        if not Designs then
            warn("[EvolutionLibs] No se pudo acceder al módulo Designs")
            return nil
        end
        return Designs.Simple.ApplyGlobalTheme(themeName)
    end,

    CustomTheme = function(baseColor, name)
        if not Designs then
            warn("[EvolutionLibs] No se pudo acceder al módulo Designs")
            return nil
        end
        return Designs.Simple.CustomTheme(baseColor, name)
    end,

    -- API directa con verificación
    CreateWindow = function(config)
        if not Window then
            warn("[EvolutionLibs] No se pudo acceder al módulo Window")
            return nil
        end
        return Window.new(config)
    end,

    CreateTab = function(window, name, icon)
        local tabModule = getTab()
        if not tabModule then
            warn("[EvolutionLibs] No se pudo acceder al módulo Tab")
            return nil
        end
        return tabModule.new(window, name, icon)
    end,

    CreateLabel = function(parent, text, config)
        if not Elements then
            warn("[EvolutionLibs] No se pudo acceder al módulo Elements")
            return nil
        end
        return Elements.Label(parent, text, config)
    end,

    CreateButton = function(parent, text, callback, config)
        if not Elements then
            warn("[EvolutionLibs] No se pudo acceder al módulo Elements")
            return nil
        end
        return Elements.Button(parent, text, callback, config)
    end,

    CreateToggle = function(parent, text, default, callback, config)
        if not Elements then
            warn("[EvolutionLibs] No se pudo acceder al módulo Elements")
            return nil
        end
        return Elements.Toggle(parent, text, default, callback, config)
    end,

    CreateSlider = function(parent, text, min, max, default, callback, config)
        if not Elements then
            warn("[EvolutionLibs] No se pudo acceder al módulo Elements")
            return nil
        end
        return Elements.Slider(parent, text, min, max, default, callback, config)
    end,

    CreateDropdown = function(parent, text, options, default, callback, config)
        if not Elements then
            warn("[EvolutionLibs] No se pudo acceder al módulo Elements")
            return nil
        end
        return Elements.Dropdown(parent, text, options, default, callback, config)
    end,

    CreateTextbox = function(parent, text, placeholder, callback, config)
        if not Elements then
            warn("[EvolutionLibs] No se pudo acceder al módulo Elements")
            return nil
        end
        return Elements.Textbox(parent, text, placeholder, callback, config)
    end,

    CreateColorPicker = function(parent, text, default, callback, config)
        if not Elements then
            warn("[EvolutionLibs] No se pudo acceder al módulo Elements")
            return nil
        end
        return Elements.ColorPicker(parent, text, default, callback, config)
    end,

    Notify = function(text, type, duration, parent)
        local toastModule = getToast()
        if not toastModule or not toastModule.show then
            warn("[EvolutionLibs] No se pudo acceder al módulo Toast")
            return nil
        end
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
    end,

    -- Verificación de estado
    GetLoadedModules = function()
        local modules = {}
        for name, module in pairs(_G.EvoLibsCache) do
            modules[name] = module ~= nil
        end
        return modules
    end
}

return EvolutionLibs 
