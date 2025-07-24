-- EvolutionLibs Loader principal

local Utils = loadstring(game:HttpGet("URL/Utils.lua"))()
local Designs = loadstring(game:HttpGet("URL/Designs.lua"))()
local Sidebar = loadstring(game:HttpGet("URL/Sidebar.lua"))()
local Toast = loadstring(game:HttpGet("URL/Toast.lua"))()

local EvolutionLibs = {
	Utils = Utils,
	Designs = Designs,
	Sidebar = Sidebar,
	Toast = Toast,
	-- Aquí puedes agregar Window, Tab, Elements, etc.
}

return EvolutionLibs 