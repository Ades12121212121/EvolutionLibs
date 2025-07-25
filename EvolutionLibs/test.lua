-- LOCAL SCRIPT - Colocar en: StarterPlayer > StarterPlayerScripts
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local Player = Players.LocalPlayer
local character = Player.Character or Player.CharacterAdded:Wait()

-- Anti-AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Variables
local SwingSaber, SellStrength, RemoteClick, UIAction
local Boss = nil
local PlasmaGolem = nil
local autoSwingEnabled = false
local autoSellEnabled = false
local autoClickBossEnabled = false
local autoKillPlasmaEnabled = false

-- Función para esperar los remotes
local function waitForRemotes()
    local success, err = pcall(function()
        local eventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
        SwingSaber = eventsFolder:WaitForChild("SwingSaber", 10)
        SellStrength = eventsFolder:WaitForChild("SellStrength", 10)
        UIAction = eventsFolder:WaitForChild("UIAction", 10)

        -- Buscar al boss
        local gameplay = Workspace:WaitForChild("Gameplay", 10)
        local bossFolder = gameplay:WaitForChild("Boss", 10)
        local bossHolder = bossFolder:WaitForChild("BossHolder", 10)
        Boss = bossHolder:WaitForChild("Boss", 10)

        -- Buscar Plasma Golem
        local regionsLoaded = gameplay:WaitForChild("RegionsLoaded", 10)
        local plasmaArea = regionsLoaded:WaitForChild("AdvancedPlasmaArea", 10)
        local important = plasmaArea:WaitForChild("Important", 10)
        local plasma = important:WaitForChild("Plasma", 10)
        PlasmaGolem = plasma:WaitForChild("Plasma Golem", 10)
    end)

    if not success then
        warn("Error al esperar los remotes o elementos del juego:", err)
    end
end

-- Función para obtener el RemoteClick actual
local function getCurrentRemoteClick()
    local char = Player.Character
    if not char then return nil end
    
    -- Intentar obtener de White y Green (por si cambia el color)
    local white = char:FindFirstChild("White")
    local green = char:FindFirstChild("Green")
    
    if white and white:FindFirstChild("RemoteClick") then
        return white.RemoteClick
    elseif green and green:FindFirstChild("RemoteClick") then
        return green.RemoteClick
    end
    
    return nil
end

