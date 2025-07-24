-- EvolutionLibs Loader principal

local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/refs/heads/main/EvolutionLibs/Utils/Utils.lua"))()
local Designs = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/raw/refs/heads/main/EvolutionLibs/Designs/Designs.lua"))()
local Sidebar = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/refs/heads/main/EvolutionLibs/Sidebar/Sidebar.lua"))()
local Toast = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/refs/heads/main/EvolutionLibs/Toast/Toast.lua"))()

local EvolutionLibs = {
	Utils = Utils,
	Designs = Designs,
	Sidebar = Sidebar,
	Toast = Toast,
	-- Aquí puedes agregar Window, Tab, Elements, etc.
}

return EvolutionLibs 
