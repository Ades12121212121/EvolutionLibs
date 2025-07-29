-- DISEÑO GUI - Saber Simulator v2.0
-- Diseño minimalista de alta sofisticación
-- Requiere EvolutionX-net8 para funcionar correctamente

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

-- Configurar parent de la GUI para EvolutionX
local guiParent = nil
pcall(function()
    guiParent = game:GetService("CoreGui")
end)
if not guiParent then
    guiParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- Asegurar que los servicios estén disponibles
local success, err = pcall(function()
    Players = game:GetService("Players")
    Player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    ReplicatedStorage = game:GetService("ReplicatedStorage")
    RunService = game:GetService("RunService")
    UserInputService = game:GetService("UserInputService")
    VirtualUser = game:GetService("VirtualUser")
    TweenService = game:GetService("TweenService")
end)

if not success then
    warn("[EvolutionX] Error al cargar servicios: " .. tostring(err))
    return
end

-- Eliminar GUI previa si existe
local old = guiParent:FindFirstChild("SaberSimulatorGUI")
if old then old:Destroy() end

-- Crear ScreenGui principal
local gui = Instance.new("ScreenGui")
gui.Name = "SaberSimulatorGUI"
gui.ResetOnSpawn = false
if guiParent == game:GetService("CoreGui") then
    gui.Parent = guiParent
else
    gui.Parent = Player:WaitForChild("PlayerGui")
end

-- Reposicionar GUI al respawn
Player.CharacterAdded:Connect(function()
    if gui and gui.Parent ~= guiParent then
        gui.Parent = guiParent
    end
end)

-- Frame principal con diseño refinado
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 340, 0, 380)
main.Position = UDim2.new(0.5, -170, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

-- Borde sutil con gradiente
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(45, 45, 55)
border.Thickness = 1.5
border.Parent = main

-- Sombra sutil
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 8, 1, 8)
shadow.Position = UDim2.new(0, 4, 0, 4)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ZIndex = -1
shadow.Parent = main

-- Barra superior elegante
local topbar = Instance.new("Frame")
topbar.Name = "Topbar"
topbar.Size = UDim2.new(1, 0, 0, 48)
topbar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
topbar.BorderSizePixel = 0
topbar.Parent = main

local topbarCorner = Instance.new("UICorner")
topbarCorner.CornerRadius = UDim.new(0, 16)
topbarCorner.Parent = topbar

-- Gradiente sutil en la barra superior
local topbarGradient = Instance.new("UIGradient")
topbarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 26))
}
topbarGradient.Rotation = 90
topbarGradient.Parent = topbar

-- Icono del título con jewel tone
local titleIcon = Instance.new("ImageLabel")
titleIcon.Size = UDim2.new(0, 24, 0, 24)
titleIcon.Position = UDim2.new(0, 16, 0, 12)
titleIcon.BackgroundTransparency = 1
titleIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
titleIcon.ImageColor3 = Color3.fromRGB(72, 149, 239) -- Jewel blue
titleIcon.Parent = topbar

-- Título con tipografía audaz
local title = Instance.new("TextLabel")
title.Text = "SABER SIMULATOR"
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 48, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

-- Versión elegante
local versionLabel = Instance.new("TextLabel")
versionLabel.Text = "v2.0"
versionLabel.Font = Enum.Font.GothamMedium
versionLabel.TextSize = 10
versionLabel.TextColor3 = Color3.fromRGB(72, 149, 239)
versionLabel.BackgroundTransparency = 1
versionLabel.Size = UDim2.new(0, 40, 0, 16)
versionLabel.Position = UDim2.new(0, 48, 0, 32)
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.Parent = topbar

-- Botón cerrar refinado
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(255, 95, 95)
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -40, 0, 8)
closeBtn.Parent = topbar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

-- Animaciones del botón cerrar
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(255, 95, 95), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(35, 35, 40), TextColor3 = Color3.fromRGB(255, 95, 95)}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

-- Botón minimizar elegante
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "−"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
minimizeBtn.Position = UDim2.new(1, -80, 0, 8)
minimizeBtn.Parent = topbar

local minimizeBtnCorner = Instance.new("UICorner")
minimizeBtnCorner.CornerRadius = UDim.new(0, 8)
minimizeBtnCorner.Parent = minimizeBtn

-- Animaciones del botón minimizar
minimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(72, 149, 239), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
minimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(35, 35, 40), TextColor3 = Color3.fromRGB(180, 180, 200)}):Play()
end)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(main, TweenInfo.new(0.3), {Size = UDim2.new(0, 340, 0, 48)}):Play()
    else
        TweenService:Create(main, TweenInfo.new(0.3), {Size = UDim2.new(0, 340, 0, 380)}):Play()
    end
end)

-- Mostrar/ocultar GUI con Insert
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        gui.Enabled = not gui.Enabled
    end
end)

-- Barra de pestañas sofisticada
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, 0, 0, 40)
tabBar.Position = UDim2.new(0, 0, 0, 48)
tabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
tabBar.BorderSizePixel = 0
tabBar.Parent = main

local tabBarStroke = Instance.new("UIStroke")
tabBarStroke.Color = Color3.fromRGB(45, 45, 55)
tabBarStroke.Thickness = 1
tabBarStroke.Parent = tabBar

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0, 2)
tabList.Parent = tabBar

-- Nombres de las pestañas con iconos
local tabNames = {"Main", "Auto", "Player", "Golems", "Settings"}
local tabIcons = {"🏠", "⚡", "👤", "🔥", "⚙️"}
local tabButtons = {}
local tabFrames = {}
local selectedTab = nil

-- Área de contenido refinada
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -88)
content.Position = UDim2.new(0, 0, 0, 88)
content.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
content.BorderSizePixel = 0
content.Parent = main

-- Crear pestañas con diseño mejorado
for i, tabName in ipairs(tabNames) do
    -- Botón de pestaña elegante
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "TabButton_"..tabName
    tabBtn.Text = tabIcons[i] .. " " .. tabName
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextSize = 12
    tabBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
    tabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    tabBtn.Size = UDim2.new(0.2, -2, 1, 0)
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = tabBar
    tabButtons[tabName] = tabBtn
    
    local tabBtnCorner = Instance.new("UICorner")
    tabBtnCorner.CornerRadius = UDim.new(0, 8)
    tabBtnCorner.Parent = tabBtn
    
    -- Frame de contenido de la pestaña
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = "TabFrame_"..tabName
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.Position = UDim2.new(0, 0, 0, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 6
    tabFrame.ScrollBarImageColor3 = Color3.fromRGB(72, 149, 239)
    tabFrame.Visible = false
    tabFrame.Parent = content
    tabFrames[tabName] = tabFrame
    
    -- Layout para la pestaña
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 12)
    tabLayout.Parent = tabFrame
    
    -- Padding para la pestaña
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 16)
    tabPadding.PaddingLeft = UDim.new(0, 16)
    tabPadding.PaddingRight = UDim.new(0, 16)
    tabPadding.PaddingBottom = UDim.new(0, 16)
    tabPadding.Parent = tabFrame
end

local function selectTab(tabName)
    for name, frame in pairs(tabFrames) do
        frame.Visible = (name == tabName)
        local btn = tabButtons[name]
        if name == tabName then
            btn.BackgroundColor3 = Color3.fromRGB(72, 149, 239)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            btn.TextColor3 = Color3.fromRGB(160, 160, 170)
        end
    end
    selectedTab = tabName
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        selectTab(name)
    end)
end
selectTab(tabNames[1])

