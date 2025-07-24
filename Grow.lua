--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Remotes
local placeBlock = ReplicatedStorage["events-shared/network@GlobalEvents"]:WaitForChild("placeBlock")
local spin = ReplicatedStorage["functions-shared/network@GlobalFunctions"]:WaitForChild("s:spin")
local openEgg = ReplicatedStorage["functions-shared/network@GlobalFunctions"]:WaitForChild("s:openEgg")

local eggOptions = {
    {id = 0, name = "Grass Egg"},
    {id = 3, name = "Stone Egg"},
    {id = 0, name = "Cactus Egg"},
    {id = 0, name = "Sandstone Egg"},
    {id = 0, name = "Snowman Egg"},
    {id = 0, name = "Ice Egg"}
}

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoToolsTabsGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false -- Iniciamos desactivado para toggle con Insert

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 250) -- reducido de 300 a 250
Frame.Position = UDim2.new(0.5, -200, 0.5, -125) -- reajustado centrado
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)

-- Tabs Container
local tabsFrame = Instance.new("Frame", Frame)
tabsFrame.Size = UDim2.new(0, 400, 0, 35)
tabsFrame.Position = UDim2.new(0, 0, 0, 0)
tabsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabsFrame.BorderSizePixel = 0

local function createTabButton(name, posX)
    local btn = Instance.new("TextButton", tabsFrame)
    btn.Size = UDim2.new(0, 133, 1, 0)
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = name
    return btn
end

local placeTabBtn = createTabButton("Auto PlaceBlock", 0)
local spinTabBtn = createTabButton("Auto Spin", 133)
local eggTabBtn = createTabButton("Auto Open Egg", 266)
local claimTabBtn = createTabButton("Auto Claim", 399) -- Ajusta tamaño si es necesario

-- Panels Container
local panels = {}

local function createPanel()
    local pnl = Instance.new("Frame", Frame)
    pnl.Size = UDim2.new(1, 0, 1, -35)
    pnl.Position = UDim2.new(0, 0, 0, 35)
    pnl.BackgroundTransparency = 1
    pnl.Visible = false
    return pnl
end

-- === Panel Auto PlaceBlock ===
local placePanel = createPanel()
panels["place"] = placePanel

local placeLabel = Instance.new("TextLabel", placePanel)
placeLabel.Text = "Auto PlaceBlock"
placeLabel.Size = UDim2.new(0, 380, 0, 30)
placeLabel.Position = UDim2.new(0, 10, 0, 10)
placeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
placeLabel.BackgroundTransparency = 1
placeLabel.Font = Enum.Font.SourceSansBold
placeLabel.TextSize = 24
placeLabel.TextXAlignment = Enum.TextXAlignment.Left

local placeToggle = Instance.new("TextButton", placePanel)
placeToggle.Size = UDim2.new(0, 380, 0, 45)
placeToggle.Position = UDim2.new(0, 10, 0, 50)
placeToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
placeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
placeToggle.Font = Enum.Font.SourceSansBold
placeToggle.TextSize = 20
placeToggle.Text = "▶️ Activar AutoPlace"

local placeDelayBox = Instance.new("TextBox", placePanel)
placeDelayBox.Size = UDim2.new(0, 380, 0, 45)
placeDelayBox.Position = UDim2.new(0, 10, 0, 105)
placeDelayBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
placeDelayBox.TextColor3 = Color3.fromRGB(0, 255, 0)
placeDelayBox.Font = Enum.Font.Code
placeDelayBox.TextSize = 20
placeDelayBox.PlaceholderText = "Delay en ms (ej: 100)"
placeDelayBox.Text = ""

-- === Panel Auto Spin ===
local spinPanel = createPanel()
panels["spin"] = spinPanel

local spinLabel = Instance.new("TextLabel", spinPanel)
spinLabel.Text = "Auto Spin"
spinLabel.Size = UDim2.new(0, 380, 0, 30)
spinLabel.Position = UDim2.new(0, 10, 0, 10)
spinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
spinLabel.BackgroundTransparency = 1
spinLabel.Font = Enum.Font.SourceSansBold
spinLabel.TextSize = 24
spinLabel.TextXAlignment = Enum.TextXAlignment.Left

