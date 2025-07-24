local success, Evo = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/main/EvolutionLibs/GuiLib.lua"))()
end)

if not success then
    warn("[Test] Error al cargar librería:", Evo)
    return
end

-- Activar modo debug para ver mensajes detallados
Evo.SetDebug(true)

-- Crear ventana de prueba
local window = Evo.CreateWindow({
    Title = "Test Window",
    Theme = "Dark", -- Cambiado de Cyberpunk a Dark para evitar problemas
    Size = {600, 400}
})

if window then
    local tab = window:CreateTab("Test", "⚡")
    if tab then
        tab:CreateLabel("Test Label", {
            Bold = true,
            TextSize = 18
        })
        window:Show()
        Evo.Notify("Test completado", "success", 3)
    end
end