-- Función para crear switches modernos
local function createSwitch(parent, text, default, callback, layoutOrder)
    local container = Instance.new("Frame")
    container.Name = "SwitchContainer"
    container.Size = UDim2.new(1, -32, 0, 32)
    container.BackgroundTransparency = 1
    container.LayoutOrder = layoutOrder
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local switchFrame = Instance.new("Frame")
    switchFrame.Size = UDim2.new(0, 44, 0, 24)
    switchFrame.Position = UDim2.new(1, -44, 0.5, -12)
    switchFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    switchFrame.BorderSizePixel = 0
    switchFrame.Parent = container
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 12)
    switchCorner.Parent = switchFrame
    
    local switchButton = Instance.new("TextButton")
    switchButton.Size = UDim2.new(0, 20, 0, 20)
    switchButton.Position = UDim2.new(0, 2, 0, 2)
    switchButton.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
    switchButton.BorderSizePixel = 0
    switchButton.Text = ""
    switchButton.Parent = switchFrame
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = switchButton
    
    local enabled = default
    
    local function updateSwitch()
        if enabled then
            TweenService:Create(switchFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(72, 149, 239)}):Play()
            TweenService:Create(switchButton, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0, 2)}):Play()
            TweenService:Create(switchButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(switchFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(switchButton, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
            TweenService:Create(switchButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 180, 190)}):Play()
        end
    end
    
    switchButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateSwitch()
        callback(enabled)
    end)
    
    updateSwitch()
    
    return container, function() return enabled end, function(state) enabled = state updateSwitch() end
end

-- Función para crear botones modernos
local function createButton(parent, text, callback, layoutOrder)
    local button = Instance.new("TextButton")
    button.Name = "ModernButton"
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 13
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(72, 149, 239)
    button.Size = UDim2.new(1, -32, 0, 32)
    button.BorderSizePixel = 0
    button.LayoutOrder = layoutOrder
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(90, 170, 255)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 170, 255)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(72, 149, 239)}):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Función para crear sliders modernos
local function createSlider(parent, text, min, max, default, callback, layoutOrder)
    local container = Instance.new("Frame")
    container.Name = "SliderContainer"
    container.Size = UDim2.new(1, -32, 0, 46)
    container.BackgroundTransparency = 1
    container.LayoutOrder = layoutOrder
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Text = text .. ": " .. tostring(default)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 20)
    sliderBg.Position = UDim2.new(0, 0, 0, 22)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 10)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(72, 149, 239)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 10)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0, 8)
    sliderButtonCorner.Parent = sliderButton
    
    local value = default
    local dragging = false
    
    local function updateSlider(newValue)
        value = math.clamp(newValue, min, max)
        local percent = (value - min) / (max - min)
        label.Text = text .. ": " .. tostring(math.floor(value * 100) / 100)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, -8, 0.5, -8)
        callback(value)
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = Player:GetMouse()
            local percent = math.clamp((mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            updateSlider(min + (max - min) * percent)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return container, function() return value end
end

-- Pestaña Main con diseño sofisticado
local mainTab = tabFrames["Main"]

-- Panel de bienvenida elegante
local welcomePanel = Instance.new("Frame")
welcomePanel.Name = "WelcomePanel"
welcomePanel.Size = UDim2.new(1, -32, 0, 120)
welcomePanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
welcomePanel.BorderSizePixel = 0
welcomePanel.LayoutOrder = 1
welcomePanel.Parent = mainTab

local welcomePanelCorner = Instance.new("UICorner")
welcomePanelCorner.CornerRadius = UDim.new(0, 12)
welcomePanelCorner.Parent = welcomePanel

local welcomePanelStroke = Instance.new("UIStroke")
welcomePanelStroke.Color = Color3.fromRGB(45, 45, 55)
welcomePanelStroke.Thickness = 1
welcomePanelStroke.Parent = welcomePanel

local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Text = "🗡️ SABER SIMULATOR"
welcomeLabel.Font = Enum.Font.GothamBlack
welcomeLabel.TextSize = 18
welcomeLabel.TextColor3 = Color3.fromRGB(72, 149, 239)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Size = UDim2.new(1, -32, 0, 28)
welcomeLabel.Position = UDim2.new(0, 16, 0, 16)
welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center
welcomeLabel.Parent = welcomePanel

local scriptByLabel = Instance.new("TextLabel")
scriptByLabel.Text = "Script By: EvolutionX"
scriptByLabel.Font = Enum.Font.GothamSemibold
scriptByLabel.TextSize = 13
scriptByLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
scriptByLabel.BackgroundTransparency = 1
scriptByLabel.Size = UDim2.new(1, -32, 0, 20)
scriptByLabel.Position = UDim2.new(0, 16, 0, 44)
scriptByLabel.TextXAlignment = Enum.TextXAlignment.Center
scriptByLabel.Parent = welcomePanel

local developerLabel = Instance.new("TextLabel")
developerLabel.Text = "Developer: Pcr087"
developerLabel.Font = Enum.Font.Gotham
developerLabel.TextSize = 12
developerLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
developerLabel.BackgroundTransparency = 1
developerLabel.Size = UDim2.new(1, -32, 0, 18)
developerLabel.Position = UDim2.new(0, 16, 0, 64)
developerLabel.TextXAlignment = Enum.TextXAlignment.Center
developerLabel.Parent = welcomePanel

local versionLabel = Instance.new("TextLabel")
versionLabel.Text = "v2.0"
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 11
versionLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
versionLabel.BackgroundTransparency = 1
versionLabel.Size = UDim2.new(1, -32, 0, 16)
versionLabel.Position = UDim2.new(0, 16, 0, 82)
versionLabel.TextXAlignment = Enum.TextXAlignment.Center
versionLabel.Parent = welcomePanel

-- Panel de estado elegante
local statusPanel = Instance.new("Frame")
statusPanel.Name = "StatusPanel"
statusPanel.Size = UDim2.new(1, -32, 0, 60)
statusPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
statusPanel.BorderSizePixel = 0
statusPanel.LayoutOrder = 2
statusPanel.Parent = mainTab

local statusPanelCorner = Instance.new("UICorner")
statusPanelCorner.CornerRadius = UDim.new(0, 12)
statusPanelCorner.Parent = statusPanel

local statusPanelStroke = Instance.new("UIStroke")
statusPanelStroke.Color = Color3.fromRGB(45, 45, 55)
statusPanelStroke.Thickness = 1
statusPanelStroke.Parent = statusPanel

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "✅ GUI Cargada Exitosamente"
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(100, 200, 120)
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(1, -32, 0, 20)
statusLabel.Position = UDim2.new(0, 16, 0, 12)
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = statusPanel

local infoLabel = Instance.new("TextLabel")
infoLabel.Text = "💡 Presiona INSERT para mostrar/ocultar"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 12
infoLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
infoLabel.BackgroundTransparency = 1
infoLabel.Size = UDim2.new(1, -32, 0, 18)
infoLabel.Position = UDim2.new(0, 16, 0, 32)
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.Parent = statusPanel

-- Auto tab
local autoTab = tabFrames["Auto"]
local SwingSaber = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("SwingSaber")
local SellStrength = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("SellStrength")
local CollectCurrencyPickup = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("CollectCurrencyPickup")
local UIAction = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("UIAction")

local autoSwing = false
local autoSwingDelay = 0.01
local autoSwingConn
local autoSell = false
local autoSellConn
local autoCollect = false
local autoCollectConn

local autoSwingSwitch, getAutoSwing = createSwitch(autoTab, "🗡️ Auto Swing", false, function(enabled)
    autoSwing = enabled
    if autoSwingConn then autoSwingConn:Disconnect() autoSwingConn = nil end
    if enabled and SwingSaber then
        autoSwingConn = RunService.RenderStepped:Connect(function()
            pcall(function() SwingSaber:FireServer() end)
            task.wait(autoSwingDelay)
        end)
    end
end, 1)

createSlider(autoTab, "⚡ Velocidad de Ataque", 0.001, 0.5, 0.01, function(val)
    autoSwingDelay = val
end, 2)

createSwitch(autoTab, "💰 Auto Sell", false, function(enabled)
    autoSell = enabled
    if autoSellConn then autoSellConn:Disconnect() autoSellConn = nil end
    if enabled and SellStrength then
        autoSellConn = RunService.RenderStepped:Connect(function()
            pcall(function() SellStrength:FireServer() end)
            task.wait(0.1)
        end)
    end
end, 3)

createSwitch(autoTab, "🪙 Auto Collect", false, function(enabled)
    autoCollect = enabled
    if autoCollectConn then autoCollectConn:Disconnect() autoCollectConn = nil end
    if enabled and CollectCurrencyPickup then
        autoCollectConn = RunService.RenderStepped:Connect(function()
            pcall(function() CollectCurrencyPickup:FireServer({"Crown"}) end)
            task.wait(0.1)
        end)
    end
end, 4)

-- Variables para Auto Shop All Weapons
local autoShopWeaponsEnabled = false
local autoShopWeaponsConn

-- Variables para Auto Class Up
local autoClassUpEnabled = false
local autoClassUpConn

-- Función para comprar la siguiente clase disponible
local function buyNextClass()
    if UIAction then
        -- Lista de clases en orden
        local classes = {
            "Noob", "Apprentice", "Soldier", "Paladin", "Assassin", "Warrior", "Warlord", "Berserker", "Saber", "Cyborg",
            "Master", "Titan", "Phantom", "Shadow", "Ghoul", "Tempest", "Elementalist", "Beast", "Dark Ninja", "Warlock",
            "Overlord", "Demigod", "Archangel", "Wraith", "Deity", "Nemesis", "Executioner", "Terminator", "Colossus", "Zeus",
            "Elf", "Santa", "Corruptor", "Prestige", "Caster", "Cyclops", "King", "Hacker", "Angel", "Minotaur",
            "Cerberus", "Yeti", "Samurai", "Baron", "Detective", "Red Baron", "Witch", "Gladiator", "Purple Baron", "Guard",
            "Shadow Titan", "Superhuman", "Brain", "Shadow Guard", "Shadow Gladiator", "Red Elf", "Gingerbread", "Ninja Warrior", "Snowman", "Lord Of Death",
            "Demonic", "Alien", "Ghost", "Dracula", "Golem", "Dragon", "Spirit", "Pharaoh", "Mummy", "Ape",
            "Robot", "Goblin", "Techno", "Golden Warrior", "Golden Royalty", "Demonic Imp", "Anubis", "Illuminati", "Hydra", "Skeleton",
            "Supervillain", "Dark Slayer", "Dark Spider", "Troll", "Shark", "Pirate", "Kraken", "Genie", "Cobra", "Sphinx",
            "Dark Witch", "Knight", "Chimera", "Kitsune", "Odin", "Cowboy", "Undead", "Satyr", "Hermes", "Hades",
            "Faun", "Giant", "Ignivar", "Aviator", "Astronaut", "Poseidon"
        }
        
        -- Obtener la clase actual del usuario
        local currentClass = ""
        pcall(function()
            currentClass = Player.Character and Player.Character:FindFirstChild("Class") and Player.Character.Class.Value or ""
        end)
        
        -- Encontrar el índice de la clase actual
        local currentIndex = 0
        for i, class in ipairs(classes) do
            if class == currentClass then
                currentIndex = i
                break
            end
        end
        
        -- Comprar solo la siguiente clase
        if currentIndex > 0 and currentIndex < #classes then
            local nextClass = classes[currentIndex + 1]
            pcall(function() 
                UIAction:FireServer("BuyClass", nextClass) 
                statusLabel.Text = "✅ Intentando comprar: " .. nextClass
            end)
        else
            -- Si no se encuentra la clase actual, intentar con la primera
            pcall(function() 
                UIAction:FireServer("BuyClass", classes[1]) 
                statusLabel.Text = "✅ Intentando comprar: " .. classes[1]
            end)
        end
    end
end

-- Botón para comprar la siguiente clase una vez
createButton(autoTab, "👑 Comprar Siguiente Clase (Una vez)", function()
    buyNextClass()
end, 5)

-- Switch para Auto Class Up
createSwitch(autoTab, "🔄 Auto Class Up", false, function(enabled)
    autoClassUpEnabled = enabled
    if autoClassUpConn then autoClassUpConn:Disconnect() autoClassUpConn = nil end
    
    if enabled then
        local lastAttemptTime = 0
        autoClassUpConn = RunService.Heartbeat:Connect(function()
            local currentTime = os.clock()
            if currentTime - lastAttemptTime >= 0.8 then -- Cooldown de 0.8 segundos
                lastAttemptTime = currentTime
                buyNextClass()
            end
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Class Up", 
            Text = "¡Auto Class Up activado!", 
            Duration = 2
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Class Up", 
            Text = "Auto Class Up desactivado", 
            Duration = 2
        })
    end
end, 6)

-- Botón para comprar todas las armas una vez
createButton(autoTab, "🛒 Comprar Todas las Armas (Una vez)", function()
    if UIAction then
        pcall(function() UIAction:FireServer("BuyAllWeapons") end)
    end
end, 7)

-- Switch para Auto Shop All Weapons (bucle)
createSwitch(autoTab, "🔄 Auto Shop All Weapons", false, function(enabled)
    autoShopWeaponsEnabled = enabled
    if autoShopWeaponsConn then autoShopWeaponsConn:Disconnect() autoShopWeaponsConn = nil end
    
    if enabled then
        autoShopWeaponsConn = RunService.RenderStepped:Connect(function()
            if UIAction then
                pcall(function() UIAction:FireServer("BuyAllWeapons") end)
            end
            task.wait(5) -- Esperar 5 segundos entre cada compra
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Shop", 
            Text = "¡Auto Shop All Weapons activado!", 
            Duration = 2
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Shop", 
            Text = "Auto Shop All Weapons desactivado", 
            Duration = 2
        })
    end
end, 8)

