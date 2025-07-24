-- EvolutionLibs Loader principal (compatible con loadstring y GitHub)

local BASE_URL = "https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/main/EvolutionLibs/"

local Utils = loadstring(game:HttpGet(BASE_URL .. "Utils/Utils.lua"))()
local Designs = loadstring(game:HttpGet(BASE_URL .. "Designs/Designs.lua"))()
local Toast = loadstring(game:HttpGet(BASE_URL .. "Toast/Toast.lua"))()
local Window = loadstring(game:HttpGet(BASE_URL .. "Window/Window.lua"))()
local Tab = loadstring(game:HttpGet(BASE_URL .. "Tabs/Tab.lua"))()
local Elements = loadstring(game:HttpGet(BASE_URL .. "Elements/Elements.lua"))()

local Sidebar
local function getSidebar()
    if not Sidebar then
        Sidebar = loadstring(game:HttpGet(BASE_URL .. "Sidebar/Sidebar.lua"))()
    end
    return Sidebar
end

local EvolutionLibs = {
	Utils = Utils,
	Designs = Designs,
	Sidebar = setmetatable({}, {__index = function(_, k) return getSidebar()[k] end}),
	Toast = Toast,
	Window = Window,
	Tab = Tab,
	Elements = Elements,

	-- API simplificada y directa
	Setup = function(themeName, options)
		return Designs.Simple.Setup(themeName, options)
	end,
	Create = function(componentType, parent, config)
		return Designs.Simple.Create(componentType, parent, config)
	end,
	ApplyTheme = function(themeName)
		return Designs.Simple.ApplyGlobalTheme(themeName)
	end,
	CustomTheme = function(baseColor, name)
		return Designs.Simple.CustomTheme(baseColor, name)
	end,

	-- API directa para crear ventanas, pestañas, elementos y notificaciones
	CreateWindow = function(config)
		return Window.new(config)
	end,
	CreateTab = function(window, name, icon)
		return Tab.new(window, name, icon)
	end,
	CreateLabel = function(parent, text, config)
		return Elements.Label(parent, text, config)
	end,
	CreateButton = function(parent, text, callback, config)
		return Elements.Button(parent, text, callback, config)
	end,
	CreateToggle = function(parent, text, default, callback, config)
		return Elements.Toggle(parent, text, default, callback, config)
	end,
	CreateSlider = function(parent, text, min, max, default, callback, config)
		return Elements.Slider(parent, text, min, max, default, callback, config)
	end,
	CreateDropdown = function(parent, text, options, default, callback, config)
		return Elements.Dropdown(parent, text, options, default, callback, config)
	end,
	CreateTextbox = function(parent, text, placeholder, callback, config)
		return Elements.Textbox(parent, text, placeholder, callback, config)
	end,
	CreateColorPicker = function(parent, text, default, callback, config)
		return Elements.ColorPicker(parent, text, default, callback, config)
	end,
	Notify = function(text, type, duration, parent)
		return Toast.show(text, type, duration, parent)
	end,
}

return EvolutionLibs