local spinIdLabel = Instance.new("TextLabel", spinPanel)
spinIdLabel.Text = "ID del Spin:"
spinIdLabel.Size = UDim2.new(0, 100, 0, 30)
spinIdLabel.Position = UDim2.new(0, 10, 0, 55)
spinIdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
spinIdLabel.BackgroundTransparency = 1
spinIdLabel.Font = Enum.Font.SourceSansBold
spinIdLabel.TextSize = 18
spinIdLabel.TextXAlignment = Enum.TextXAlignment.Left

local spinIdBox = Instance.new("TextBox", spinPanel)
spinIdBox.Size = UDim2.new(0, 260, 0, 30)
spinIdBox.Position = UDim2.new(0, 120, 0, 55)
spinIdBox.PlaceholderText = "11"
spinIdBox.Text = "11"
spinIdBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
spinIdBox.TextColor3 = Color3.fromRGB(0, 255, 0)
spinIdBox.Font = Enum.Font.Code
spinIdBox.TextSize = 18
spinIdBox.ClearTextOnFocus = false

local spinDelayLabel = Instance.new("TextLabel", spinPanel)
spinDelayLabel.Text = "Delay (ms):"
spinDelayLabel.Size = UDim2.new(0, 100, 0, 30)
spinDelayLabel.Position = UDim2.new(0, 10, 0, 95)
spinDelayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
spinDelayLabel.BackgroundTransparency = 1
spinDelayLabel.Font = Enum.Font.SourceSansBold
spinDelayLabel.TextSize = 18
spinDelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local spinDelayBox = Instance.new("TextBox", spinPanel)
spinDelayBox.Size = UDim2.new(0, 260, 0, 30)
spinDelayBox.Position = UDim2.new(0, 120, 0, 95)
spinDelayBox.PlaceholderText = "100"
spinDelayBox.Text = "100"
spinDelayBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
spinDelayBox.TextColor3 = Color3.fromRGB(0, 255, 0)
spinDelayBox.Font = Enum.Font.Code
spinDelayBox.TextSize = 18
spinDelayBox.ClearTextOnFocus = false

local spinToggle = Instance.new("TextButton", spinPanel)
spinToggle.Size = UDim2.new(0, 370, 0, 45)
spinToggle.Position = UDim2.new(0, 10, 0, 140)
spinToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
spinToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
spinToggle.Font = Enum.Font.SourceSansBold
spinToggle.TextSize = 20
spinToggle.Text = "▶️ Iniciar Auto Spin"

-- === Panel Auto Open Egg ===
local eggPanel = createPanel()
panels["egg"] = eggPanel

local eggTitleLabel = Instance.new("TextLabel", eggPanel)
eggTitleLabel.Text = "Auto Open Egg"
eggTitleLabel.Size = UDim2.new(0, 380, 0, 30)
eggTitleLabel.Position = UDim2.new(0, 10, 0, 10)
eggTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
eggTitleLabel.BackgroundTransparency = 1
eggTitleLabel.Font = Enum.Font.SourceSansBold
eggTitleLabel.TextSize = 24
eggTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local comboLabel = Instance.new("TextLabel", eggPanel)
comboLabel.Text = "Selecciona el huevo:"
comboLabel.Size = UDim2.new(0, 150, 0, 25)
comboLabel.Position = UDim2.new(0, 10, 0, 45) -- subido un poco para comprimir espacio
comboLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
comboLabel.BackgroundTransparency = 1
comboLabel.Font = Enum.Font.SourceSansBold
comboLabel.TextSize = 18
comboLabel.TextXAlignment = Enum.TextXAlignment.Left

local dropdownFrame = Instance.new("Frame", eggPanel)
dropdownFrame.Size = UDim2.new(0, 180, 0, 25) -- reducido alto a 25
dropdownFrame.Position = UDim2.new(0, 170, 0, 45)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
dropdownFrame.BorderSizePixel = 0

local dropdownText = Instance.new("TextLabel", dropdownFrame)
dropdownText.Size = UDim2.new(1, -20, 1, 0)
dropdownText.Position = UDim2.new(0, 10, 0, 0)
dropdownText.Text = eggOptions[1].name
dropdownText.TextColor3 = Color3.fromRGB(0, 255, 0)
dropdownText.Font = Enum.Font.Code
dropdownText.TextSize = 18
dropdownText.TextXAlignment = Enum.TextXAlignment.Left
dropdownText.BackgroundTransparency = 1