-- Variables para Auto Shop All DNAs
local autoShopDNAsEnabled = false
local autoShopDNAsConn

-- Botón para comprar todos los ADN una vez
createButton(autoTab, "🧬 Comprar Todos los ADN (Una vez)", function()
    if UIAction then
        pcall(function() UIAction:FireServer("BuyAllDNAs") end)
    end
end, 9)

-- Switch para Auto Shop All DNAs (bucle)
createSwitch(autoTab, "🔄 Auto Shop All DNAs", false, function(enabled)
    autoShopDNAsEnabled = enabled
    if autoShopDNAsConn then autoShopDNAsConn:Disconnect() autoShopDNAsConn = nil end
    
    if enabled then
        autoShopDNAsConn = RunService.RenderStepped:Connect(function()
            if UIAction then
                pcall(function() UIAction:FireServer("BuyAllDNAs") end)
            end
            task.wait(5) -- Esperar 5 segundos entre cada compra
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Shop", 
            Text = "¡Auto Shop All DNAs activado!", 
            Duration = 2
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Shop", 
            Text = "Auto Shop All DNAs desactivado", 
            Duration = 2
        })
    end
end, 10)

-- Botón para vender todo una vez (Sell All)
createButton(autoTab, "💰 Sell All (Una vez)", function()
    if SellStrength then
        pcall(function() SellStrength:FireServer() end)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Sell All", 
            Text = "¡Has vendido todo exitosamente!", 
            Duration = 2
        })
    end
end, 11)

-- Player tab
local playerTab = tabFrames["Player"]
local walkspeed = 16
local noclipEnabled = false
local noclipConn
local infJumpEnabled = false
local infJumpConn
local antiAfkEnabled = false
local antiAfkConn
local afkFarmEnabled = false
local afkFarmConn

createSlider(playerTab, "🏃 Velocidad de Caminar", 16, 100, 16, function(val)
    walkspeed = val
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = walkspeed
    end
end, 1)

createSwitch(playerTab, "👻 NoClip", false, function(enabled)
    noclipEnabled = enabled
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if enabled then
        noclipConn = RunService.Stepped:Connect(function()
            local char = Player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end, 2)

createSwitch(playerTab, "🚀 Salto Infinito", false, function(enabled)
    infJumpEnabled = enabled
    if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    if enabled then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end, 3)

createSwitch(playerTab, "💤 Anti AFK", false, function(enabled)
    antiAfkEnabled = enabled
    if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
    if enabled then
        antiAfkConn = RunService.RenderStepped:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500), workspace.CurrentCamera)
        end)
    end
end, 4)

