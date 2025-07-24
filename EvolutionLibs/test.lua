-- test.lua - Pruebas de la librería EvolutionLibs

-- Cargar la librería
local success, Evo = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/main/EvolutionLibs/GuiLib.lua"))()
end)

if not success then
    error("[EvolutionLibs] Failed to load library: " .. tostring(Evo))
end

-- Activar modo debug
Evo.SetDebug(true)

-- Configurar tema y opciones
local theme = Evo.Setup("Cyberpunk", {
    AnimationSpeed = 0.25,
    EnableParticles = true,
    EnableGlow = true,
    EnableGradients = true,
    BorderRadius = 14
})

-- Crear ventana principal
local window = Evo.CreateWindow({
    Title = "EvolutionLibs Test",
    Theme = "Cyberpunk",
    Size = {800, 480},
    MinSize = {400, 300},
    Resizable = true
})

-- Crear pestañas
local tabMain = window:CreateTab("Main", "⚡")
local tabThemes = window:CreateTab("Themes", "🎨")
local tabEffects = window:CreateTab("Effects", "✨")

-- Pestaña principal
tabMain:CreateLabel("Welcome to EvolutionLibs", {
    Bold = true,
    TextSize = 24,
    Alignment = "Center",
    Color = theme.Primary
})

tabMain:CreateButton("Show Notification", function()
    Evo.Notify("This is a test notification!", "info", 3)
end)

tabMain:CreateToggle("Enable Feature", false, function(state)
    print("Feature state:", state)
end)

tabMain:CreateSlider("Opacity", 0, 100, 50, function(value)
    print("Opacity:", value)
end)

-- Pestaña de temas
local themes = Evo.Simple.GetThemeNames()
for _, themeName in ipairs(themes) do
    tabThemes:CreateButton(themeName, function()
        window:UpdateTheme(themeName)
        Evo.Notify("Theme changed to " .. themeName, "success", 2)
    end)
end

tabThemes:CreateButton("Custom Theme", function()
    local customTheme = Evo.Simple.CustomTheme(Color3.fromRGB(255, 128, 0), "Custom")
    window:UpdateTheme("Custom")
    Evo.Notify("Applied custom theme", "success", 2)
end)

-- Pestaña de efectos
tabEffects:CreateToggle("Particles", Config.EnableParticles, function(state)
    Config.EnableParticles = state
end)

tabEffects:CreateToggle("Gradients", Config.EnableGradients, function(state)
    Config.EnableGradients = state
end)

tabEffects:CreateToggle("Glow", Config.EnableGlow, function(state)
    Config.EnableGlow = state
end)

tabEffects:CreateSlider("Animation Speed", 1, 100, Config.AnimationSpeed * 100, function(value)
    Config.AnimationSpeed = value / 100
end)

-- Mostrar la ventana
window:Show()
Evo.Notify("EvolutionLibs Test loaded successfully!", "success", 3) 