local dropdownButton = Instance.new("TextButton", dropdownFrame)
dropdownButton.Size = UDim2.new(0, 30, 1, 0)
dropdownButton.Position = UDim2.new(1, -30, 0, 0)
dropdownButton.Text = "▼"
dropdownButton.Font = Enum.Font.SourceSansBold
dropdownButton.TextSize = 20
dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
dropdownButton.BorderSizePixel = 0

local dropdownList = Instance.new("Frame", ScreenGui)
dropdownList.ZIndex = 10
dropdownList.Visible = false
dropdownList.Size = UDim2.new(0, 180, 0, #eggOptions * 25)
dropdownList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
dropdownList.BorderSizePixel = 0

local UIListLayout = Instance.new("UIListLayout", dropdownList)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

for i, egg in ipairs(eggOptions) do
    local option = Instance.new("TextButton", dropdownList)
    option.Size = UDim2.new(1, 0, 0, 25)
    option.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    option.TextColor3 = Color3.fromRGB(0, 255, 0)
    option.Font = Enum.Font.Code
    option.TextSize = 18
    option.Text = egg.name
    option.BorderSizePixel = 0

    option.MouseButton1Click:Connect(function()
        dropdownText.Text = egg.name
        dropdownList.Visible = false
    end)
end

dropdownButton.MouseButton1Click:Connect(function()
    dropdownList.Visible = not dropdownList.Visible
    if dropdownList.Visible then
        updateDropdownPosition()
    end
end)
local animCheckbox = Instance.new("TextButton", eggPanel)
animCheckbox.Size = UDim2.new(0, 25, 0, 25) -- reducido un poco
animCheckbox.ZIndex = 1
animCheckbox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
animCheckbox.TextColor3 = Color3.fromRGB(255, 255, 255)
animCheckbox.Font = Enum.Font.SourceSansBold
animCheckbox.TextSize = 20
animCheckbox.Text = "☐"

local animLabel = Instance.new("TextLabel", eggPanel)
animLabel.Size = UDim2.new(0, 200, 0, 25) -- reducido un poco
animLabel.Position = UDim2.new(0, 40, 0, 110)
animLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
animLabel.BackgroundTransparency = 1
animLabel.Font = Enum.Font.SourceSansBold
animLabel.TextSize = 18
animLabel.Text = "Mostrar Animación"

local animEnabled = false
animCheckbox.MouseButton1Click:Connect(function()
    animEnabled = not animEnabled
    animCheckbox.Text = animEnabled and "☑" or "☐"
end)

local delayLabel = Instance.new("TextLabel", eggPanel)
delayLabel.Text = "Delay (ms):"
delayLabel.Size = UDim2.new(0, 150, 0, 25)
delayLabel.Position = UDim2.new(0, 10, 0, 145) -- subido
delayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
delayLabel.BackgroundTransparency = 1
delayLabel.Font = Enum.Font.SourceSansBold
delayLabel.TextSize = 18
delayLabel.TextXAlignment = Enum.TextXAlignment.Left

local delayBox = Instance.new("TextBox", eggPanel)
delayBox.Size = UDim2.new(0, 150, 0, 25)
delayBox.ZIndex = 1
delayBox.PlaceholderText = "100"
delayBox.Text = "100"
delayBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
delayBox.TextColor3 = Color3.fromRGB(0, 255, 0)
delayBox.Font = Enum.Font.Code
delayBox.TextSize = 18
delayBox.ClearTextOnFocus = false

local toggleButton = Instance.new("TextButton", eggPanel)
toggleButton.Size = UDim2.new(0, 370, 0, 35) -- reducido altura
toggleButton.ZIndex = 1
toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Text = "▶️ Iniciar Auto Open Egg"

--// Auto Claim

local claimPanel = createPanel()
panels["claim"] = claimPanel

local claimLabel = Instance.new("TextLabel", claimPanel)
claimLabel.Text = "Auto Claim Rewards"
claimLabel.Size = UDim2.new(0, 380, 0, 30)
claimLabel.Position = UDim2.new(0, 10, 0, 10)
claimLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
claimLabel.BackgroundTransparency = 1
claimLabel.Font = Enum.Font.SourceSansBold
claimLabel.TextSize = 22
claimLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ▶️ Generar rewardConfig dinámicamente con patrón observado
local rewardConfig = {}
local id = 4
local delay = 60

for i = 1, 6 do
    if id == 7 then id = id + 1 end  -- Saltar ID 7 como en los datos reales

    table.insert(rewardConfig, {
        id = id,
        delay = delay
    })

    -- Delay no lineal basado en patrón observado
    if i == 1 then delay = delay + 120
    elseif i == 2 then delay = delay + 60
    elseif i == 3 then delay = delay + 180
    elseif i == 4 then delay = delay + 180
    elseif i == 5 then delay = delay + 300
    end

    id = id + 1
end

local claimRem = ReplicatedStorage["functions-shared/network@GlobalFunctions"]:WaitForChild("s:claimTimeGift")

local function createClaimButton(parent, reward, index)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 180, 0, 25)
    btn.Position = UDim2.new(0, 10 + ((index - 1) % 2) * 190, 0, 45 + math.floor((index - 1) / 2) * 30)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Text = "Recompensa " .. index
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            claimRem:FireServer(reward.id, reward.delay)
        end)
    end)