createSwitch(playerTab, "🤖 AFK Farm", false, function(enabled)
    afkFarmEnabled = enabled
    -- Activar auto swing, auto sell y anti-afk automáticamente
    if enabled then
        -- Auto Swing
        if not autoSwing then
            autoSwing = true
            if autoSwingConn then autoSwingConn:Disconnect() autoSwingConn = nil end
            if SwingSaber then
                autoSwingConn = RunService.RenderStepped:Connect(function()
                    pcall(function() SwingSaber:FireServer() end)
                    task.wait(autoSwingDelay)
                end)
            end
        end
        -- Auto Sell
        if not autoSell then
            autoSell = true
            if autoSellConn then autoSellConn:Disconnect() autoSellConn = nil end
            if SellStrength then
                autoSellConn = RunService.RenderStepped:Connect(function()
                    pcall(function() SellStrength:FireServer() end)
                    task.wait(0.1)
                end)
            end
        end
        -- Anti-AFK
        if not antiAfkEnabled then
            antiAfkEnabled = true
            if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
            antiAfkConn = RunService.RenderStepped:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(500, 500), workspace.CurrentCamera)
            end)
        end
    else
        -- Desactivar todo cuando se desactive AFK Farm
        if autoSwing then
            autoSwing = false
            if autoSwingConn then autoSwingConn:Disconnect() autoSwingConn = nil end
        end
        if autoSell then
            autoSell = false
            if autoSellConn then autoSellConn:Disconnect() autoSellConn = nil end
        end
        if antiAfkEnabled then
            antiAfkEnabled = false
            if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
        end
    end
end, 5)

-- Teleportación
local teleportContainer = Instance.new("Frame")
teleportContainer.Name = "TeleportContainer"
teleportContainer.Size = UDim2.new(1, -16, 0, 80)
teleportContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
teleportContainer.BorderSizePixel = 0
teleportContainer.LayoutOrder = 6
teleportContainer.Parent = playerTab
local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 6)
teleportCorner.Parent = teleportContainer

local teleportTitle = Instance.new("TextLabel")
teleportTitle.Text = "📍 Teleportación por Coordenadas"
teleportTitle.Font = Enum.Font.GothamSemibold
teleportTitle.TextSize = 12
teleportTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
teleportTitle.BackgroundTransparency = 1
teleportTitle.Size = UDim2.new(1, -16, 0, 20)
teleportTitle.Position = UDim2.new(0, 8, 0, 4)
teleportTitle.TextXAlignment = Enum.TextXAlignment.Left
teleportTitle.Parent = teleportContainer

local coordsFrame = Instance.new("Frame")
coordsFrame.Size = UDim2.new(1, -16, 0, 24)
coordsFrame.Position = UDim2.new(0, 8, 0, 28)
coordsFrame.BackgroundTransparency = 1
coordsFrame.Parent = teleportContainer

local function createCoordBox(parent, placeholder, position)
    local box = Instance.new("TextBox")
    box.PlaceholderText = placeholder
    box.Font = Enum.Font.GothamMedium
    box.TextSize = 12
    box.Text = ""
    box.Size = UDim2.new(0, 60, 0, 24)
    box.Position = position
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    box.TextColor3 = Color3.fromRGB(220, 220, 230)
    box.BorderSizePixel = 0
    box.Parent = parent
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = box
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = Color3.fromRGB(60, 60, 70)
    boxStroke.Thickness = 1
    boxStroke.Parent = box
    return box
end

local xBox = createCoordBox(coordsFrame, "X", UDim2.new(0, 0, 0, 0))
local yBox = createCoordBox(coordsFrame, "Y", UDim2.new(0, 68, 0, 0))
local zBox = createCoordBox(coordsFrame, "Z", UDim2.new(0, 136, 0, 0))

local teleportBtn = Instance.new("TextButton")
teleportBtn.Text = "🚀 Teleportar"
teleportBtn.Font = Enum.Font.GothamSemibold
teleportBtn.TextSize = 12
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
teleportBtn.Size = UDim2.new(0, 80, 0, 24)
teleportBtn.Position = UDim2.new(0, 204, 0, 0)
teleportBtn.BorderSizePixel = 0
teleportBtn.Parent = coordsFrame
local teleportBtnCorner = Instance.new("UICorner")
teleportBtnCorner.CornerRadius = UDim.new(0, 4)
teleportBtnCorner.Parent = teleportBtn

teleportBtn.MouseButton1Click:Connect(function()
    local x = tonumber(xBox.Text)
    local y = tonumber(yBox.Text)
    local z = tonumber(zBox.Text)
    if x and y and z then
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
            game.StarterGui:SetCore("SendNotification", {
                Title = "Teleport", 
                Text = "¡Teleportado exitosamente!", 
                Duration = 2
            })
        end
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error", 
            Text = "Coordenadas inválidas", 
            Duration = 2
        })
    end
end)

-- NUEVA PESTAÑA:-- Golems tab
local golemsTab = tabFrames["Golems"]

-- Variables para AutoFire, AutoWater, AutoEarth
local autoFireEnabled = false
local autoFireConn
local autoFireDelay = 0.1

local autoWaterEnabled = false
local autoWaterConn
local autoWaterDelay = 0.1

local autoEarthEnabled = false
local autoEarthConn
local autoEarthDelay = 0.1

-- Función para obtener el RemoteClick del arma actual
local function getRemoteClick()
    local char = Player.Character
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("RemoteClick") then
                return tool.RemoteClick
            end
        end
    end
    return nil
end

-- Función para obtener los objetivos (Fire Golem y Fire Boss)
local function getFireTargets()
    local targets = {}
    local fireZone = workspace:FindFirstChild("Gameplay")
    if fireZone then
        fireZone = fireZone:FindFirstChild("Map")
        if fireZone then
            fireZone = fireZone:FindFirstChild("ElementZones")
            if fireZone then
                fireZone = fireZone:FindFirstChild("Fire")
                if fireZone then
                    fireZone = fireZone:FindFirstChild("Fire")
                    if fireZone then
                        local fireGolem = fireZone:FindFirstChild("Fire Golem")
                        local fireBoss = fireZone:FindFirstChild("Fire Boss")
                        if fireGolem then table.insert(targets, fireGolem) end
                        if fireBoss then table.insert(targets, fireBoss) end
                    end
                end
            end
        end
    end
    return targets
end

-- Función para obtener el Boss normal
local function getBossTarget()
    local targets = {}
    local bossZone = workspace:FindFirstChild("Gameplay")
    if bossZone then
        bossZone = bossZone:FindFirstChild("Map")
        if bossZone then
            bossZone = bossZone:FindFirstChild("ElementZones")
            if bossZone then
                -- Buscar en cada zona elemental
                for _, elementZone in pairs(bossZone:GetChildren()) do
                    local boss = elementZone:FindFirstChild("Boss")
                    if boss then 
                        table.insert(targets, boss)
                    end
                end
            end
        end
    end
    return targets
end

-- Función para obtener los objetivos de agua (Water Golem y Water Boss)
local function getWaterTargets()
    local targets = {}
    local waterZone = workspace:FindFirstChild("Gameplay")
    if waterZone then
        waterZone = waterZone:FindFirstChild("Map")
        if waterZone then
            waterZone = waterZone:FindFirstChild("ElementZones")
            if waterZone then
                waterZone = waterZone:FindFirstChild("Water")
                if waterZone then
                    waterZone = waterZone:FindFirstChild("Water")
                    if waterZone then
                        local waterGolem = waterZone:FindFirstChild("Water Golem")
                        local waterBoss = waterZone:FindFirstChild("Water Boss")
                        if waterGolem then table.insert(targets, waterGolem) end
                        if waterBoss then table.insert(targets, waterBoss) end
                    end
                end
            end
        end
    end
    return targets
end

-- Función para obtener los objetivos de tierra (Earth Golem y Earth Boss)
local function getEarthTargets()
    local targets = {}
    local earthZone = workspace:FindFirstChild("Gameplay")
    if earthZone then
        earthZone = earthZone:FindFirstChild("Map")
        if earthZone then
            earthZone = earthZone:FindFirstChild("ElementZones")
            if earthZone then
                earthZone = earthZone:FindFirstChild("Earth")
                if earthZone then
                    earthZone = earthZone:FindFirstChild("Model")
                    if earthZone then
                        earthZone = earthZone:FindFirstChild("Earth")
                        if earthZone then
                            local earthGolem = earthZone:FindFirstChild("Earth Golem")
                            local earthBoss = earthZone:FindFirstChild("Earth Boss")
                            if earthGolem then table.insert(targets, earthGolem) end
                            if earthBoss then table.insert(targets, earthBoss) end
                        end
                    end
                end
            end
        end
    end
    return targets
end