-- Crear GUI usando EvolutionLibs
local function createGUI()
    if Player.PlayerGui:FindFirstChild("AutoFarmUI") then
        warn("GUI ya existe, no se creará nuevamente")
        return
    end

    -- Cargar EvolutionLibs
    local success, Evo = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/main/EvolutionLibs/GuiLib.lua"))()
    end)

    if not success then
        warn("[AutoFarm] Error al cargar EvolutionLibs:", Evo)
        return
    end

    -- Activar modo debug
    Evo.SetDebug(true)

    -- Crear ventana principal con sidebar redimensionable y ancho inicial 220
    local window = Evo.CreateWindow({
        Title = "Saber Simulator - EvolutionX",
        Theme = "Dark",
        Size = {400, 400},
        sidebar = true, -- Cambia a false para ocultar el sidebar
        SidebarWidth = 220
    })

    if window then
        local container = window.Content
        if container then
            -- Ejemplo: Label con posición y tamaño personalizados (absoluto)
            Evo.Elements.Label(container, "Label Absoluto", {
                Size = UDim2.new(0, 180, 0, 40),
                Position = UDim2.new(0, 30, 0, 30),
                Bold = true,
                TextSize = 18,
                Alignment = "Center"
            })

            -- Ejemplo: Botón con posición y tamaño personalizados (absoluto)
            Evo.Elements.Button(container, "Botón Absoluto", function()
                Evo.Notify("¡Botón presionado!", "success", 2)
            end, {
                Size = UDim2.new(0, 160, 0, 40),
                Position = UDim2.new(0, 60, 0, 90),
                Bold = true,
                TextSize = 16
            })

            -- Ejemplo: Toggle con layout automático (se apila debajo)
            Evo.Elements.Toggle(container, "Toggle Automático", false, function(val)
                print("Toggle:", val)
            end)

            -- Ejemplo: Label con layout automático
            Evo.Elements.Label(container, "Label Automático")
        end
        window:Show()
    end

    if window then
        -- Contenedor principal
        local container = window.Content
        if container then
            -- Sección: Auto Farm
            Evo.Elements.Label(container, "Auto Farm", {
                Bold = true,
                TextSize = 20,
                Alignment = "Center"
            })

            -- Auto Swing
            local swingToggle = Evo.Elements.Toggle(container, "Auto Swing", false, function(enabled)
                autoSwingEnabled = enabled
                Evo.Hotkeys.setEnabled("autoSwing", enabled)
                
                task.spawn(function()
                    while autoSwingEnabled do
                        pcall(function()
                            if SwingSaber then SwingSaber:FireServer() end
                        end)
                        task.wait(0.001)
                    end
                end)
            end)

            -- Auto Sell
            local sellToggle = Evo.Elements.Toggle(container, "Auto Sell", false, function(enabled)
                autoSellEnabled = enabled
                Evo.Hotkeys.setEnabled("autoSell", enabled)
                
                task.spawn(function()
                    while autoSellEnabled do
                        pcall(function()
                            if SellStrength then SellStrength:FireServer() end
                        end)
                        task.wait(0.001)
                    end
                end)
            end)

            -- Auto Click Boss
            local bossToggle = Evo.Elements.Toggle(container, "Auto Click Boss", false, function(enabled)
                autoClickBossEnabled = enabled
                Evo.Hotkeys.setEnabled("autoBoss", enabled)
                
                task.spawn(function()
                    while autoClickBossEnabled do
                        pcall(function()
                            local currentRemoteClick = getCurrentRemoteClick()
                            if Boss and Boss:FindFirstChild("Humanoid") and Boss.Humanoid.Health > 0 and currentRemoteClick then
                                currentRemoteClick:FireServer({Boss})
                            else
                                local gameplay = Workspace:FindFirstChild("Gameplay")
                                local holder = gameplay and gameplay:FindFirstChild("Boss") and gameplay.Boss:FindFirstChild("BossHolder")
                                Boss = holder and holder:FindFirstChild("Boss")
                            end
                        end)
                        task.wait(0.001)
                    end
                end)
            end)

            -- Auto Kill Plasma Golem
            local plasmaToggle = Evo.Elements.Toggle(container, "Auto Kill Plasma", false, function(enabled)
                autoKillPlasmaEnabled = enabled
                Evo.Hotkeys.setEnabled("autoPlasma", enabled)
                
                task.spawn(function()
                    while autoKillPlasmaEnabled do
                        pcall(function()
                            local currentRemoteClick = getCurrentRemoteClick()
                            if PlasmaGolem and PlasmaGolem:FindFirstChild("Humanoid") and PlasmaGolem.Humanoid.Health > 0 and currentRemoteClick then
                                currentRemoteClick:FireServer({PlasmaGolem})
                            else
                                local gameplay = Workspace:FindFirstChild("Gameplay")
                                if gameplay then
                                    local regionsLoaded = gameplay:FindFirstChild("RegionsLoaded")
                                    if regionsLoaded then
                                        local plasmaArea = regionsLoaded:FindFirstChild("AdvancedPlasmaArea")
                                        if plasmaArea then
                                            local important = plasmaArea:FindFirstChild("Important")
                                            if important then
                                                local plasma = important:FindFirstChild("Plasma")
                                                if plasma then
                                                    PlasmaGolem = plasma:FindFirstChild("Plasma Golem")
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                        task.wait(0.001)
                    end
                end)
            end)

            -- Separador
            Evo.Elements.Label(container, "", {TextSize = 10})

            -- Sección: Compras
            Evo.Elements.Label(container, "Compras", {
                Bold = true,
                TextSize = 20,
                Alignment = "Center"
            })

            -- Buy All Weapons
            Evo.Elements.Button(container, "Comprar Todas las Armas", function()
                pcall(function()
                    if UIAction then UIAction:FireServer("BuyAllWeapons") end
                end)
            end)

            -- Buy All DNA
            Evo.Elements.Button(container, "Comprar Todos los DNA", function()
                pcall(function()
                    if UIAction then UIAction:FireServer("BuyAllDNAs") end
                end)
            end)

            -- Separador
            Evo.Elements.Label(container, "", {TextSize = 10})

            -- Sección: Hotkeys
            Evo.Elements.Label(container, "Hotkeys", {
                Bold = true,
                TextSize = 20,
                Alignment = "Center"
            })

            -- Registrar hotkeys
            local hotkeys = {
                {id = "autoSwing", key = "Q", label = "Auto Swing", toggle = swingToggle},
                {id = "autoSell", key = "E", label = "Auto Sell", toggle = sellToggle},
                {id = "autoBoss", key = "R", label = "Auto Boss", toggle = bossToggle},
                {id = "autoPlasma", key = "T", label = "Auto Plasma", toggle = plasmaToggle},
                {id = "buyWeapons", key = "F", label = "Buy Weapons"},
                {id = "buyDNA", key = "G", label = "Buy DNA"},
                {id = "toggleGUI", key = "RightControl", label = "Toggle GUI"}
            }

            -- Crear contenedores de hotkeys
            for _, hotkey in ipairs(hotkeys) do
                -- Label para la hotkey
                local hotkeyContainer = Instance.new("Frame")
                hotkeyContainer.Size = UDim2.new(1, -20, 0, 25)
                hotkeyContainer.BackgroundTransparency = 1
                hotkeyContainer.Parent = container

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -60, 1, 0)
                label.Position = UDim2.new(0, 0, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = hotkey.label .. ":"
                label.TextColor3 = Color3.fromRGB(200, 200, 200)
                label.TextSize = 14
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = hotkeyContainer

                -- Botón de hotkey
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(0, 50, 1, 0)
                button.Position = UDim2.new(1, -50, 0, 0)
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                button.Text = hotkey.key
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 12
                button.Font = Enum.Font.GothamBold
                button.Parent = hotkeyContainer

                -- Esquinas redondeadas
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 4)
                corner.Parent = button

                -- Registrar hotkey
                local callback = hotkey.toggle and function()
                    hotkey.toggle:SetValue(not hotkey.toggle.Value)
                end or function()
                    if hotkey.id == "buyWeapons" then
                        if UIAction then UIAction:FireServer("BuyAllWeapons") end
                    elseif hotkey.id == "buyDNA" then
                        if UIAction then UIAction:FireServer("BuyAllDNAs") end
                    elseif hotkey.id == "toggleGUI" then
                        window:ToggleFocus()
                    end
                end

                Evo.Hotkeys.register(hotkey.id, hotkey.key, callback)

                -- Click para cambiar hotkey
                button.MouseButton1Click:Connect(function()
                    button.Text = "..."
                    Evo.Hotkeys.startListening(function(newKey)
                        if newKey then
                            Evo.Hotkeys.setHotkey(hotkey.id, Evo.Hotkeys.getKeyCode(newKey))
                            button.Text = newKey
                        end
                    end)
                end)
            end

            -- Cargar configuración guardada de hotkeys
            Evo.Hotkeys.loadConfig()
        end

        -- Mostrar la ventana
        window:Show()
    end
end

-- Iniciar
waitForRemotes()
createGUI()

-- Reconectar GUI y remotes si el personaje cambia
Player.CharacterAdded:Connect(function(newChar)
    character = newChar
    task.wait(1)
    waitForRemotes()
    createGUI()
end)