end

for i, reward in ipairs(rewardConfig) do
    createClaimButton(claimPanel, reward, i)
end


--// Logic

local placeRunning = false
local spinRunning = false
local eggRunning = false

-- Tabs logic
local function showPanel(name)
    for k, v in pairs(panels) do
        v.Visible = (k == name)
    end
end

showPanel("place") -- Default tab activa
claimTabBtn.MouseButton1Click:Connect(function()
    showPanel("claim")
end)
placeTabBtn.MouseButton1Click:Connect(function()
    showPanel("place")
end)
spinTabBtn.MouseButton1Click:Connect(function()
    showPanel("spin")
end)
eggTabBtn.MouseButton1Click:Connect(function()
    showPanel("egg")
end)

-- Auto PlaceBlock
placeToggle.MouseButton1Click:Connect(function()
    placeRunning = not placeRunning
    placeToggle.Text = placeRunning and "⏹️ Detener AutoPlace" or "▶️ Activar AutoPlace"

    spawn(function()
        while placeRunning do
            local delay_ms = tonumber(placeDelayBox.Text) or 100
            pcall(function()
                placeBlock:FireServer()
            end)
            task.wait(delay_ms / 1000)
        end
    end)
end)

-- Auto Spin
spinToggle.MouseButton1Click:Connect(function()
    spinRunning = not spinRunning
    spinToggle.Text = spinRunning and "⏹️ Detener Auto Spin" or "▶️ Iniciar Auto Spin"

    spawn(function()
        while spinRunning do
            local id = tonumber(spinIdBox.Text) or 11
            local delayMs = tonumber(spinDelayBox.Text) or 100
            pcall(function()
                spin:FireServer(id)
            end)
            task.wait(delayMs / 1000)
        end
    end)
end)

-- Auto Open Egg
toggleButton.MouseButton1Click:Connect(function()
    eggRunning = not eggRunning
    toggleButton.Text = eggRunning and "⏹️ Detener Auto Open Egg" or "▶️ Iniciar Auto Open Egg"

    if eggRunning then
        spawn(function()
            while eggRunning do
                local selectedName = dropdownText.Text
                local selectedEgg = nil
                for _, egg in ipairs(eggOptions) do
                    if egg.name == selectedName then
                        selectedEgg = egg
                        break
                    end
                end
                if selectedEgg then
                    pcall(function()
                        if animEnabled then
                            openEgg:FireServer(selectedEgg.id, selectedEgg.name, true)
                        else
                            openEgg:FireServer(selectedEgg.id, selectedEgg.name)
                        end
                    end)
                end
                local delayMs = tonumber(delayBox.Text) or 100
                task.wait(delayMs / 1000)
            end
        end)
    end
end)
local function updateDropdownPosition()
    local absPos = dropdownFrame.AbsolutePosition
    dropdownList.Position = UDim2.new(0, absPos.X, 0, absPos.Y + dropdownFrame.AbsoluteSize.Y)
end
-- Toggle GUI con Insert
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.Insert then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end
end)