-- Título de la pestaña Golems
local golemsTitle = Instance.new("TextLabel")
golemsTitle.Text = "🔥 Golems & Bosses"
golemsTitle.Font = Enum.Font.GothamBold
golemsTitle.TextSize = 16
golemsTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
golemsTitle.BackgroundTransparency = 1
golemsTitle.Size = UDim2.new(1, -16, 0, 28)
golemsTitle.LayoutOrder = 1
golemsTitle.TextXAlignment = Enum.TextXAlignment.Center
golemsTitle.Parent = golemsTab

-- Descripción
local golemsDesc = Instance.new("TextLabel")
golemsDesc.Text = "Ataca automáticamente a Fire Golem y Fire Boss"
golemsDesc.Font = Enum.Font.Gotham
golemsDesc.TextSize = 12
golemsDesc.TextColor3 = Color3.fromRGB(180, 180, 190)
golemsDesc.BackgroundTransparency = 1
golemsDesc.Size = UDim2.new(1, -16, 0, 20)
golemsDesc.LayoutOrder = 2
golemsDesc.TextXAlignment = Enum.TextXAlignment.Center
golemsDesc.Parent = golemsTab

-- Switch para AutoFire
createSwitch(golemsTab, "🔥 AutoFire", false, function(enabled)
    autoFireEnabled = enabled
    if autoFireConn then autoFireConn:Disconnect() autoFireConn = nil end
    
    if enabled then
        autoFireConn = RunService.RenderStepped:Connect(function()
            local remoteClick = getRemoteClick()
            local targets = getFireTargets()
            
            if remoteClick and #targets > 0 then
                pcall(function()
                    remoteClick:FireServer(targets)
                end)
            end
            
            task.wait(autoFireDelay)
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "AutoFire", 
            Text = "¡AutoFire activado!", 
            Duration = 2
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "AutoFire", 
            Text = "AutoFire desactivado", 
            Duration = 2
        })
    end
end, 3)

-- Switch para AutoWater
createSwitch(golemsTab, "💧 AutoWater", false, function(enabled)
    autoWaterEnabled = enabled
    if autoWaterConn then autoWaterConn:Disconnect() autoWaterConn = nil end
    
    if enabled then
        autoWaterConn = RunService.RenderStepped:Connect(function()
            local remoteClick = getRemoteClick()
            local targets = getWaterTargets()
            
            if remoteClick and #targets > 0 then
                pcall(function()
                    remoteClick:FireServer(targets)
                end)
            end
            
            task.wait(autoWaterDelay)
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "AutoWater", 
            Text = "¡AutoWater activado!", 
            Duration = 2
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "AutoWater", 
            Text = "AutoWater desactivado", 
            Duration = 2
        })
    end
end, 4)

-- Switch para AutoEarth
createSwitch(golemsTab, "🌍 AutoEarth", false, function(enabled)
    autoEarthEnabled = enabled
    if autoEarthConn then autoEarthConn:Disconnect() autoEarthConn = nil end
    
    if enabled then
        autoEarthConn = RunService.RenderStepped:Connect(function()
            local remoteClick = getRemoteClick()
            local targets = getEarthTargets()
            
            if remoteClick and #targets > 0 then
                pcall(function()
                    remoteClick:FireServer(targets)
                end)
            end
            
            task.wait(autoEarthDelay)
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "AutoEarth", 
            Text = "¡AutoEarth activado!", 
            Duration = 2
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "AutoEarth", 
            Text = "AutoEarth desactivado", 
            Duration = 2
        })
    end
end, 5)

-- Variables para AutoBoss
local autoBossEnabled = false
local autoBossConn
local autoBossDelay = 0.1

-- Switch para AutoBoss (Boss normal)
createSwitch(golemsTab, "👑 AutoBoss", false, function(enabled)
    autoBossEnabled = enabled
    if autoBossConn then autoBossConn:Disconnect() autoBossConn = nil end
    
    if enabled then
        autoBossConn = RunService.RenderStepped:Connect(function()
            local remoteClick = getRemoteClick()
            local targets = getBossTarget()
            
            if remoteClick and #targets > 0 then
                pcall(function()
                    remoteClick:FireServer(targets)
                end)
            end
            
            task.wait(autoBossDelay)
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "AutoBoss", 
            Text = "¡AutoBoss activado!", 
            Duration = 2
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "AutoBoss", 
            Text = "AutoBoss desactivado", 
            Duration = 2
        })
    end
end, 6)

-- Slider para velocidad de ataque
createSlider(golemsTab, "⚡ Velocidad de Ataque", 0.01, 1.0, 0.1, function(val)
    autoFireDelay = val
    autoWaterDelay = val
    autoEarthDelay = val
    autoBossDelay = val
end, 7)

-- Panel de información
local infoPanel = Instance.new("Frame")
infoPanel.Name = "InfoPanel"
infoPanel.Size = UDim2.new(1, -16, 0, 100)
infoPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
infoPanel.BorderSizePixel = 0
infoPanel.LayoutOrder = 5
infoPanel.Parent = golemsTab
local infoPanelCorner = Instance.new("UICorner")
infoPanelCorner.CornerRadius = UDim.new(0, 6)
infoPanelCorner.Parent = infoPanel
local infoPanelStroke = Instance.new("UIStroke")
infoPanelStroke.Color = Color3.fromRGB(55, 55, 60)
infoPanelStroke.Thickness = 1
infoPanelStroke.Parent = infoPanel

local infoText = Instance.new("TextLabel")
infoText.Text = "ℹ️ Información:\n• Asegúrate de tener un arma equipada\n• Las funciones Auto atacarán automáticamente a:\n  - Fire Golem/Boss\n  - Water Golem/Boss\n  - Earth Golem/Boss\n  - Boss Normal\n• Ajusta la velocidad según sea necesario"
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 11
infoText.TextColor3 = Color3.fromRGB(180, 180, 190)
infoText.BackgroundTransparency = 1
infoText.Size = UDim2.new(1, -16, 1, -16)
infoText.Position = UDim2.new(0, 8, 0, 8)
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Parent = infoPanel

-- Settings tab
local settingsTab = tabFrames["Settings"]

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Text = "⚙️ Configuración de la GUI"
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 14
settingsTitle.TextColor3 = Color3.fromRGB(100, 150, 255)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Size = UDim2.new(1, -16, 0, 24)
settingsTitle.LayoutOrder = 1
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Parent = settingsTab

-- Info panel
local settingsInfoPanel = Instance.new("Frame")
settingsInfoPanel.Name = "InfoPanel"
settingsInfoPanel.Size = UDim2.new(1, -16, 0, 80)
settingsInfoPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
settingsInfoPanel.BorderSizePixel = 0
settingsInfoPanel.LayoutOrder = 2
settingsInfoPanel.Parent = settingsTab
local settingsInfoPanelCorner = Instance.new("UICorner")
settingsInfoPanelCorner.CornerRadius = UDim.new(0, 6)
settingsInfoPanelCorner.Parent = settingsInfoPanel
local settingsInfoPanelStroke = Instance.new("UIStroke")
settingsInfoPanelStroke.Color = Color3.fromRGB(55, 55, 60)
settingsInfoPanelStroke.Thickness = 1
settingsInfoPanelStroke.Parent = settingsInfoPanel

local settingsInfoText = Instance.new("TextLabel")
settingsInfoText.Text = "🎮 Controles:\n• INSERT: Mostrar/Ocultar GUI\n• Arrastra la barra superior para mover\n• Usa el botón de minimizar (-) para contraer"
settingsInfoText.Font = Enum.Font.Gotham
settingsInfoText.TextSize = 11
settingsInfoText.TextColor3 = Color3.fromRGB(180, 180, 190)
settingsInfoText.BackgroundTransparency = 1
settingsInfoText.Size = UDim2.new(1, -16, 1, -16)
settingsInfoText.Position = UDim2.new(0, 8, 0, 8)
settingsInfoText.TextXAlignment = Enum.TextXAlignment.Left
settingsInfoText.TextYAlignment = Enum.TextYAlignment.Top
settingsInfoText.Parent = settingsInfoPanel

-- Sistema de persistencia mejorado
local retenerEnabled = false
local retenerFile = "SaberGUI_Settings_"..game.PlaceId..".json"

local function saveSettings()
    if not retenerEnabled then return end
    local settings = {
        retener = retenerEnabled,
        autoSwing = autoSwing,
        autoSell = autoSell,
        autoCollect = autoCollect,
        afkFarm = afkFarmEnabled,
        antiAfk = antiAfkEnabled,
        noclip = noclipEnabled,
        infJump = infJumpEnabled,
        walkspeed = walkspeed,
        autoSwingDelay = autoSwingDelay,
        autoFire = autoFireEnabled,
        autoFireDelay = autoFireDelay,
        autoWater = autoWaterEnabled,
        autoWaterDelay = autoWaterDelay,
        autoEarth = autoEarthEnabled,
        autoEarthDelay = autoEarthDelay,
        autoCollectAll = autoCollectAllEnabled,
        autoShopWeapons = autoShopWeaponsEnabled,
        autoShopDNAs = autoShopDNAsEnabled,
        autoClassUp = autoClassUpEnabled
    }
    if writefile then
        pcall(function()
            writefile(retenerFile, game:GetService("HttpService"):JSONEncode(settings))
        end)
    end
end

local function loadSettings()
    if readfile and isfile and isfile(retenerFile) then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(retenerFile))
        end)
        if success and data and data.retener then
            retenerEnabled = true
            -- Aplicar configuraciones guardadas aquí
            if data.walkspeed then walkspeed = data.walkspeed end
            if data.autoSwingDelay then autoSwingDelay = data.autoSwingDelay end
            if data.autoFireDelay then autoFireDelay = data.autoFireDelay end
            if data.autoWaterDelay then autoWaterDelay = data.autoWaterDelay end
            if data.autoEarthDelay then autoEarthDelay = data.autoEarthDelay end
            
            -- Cargar estados de los switches
            if data.autoSwing ~= nil then
                autoSwing = data.autoSwing
                if autoSwing and SwingSaber then
                    if autoSwingConn then autoSwingConn:Disconnect() end
                    autoSwingConn = RunService.RenderStepped:Connect(function()
                        pcall(function() SwingSaber:FireServer() end)
                        task.wait(autoSwingDelay)
                    end)
                end
            end
            
            if data.autoSell ~= nil then
                autoSell = data.autoSell
                if autoSell and SellStrength then
                    if autoSellConn then autoSellConn:Disconnect() end
                    autoSellConn = RunService.RenderStepped:Connect(function()
                        pcall(function() SellStrength:FireServer() end)
                        task.wait(0.1)
                    end)
                end
            end
            
            if data.autoCollect ~= nil then
                autoCollect = data.autoCollect
                if autoCollect and CollectCurrencyPickup then
                    if autoCollectConn then autoCollectConn:Disconnect() end
                    autoCollectConn = RunService.RenderStepped:Connect(function()
                        pcall(function() CollectCurrencyPickup:FireServer() end)
                        task.wait(0.1)
                    end)
                end
            end
            
            if data.autoFire ~= nil then
                autoFireEnabled = data.autoFire
                if autoFireEnabled then
                    if autoFireConn then autoFireConn:Disconnect() end
                    autoFireConn = RunService.RenderStepped:Connect(function()
                        local remoteClick = getRemoteClick()
                        local targets = getFireTargets()
                        if remoteClick and #targets > 0 then
                            pcall(function() remoteClick:FireServer(targets) end)
                        end
                        task.wait(autoFireDelay)
                    end)
                end
            end
            
            if data.autoWater ~= nil then
                autoWaterEnabled = data.autoWater
                if autoWaterEnabled then
                    if autoWaterConn then autoWaterConn:Disconnect() end
                    autoWaterConn = RunService.RenderStepped:Connect(function()
                        local remoteClick = getRemoteClick()
                        local targets = getWaterTargets()
                        if remoteClick and #targets > 0 then
                            pcall(function() remoteClick:FireServer(targets) end)
                        end
                        task.wait(autoWaterDelay)
                    end)
                end
            end
            
            if data.autoEarth ~= nil then
                autoEarthEnabled = data.autoEarth
                if autoEarthEnabled then
                    if autoEarthConn then autoEarthConn:Disconnect() end
                    autoEarthConn = RunService.RenderStepped:Connect(function()
                        local remoteClick = getRemoteClick()
                        local targets = getEarthTargets()
                        if remoteClick and #targets > 0 then
                            pcall(function() remoteClick:FireServer(targets) end)
                        end
                        task.wait(autoEarthDelay)
                    end)
                end
            end
            
            if data.autoCollectAll ~= nil then
                autoCollectAllEnabled = data.autoCollectAll
                if autoCollectAllEnabled then
                    if autoCollectAllConn then autoCollectAllConn:Disconnect() end
                    autoCollectAllConn = RunService.RenderStepped:Connect(function()
                        collectAll()
                        task.wait(1)
                    end)
                end
            end
            
            if data.autoShopWeapons ~= nil then
                autoShopWeaponsEnabled = data.autoShopWeapons
                if autoShopWeaponsEnabled and UIAction then
                    if autoShopWeaponsConn then autoShopWeaponsConn:Disconnect() end
                    autoShopWeaponsConn = RunService.RenderStepped:Connect(function()
                        pcall(function() UIAction:FireServer("BuyAllWeapons") end)
                        task.wait(5)
                    end)
                end
            end
            
            if data.autoShopDNAs ~= nil then
                autoShopDNAsEnabled = data.autoShopDNAs
                if autoShopDNAsEnabled and UIAction then
                    if autoShopDNAsConn then autoShopDNAsConn:Disconnect() end
                    autoShopDNAsConn = RunService.RenderStepped:Connect(function()
                        pcall(function() UIAction:FireServer("BuyAllDNAs") end)
                        task.wait(5)
                    end)
                end
            end
            
            if data.autoClassUp ~= nil then
                autoClassUpEnabled = data.autoClassUp
                if autoClassUpEnabled and UIAction then
                    if autoClassUpConn then autoClassUpConn:Disconnect() end
                    autoClassUpConn = RunService.RenderStepped:Connect(function()
                        buyNextClass()
                        task.wait(5)
                    end)
                end
            end
        end
    end
end

createSwitch(settingsTab, "💾 Guardar Configuración", false, function(enabled)
    retenerEnabled = enabled
    if enabled then
        saveSettings()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Configuración", 
            Text = "¡Configuración guardada!", 
            Duration = 2
        })
    else
        if delfile and isfile and isfile(retenerFile) then
            pcall(function() delfile(retenerFile) end)
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "Configuración", 
            Text = "Configuración eliminada", 
            Duration = 2
        })
    end
end, 3)

-- Información de la GUI
local aboutPanel = Instance.new("Frame")
aboutPanel.Name = "AboutPanel"
aboutPanel.Size = UDim2.new(1, -16, 0, 60)
aboutPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
aboutPanel.BorderSizePixel = 0
aboutPanel.LayoutOrder = 4
aboutPanel.Parent = settingsTab
local aboutPanelCorner = Instance.new("UICorner")
aboutPanelCorner.CornerRadius = UDim.new(0, 6)
aboutPanelCorner.Parent = aboutPanel
local aboutPanelStroke = Instance.new("UIStroke")
aboutPanelStroke.Color = Color3.fromRGB(55, 55, 60)
aboutPanelStroke.Thickness = 1
aboutPanelStroke.Parent = aboutPanel

local aboutText = Instance.new("TextLabel")
aboutText.Text = "✨ Saber Simulator GUI v2.0\n🔧 GUI moderna con switches y animaciones\n💡 Creado para una mejor experiencia de usuario"
aboutText.Font = Enum.Font.Gotham
aboutText.TextSize = 11
aboutText.TextColor3 = Color3.fromRGB(160, 180, 220)
aboutText.BackgroundTransparency = 1
aboutText.Size = UDim2.new(1, -16, 1, -16)
aboutText.Position = UDim2.new(0, 8, 0, 8)
aboutText.TextXAlignment = Enum.TextXAlignment.Left
aboutText.TextYAlignment = Enum.TextYAlignment.Top
aboutText.Parent = aboutPanel

-- Actualizar el tamaño del contenido de cada tab
for _, tabFrame in pairs(tabFrames) do
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabFrame.UIListLayout.AbsoluteContentSize.Y + 16)
    end)
end

-- Eventos de cierre y persistencia
local function onClose()
    if retenerEnabled then
        saveSettings()
    end
end

game:BindToClose(onClose)

-- Auto-ejecutar en teleport (si tienes EvolutionX-net8)
if syn and syn.queue_on_teleport then
    syn.queue_on_teleport([[
        -- Aquí puedes poner la URL de tu script para auto-ejecutar
        loadstring(game:HttpGet('URL_DE_TU_SCRIPT'))()
    ]])
end

-- Cargar configuración al iniciar
spawn(function()
    task.wait(2)
    loadSettings()
end)

-- Mantener velocidad de caminar al respawn
Player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").WalkSpeed = walkspeed
end)

-- Esta función ha sido reemplazada por el botón Sell All implementado arriba
-- Variables para Auto Collect All
local autoCollectAllEnabled = false
local autoCollectAllConn

local function collectAll()
    -- Método 1: Usando CollectCurrencyPickup
    if CollectCurrencyPickup then
        pcall(function() CollectCurrencyPickup:FireServer({"Crown"}) end)
    end
    
    -- Método 2: Usando ClientNotifierEvent
    local ClientNotifierEvent = ReplicatedStorage.Events.ClientNotifierEvent
    if ClientNotifierEvent then
        pcall(function() firesignal(ClientNotifierEvent.OnClientEvent, "GainedCrowns", 105402676666061) end)
    end
    
    statusLabel.Text = "✅ Collect All ejecutado."
end

-- Botón para Collect All una vez
local collectAllBtn = createButton(tabFrames["Auto"], "Collect All (Una vez)", collectAll, 3)

-- Switch para Auto Collect All (bucle)
createSwitch(tabFrames["Auto"], "🔄 Auto Collect All", false, function(enabled)
    autoCollectAllEnabled = enabled
    if autoCollectAllConn then autoCollectAllConn:Disconnect() autoCollectAllConn = nil end
    
    if enabled then
        autoCollectAllConn = RunService.RenderStepped:Connect(function()
            collectAll()
            task.wait(1) -- Esperar 1 segundo entre cada colecta
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Collect All", 
            Text = "¡Auto Collect All activado!", 
            Duration = 2
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Collect All", 
            Text = "Auto Collect All desactivado", 
            Duration = 2
        })
    end
end, 7)
local function getRemoteClick()
    local char = Player.Character or Player.CharacterAdded:Wait()
    -- Primero buscar específicamente el DeathSpeakerRod
    if char:FindFirstChild("DeathSpeakerRod") and char.DeathSpeakerRod:FindFirstChild("RemoteClick") then
        return char.DeathSpeakerRod.RemoteClick
    end
    -- Si no se encuentra, buscar en cualquier herramienta
    return char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):FindFirstChild("RemoteClick")
end
local function fireAt(target)
    local remote = getRemoteClick()
    if remote and target then
        -- Atacar directamente al objetivo sin verificaciones adicionales
        remote:FireServer({target})
        return true
    end
    return false
end

-- Función para obtener el Boss específico
local function getSpecificBossTarget()
    -- Intentar encontrar el boss principal
    local boss = workspace:FindFirstChild("Gameplay") and 
                workspace.Gameplay:FindFirstChild("Boss") and 
                workspace.Gameplay.Boss:FindFirstChild("BossHolder") and 
                workspace.Gameplay.Boss.BossHolder:FindFirstChild("Boss")
    
    if boss then
        -- Si el boss es un modelo, intentar encontrar su parte principal
        if boss:IsA("Model") and boss:FindFirstChildOfClass("BasePart") then
            return boss:FindFirstChildOfClass("BasePart")
        end
        return boss
    end
    
    -- Buscar bosses elementales si no se encuentra el boss principal
    local elementalBosses = {
        workspace:FindFirstChild("Gameplay") and 
        workspace.Gameplay:FindFirstChild("Map") and 
        workspace.Gameplay.Map:FindFirstChild("ElementZones") and 
        workspace.Gameplay.Map.ElementZones:FindFirstChild("Water") and 
        workspace.Gameplay.Map.ElementZones.Water:FindFirstChild("Water") and 
        workspace.Gameplay.Map.ElementZones.Water.Water:FindFirstChild("Water Boss"),
        
        workspace:FindFirstChild("Gameplay") and 
        workspace.Gameplay:FindFirstChild("Map") and 
        workspace.Gameplay.Map:FindFirstChild("ElementZones") and 
        workspace.Gameplay.Map.ElementZones:FindFirstChild("Fire") and 
        workspace.Gameplay.Map.ElementZones.Fire:FindFirstChild("Fire") and 
        workspace.Gameplay.Map.ElementZones.Fire.Fire:FindFirstChild("Fire Boss"),
        
        workspace:FindFirstChild("Gameplay") and 
        workspace.Gameplay:FindFirstChild("Map") and 
        workspace.Gameplay.Map:FindFirstChild("ElementZones") and 
        workspace.Gameplay.Map.ElementZones:FindFirstChild("Earth") and 
        workspace.Gameplay.Map.ElementZones.Earth:FindFirstChild("Model") and 
        workspace.Gameplay.Map.ElementZones.Earth.Model:FindFirstChild("Earth") and 
        workspace.Gameplay.Map.ElementZones.Earth.Model.Earth:FindFirstChild("Earth Boss")
    }
    
    -- Devolver el primer boss elemental encontrado
    for _, elementalBoss in ipairs(elementalBosses) do
        if elementalBoss then
            return elementalBoss
        end
    end
    
    return nil
end
-- Función para atacar al boss múltiples veces en un solo ciclo
local function attackBossMultipleTimes(times)
    -- Buscar el Boss de manera segura
    local boss = workspace:FindFirstChild("Gameplay") and 
                workspace.Gameplay:FindFirstChild("Boss") and 
                workspace.Gameplay.Boss:FindFirstChild("BossHolder") and 
                workspace.Gameplay.Boss.BossHolder:FindFirstChild("Boss")
    
    if not boss then return false end
    
    -- Obtener directamente el RemoteClick del arma
    local char = Player.Character
    if char then
        local remoteClick = char:FindFirstChild("DeathSpeakerRod") and char.DeathSpeakerRod:FindFirstChild("RemoteClick")
        if not remoteClick then
            remoteClick = char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):FindFirstChild("RemoteClick")
        end
        
        if remoteClick then
            -- Atacar al boss múltiples veces
            for i = 1, times do
                remoteClick:FireServer({boss})
            end
            return true
        end
    end
    return false
end

-- Variable para el delay del Auto Boss
local autoBossDelay = 0.5 -- Valor predeterminado: 0.5 segundos

local function autoBoss(enabled)
    if enabled then
        local lastAttackTime = 0
        autoBossConn = RunService.Heartbeat:Connect(function()
            local currentTime = os.clock()
            if currentTime - lastAttackTime >= autoBossDelay then
                lastAttackTime = currentTime
                statusLabel.Text = "Updating.."
                statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
                -- Atacar al boss 10 veces cada ciclo
                if attackBossMultipleTimes(10) then
                    statusLabel.Text = "⚔️ Atacando a: Boss (x10) | Delay: " .. autoBossDelay .. "s"
                    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    statusLabel.Text = "❌ No se encontró el arma o el boss"
                    statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Boss", 
            Text = "¡Auto Boss activado! (x10 golpes, delay: " .. autoBossDelay .. "s)", 
            Duration = 2
        })
    elseif autoBossConn then
        autoBossConn:Disconnect()
        autoBossConn = nil
        statusLabel.Text = "Auto Boss desactivado"
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Boss", 
            Text = "Auto Boss desactivado", 
            Duration = 2
        })
    end
end

-- Slider para ajustar el delay del Auto Boss
createSlider(tabFrames["Golems"], "Auto Boss Delay", 0.1, 2.0, autoBossDelay, function(value)
    autoBossDelay = value
    statusLabel.Text = "⚙️ Auto Boss Delay: " .. autoBossDelay .. "s"
    
    -- Si Auto Boss está activo, actualizar la notificación
    if autoBossConn then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Boss", 
            Text = "Delay actualizado: " .. autoBossDelay .. "s", 
            Duration = 1
        })
    end
end, 4)
-- Función para atacar al Fire Boss múltiples veces
local function attackFireBossMultipleTimes(times)
    -- Buscar el Fire Boss de manera segura
    local fireBoss = workspace:FindFirstChild("Gameplay") and 
                    workspace.Gameplay:FindFirstChild("Map") and 
                    workspace.Gameplay.Map:FindFirstChild("ElementZones") and 
                    workspace.Gameplay.Map.ElementZones:FindFirstChild("Fire") and 
                    workspace.Gameplay.Map.ElementZones.Fire:FindFirstChild("Fire") and 
                    workspace.Gameplay.Map.ElementZones.Fire.Fire:FindFirstChild("Fire Boss")
    
    if not fireBoss then return false end
    
    -- Obtener directamente el RemoteClick del arma
    local char = Player.Character
    if char then
        local remoteClick = char:FindFirstChild("DeathSpeakerRod") and char.DeathSpeakerRod:FindFirstChild("RemoteClick")
        if not remoteClick then
            remoteClick = char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):FindFirstChild("RemoteClick")
        end
        
        if remoteClick then
            -- Atacar al Fire Boss múltiples veces
            for i = 1, times do
                remoteClick:FireServer({fireBoss})
            end
            return true
        end
    end
    return false
end

-- Variable para el delay del Auto Fire Boss
local autoFireBossDelay = 0.5 -- Valor predeterminado: 0.5 segundos

local function autoFireBoss(enabled)
    if enabled then
        local lastAttackTime = 0
        autoFireBossConn = RunService.Heartbeat:Connect(function()
            local currentTime = os.clock()
            if currentTime - lastAttackTime >= autoFireBossDelay then
                lastAttackTime = currentTime
                statusLabel.Text = "Updating.."
                statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
                -- Atacar al Fire Boss 10 veces cada ciclo
                if attackFireBossMultipleTimes(10) then
                    statusLabel.Text = "🔥 Atacando a: Fire Boss (x10) | Delay: " .. autoFireBossDelay .. "s"
                    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    statusLabel.Text = "🔍 Buscando Fire Boss..."
                    statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
                end
            end
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Fire Boss", 
            Text = "¡Auto Fire Boss activado! (x10 golpes, delay: " .. autoFireBossDelay .. "s)", 
            Duration = 2
        })
    elseif autoFireBossConn then
        autoFireBossConn:Disconnect()
        autoFireBossConn = nil
        statusLabel.Text = "Auto Fire Boss desactivado"
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Fire Boss", 
            Text = "Auto Fire Boss desactivado", 
            Duration = 2
        })
    end
end

-- Slider para ajustar el delay del Auto Fire Boss
createSlider(tabFrames["Golems"], "Auto Fire Boss Delay", 0.1, 2.0, autoFireBossDelay, function(value)
    autoFireBossDelay = value
    statusLabel.Text = "⚙️ Auto Fire Boss Delay: " .. autoFireBossDelay .. "s"
    
    -- Si Auto Fire Boss está activo, actualizar la notificación
    if autoFireBossConn then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Fire Boss", 
            Text = "Delay actualizado: " .. autoFireBossDelay .. "s", 
            Duration = 1
        })
    end
end, 5)
-- Botón para atacar al boss una vez (10 golpes)
createButton(tabFrames["Golems"], "⚔️ Atacar Boss (10x)", function()
    if attackBossMultipleTimes(10) then
        statusLabel.Text = "✅ Boss atacado 10 veces"
        game.StarterGui:SetCore("SendNotification", {
            Title = "Ataque al Boss", 
            Text = "¡Boss atacado 10 veces!", 
            Duration = 2
        })
    else
        statusLabel.Text = "❌ No se encontró el arma o el boss"
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error", 
            Text = "No se pudo atacar al boss", 
            Duration = 2
        })
    end
end, 1)

-- Botón para atacar al Fire Boss una vez (10 golpes)
createButton(tabFrames["Golems"], "🔥 Atacar Fire Boss (10x)", function()
    if attackFireBossMultipleTimes(10) then
        statusLabel.Text = "✅ Fire Boss atacado 10 veces"
        game.StarterGui:SetCore("SendNotification", {
            Title = "Ataque al Fire Boss", 
            Text = "¡Fire Boss atacado 10 veces!", 
            Duration = 2
        })
    else
        statusLabel.Text = "❌ No se encontró el arma o el Fire Boss"
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error", 
            Text = "No se pudo atacar al Fire Boss", 
            Duration = 2
        })
    end
end, 2)

local _, _, setAutoBoss = createSwitch(tabFrames["Golems"], "Auto Boss", false, autoBoss, 2)
local _, _, setAutoFireBoss = createSwitch(tabFrames["Golems"], "Auto Fire Boss", false, autoFireBoss, 3)
local function walkSpeedCallback(val)
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end
end
createSlider(tabFrames["Player"], "WalkSpeed", 16, 100, 16, walkSpeedCallback, 1)

-- Servicios de Roblox
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local Player

-- Configuración global
local config = {
    version = "v2.0",
    autoSwing = false,
    autoSell = false,
    autoCollect = false,
    autoBoss = false,
    autoFireBoss = false,
    walkSpeed = 16,
    saveEnabled = false
}

-- Función para encontrar remotes de forma segura
local function findRemote(name)
    local remote = ReplicatedStorage:WaitForChild(name, 10) -- espera hasta 10 segundos
    if not remote then
        warn("[EvolutionX] No se pudo encontrar el remote: " .. name)
        return nil
    end
    return remote
end

-- Funciones de auto-farm y verificación de compatibilidad con Velocity
local function safeFireServer(remote, ...)
    if not remote then return end
    local args = {...}
    local success, err = pcall(function()
        remote:FireServer(unpack(args))
    end)
    if not success then
        warn("[EvolutionX] Error al ejecutar remote: " .. tostring(err))
    end
end

-- Inicialización segura para EvolutionX
local function initializeGUI()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    -- Verificar compatibilidad con EvolutionX-net8
    if not getgenv or not syn then
        warn("[EvolutionX] Este script requiere EvolutionX-net8")
        return
    end
    
    -- Esperar al jugador
    if not Players.LocalPlayer then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    end
    Player = Players.LocalPlayer
    
    -- Buscar remotes necesarios
    local SwingSaber = findRemote("SwingSaber")
    local SellStrength = findRemote("SellStrength")
    local CollectCurrencyPickup = findRemote("CollectCurrencyPickup")
    local UIAction = findRemote("UIAction")
    
    if not (SwingSaber and SellStrength and CollectCurrencyPickup and UIAction) then
        warn("[EvolutionX] No se pudieron encontrar todos los remotes necesarios")
        return
    end
    
    -- Configurar parent de la GUI
    local guiParent = nil
    pcall(function()
        guiParent = game:GetService("CoreGui")
    end)
    if not guiParent then
        guiParent = Player:WaitForChild("PlayerGui")
    end
    
    -- Eliminar GUI previa si existe
    local old = guiParent:FindFirstChild("SaberSimulatorGUI")
    if old then old:Destroy() end
    
    -- Crear ScreenGui con protección
    local gui = Instance.new("ScreenGui")
    gui.Name = "SaberSimulatorGUI"
    gui.ResetOnSpawn = false
    
    -- Protección contra errores de EvolutionX-net8
    local success, err = pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        end
        gui.Parent = guiParent
    end)
    
    if not success then
        warn("[EvolutionX] Error al crear GUI: " .. tostring(err))
        return
    end
    
    -- Crear main frame
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 500, 0, 350)
    main.Position = UDim2.new(0.5, -250, 0.5, -175)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.BorderSizePixel = 0
    main.Parent = gui
    
    -- Implementar funcionalidades con los remotes encontrados
    RunService.RenderStepped:Connect(function()
        if config.autoSwing then
            SwingSaber:FireServer()
        end
        if config.autoSell then
            SellStrength:FireServer()
        end
        if config.autoCollect then
            CollectCurrencyPickup:FireServer()
        end
    end)
    
    -- Notificar éxito
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "EvolutionX",
        Text = "GUI cargada exitosamente",
        Duration = 3
    })
end

-- Iniciar GUI de forma segura
pcall(initializeGUI)
