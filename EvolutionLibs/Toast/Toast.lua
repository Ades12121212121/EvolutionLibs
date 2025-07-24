-- Toast/Toast.lua - Sistema de notificaciones tipo toast

local BASE_URL = "https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/main/EvolutionLibs/"
local Utils, Designs
local function getUtils()
    if not Utils then Utils = loadstring(game:HttpGet(BASE_URL .. "Utils/Utils.lua"))() end
    return Utils
end
local function getDesigns()
    if not Designs then Designs = loadstring(game:HttpGet(BASE_URL .. "Designs/Designs.lua"))() end
    return Designs
end

local Toast = {}

-- Configuración del sistema de toast
local ToastConfig = {
    MaxToasts = 5,
    DefaultDuration = 3,
    Position = "TopRight", -- TopRight, TopLeft, BottomRight, BottomLeft, Center
    Spacing = 10,
    AnimationSpeed = 0.3
}

-- Container global para toasts
local toastContainer = nil
local activeToasts = {}

-- Inicializar container de toasts
local function initializeContainer()
    if toastContainer then return toastContainer end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "ToastNotifications"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    toastContainer = Instance.new("Frame")
    toastContainer.Name = "ToastContainer"
    toastContainer.Size = UDim2.new(0, 400, 1, 0)
    toastContainer.BackgroundTransparency = 1
    toastContainer.Parent = gui
    
    -- Posicionar container según configuración
    if ToastConfig.Position == "TopRight" then
        toastContainer.Position = UDim2.new(1, -420, 0, 20)
    elseif ToastConfig.Position == "TopLeft" then
        toastContainer.Position = UDim2.new(0, 20, 0, 20)
    elseif ToastConfig.Position == "BottomRight" then
        toastContainer.Position = UDim2.new(1, -420, 1, -100)
    elseif ToastConfig.Position == "BottomLeft" then
        toastContainer.Position = UDim2.new(0, 20, 1, -100)
    else -- Center
        toastContainer.Position = UDim2.new(0.5, -200, 0.5, -50)
    end
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, ToastConfig.Spacing)
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = toastContainer
    
    return toastContainer
end

-- Crear notificación toast
function Toast.Create(config)
    config = config or {}
    local text = config.Text or "Notification"
    local type = config.Type or "info"
    local duration = config.Duration or ToastConfig.DefaultDuration
    local theme = config.Theme or Designs.Themes.Dark
    local callback = config.Callback
    local persistent = config.Persistent or false
    
    -- Inicializar container si no existe
    local container = initializeContainer()
    
    -- Remover toasts antiguos si hay demasiados
    if #activeToasts >= ToastConfig.MaxToasts then
        local oldestToast = activeToasts[1]
        if oldestToast and oldestToast.Parent then
            Toast.Remove(oldestToast)
        end
    end
    
    -- Crear toast
    local toast = Instance.new("Frame")
    toast.Name = "Toast"
    toast.Size = UDim2.new(1, 0, 0, 80)
    toast.BackgroundColor3 = theme.Surface
    toast.BorderSizePixel = 0
    toast.LayoutOrder = #activeToasts + 1
    toast.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, theme.BorderRadius)
    corner.Parent = toast
    
    -- Barra de estado según tipo
    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(0, 4, 1, 0)
    statusBar.Position = UDim2.new(0, 0, 0, 0)
    statusBar.BorderSizePixel = 0
    statusBar.Parent = toast
    
    if type == "success" then
        statusBar.BackgroundColor3 = theme.Success
    elseif type == "error" then
        statusBar.BackgroundColor3 = theme.Error
    elseif type == "warning" then
        statusBar.BackgroundColor3 = theme.Warning
    else
        statusBar.BackgroundColor3 = theme.Info
    end
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, theme.BorderRadius)
    statusCorner.Parent = statusBar
    
    -- Icono según tipo
    local iconText = "ℹ"
    if type == "success" then
        iconText = "✓"
    elseif type == "error" then
        iconText = "✕"
    elseif type == "warning" then
        iconText = "⚠"
    end
    
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 15, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.Text = iconText
    icon.TextColor3 = statusBar.BackgroundColor3
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 20
    icon.Parent = toast
    
    -- Texto principal
    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.Size = UDim2.new(1, persistent and -80 or -110, 1, 0)
    label.Position = UDim2.new(0, 55, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = toast
    
    -- Botón cerrar (si no es persistente)
    local closeBtn
    if not persistent then
        closeBtn = Instance.new("TextButton")
        closeBtn.Name = "Close"
        closeBtn.Size = UDim2.new(0, 25, 0, 25)
        closeBtn.Position = UDim2.new(1, -35, 0, 10)
        closeBtn.BackgroundColor3 = theme.Error
        closeBtn.BorderSizePixel = 0
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 10
        closeBtn.Parent = toast
        
        local closeBtnCorner = Instance.new("UICorner")
        closeBtnCorner.CornerRadius = UDim.new(0, 12)
        closeBtnCorner.Parent = closeBtn
        
        -- Hover effect para botón cerrar
        closeBtn.MouseEnter:Connect(function()
            local tween = game:GetService("TweenService"):Create(closeBtn,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 28, 0, 28)}
            )
            tween:Play()
        end)
        
        closeBtn.MouseLeave:Connect(function()
            local tween = game:GetService("TweenService"):Create(closeBtn,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 25, 0, 25)}
            )
            tween:Play()
        end)
    end
    
    -- Barra de progreso (para toasts temporales)
    local progressBar
    if not persistent and duration > 0 then
        progressBar = Instance.new("Frame")
        progressBar.Name = "ProgressBar"
        progressBar.Size = UDim2.new(1, 0, 0, 2)
        progressBar.Position = UDim2.new(0, 0, 1, -2)
        progressBar.BackgroundColor3 = statusBar.BackgroundColor3
        progressBar.BorderSizePixel = 0
        progressBar.Parent = toast
        
        local progressCorner = Instance.new("UICorner")
        progressCorner.CornerRadius = UDim.new(0, 1)
        progressCorner.Parent = progressBar
        
        -- Animar barra de progreso
        local progressTween = game:GetService("TweenService"):Create(progressBar,
            TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
            {Size = UDim2.new(0, 0, 0, 2)}
        )
        progressTween:Play()
    end
    
    -- Efectos visuales
    Designs.Effects.CreateShadow(toast, theme, 0.3)
    if Designs.Simple.GetConfig().EnableGlow then
        Designs.Effects.CreateGlow(toast, theme, 0.2)
    end
    
    -- Animación de entrada
    toast.Position = UDim2.new(1, 0, 0, 0)
    toast.BackgroundTransparency = 1
    label.TextTransparency = 1
    icon.TextTransparency = 1
    
    local slideIn = game:GetService("TweenService"):Create(toast,
        TweenInfo.new(ToastConfig.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 0
        }
    )
    
    local fadeInText = game:GetService("TweenService"):Create(label,
        TweenInfo.new(ToastConfig.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    )
    
    local fadeInIcon = game:GetService("TweenService"):Create(icon,
        TweenInfo.new(ToastConfig.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    )
    
    slideIn:Play()
    fadeInText:Play()
    fadeInIcon:Play()
    
    -- Función para remover toast
    local function removeToast()
        -- Encontrar y remover de lista activa
        for i, activeToast in ipairs(activeToasts) do
            if activeToast == toast then
                table.remove(activeToasts, i)
                break
            end
        end
        
        -- Animación de salida
        local slideOut = game:GetService("TweenService"):Create(toast,
            TweenInfo.new(ToastConfig.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {
                Position = UDim2.new(1, 50, 0, 0),
                BackgroundTransparency = 1
            }
        )
        
        local fadeOutText = game:GetService("TweenService"):Create(label,
            TweenInfo.new(ToastConfig.AnimationSpeed * 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {TextTransparency = 1}
        )
        
        local fadeOutIcon = game:GetService("TweenService"):Create(icon,
            TweenInfo.new(ToastConfig.AnimationSpeed * 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {TextTransparency = 1}
        )
        
        slideOut:Play()
        fadeOutText:Play()
        fadeOutIcon:Play()
        
        slideOut.Completed:Connect(function()
            toast:Destroy()
            if callback then callback() end
        end)
    end
    
    -- Configurar cierre automático
    if not persistent and duration > 0 then
        spawn(function()
            wait(duration)
            if toast.Parent then
                removeToast()
            end
        end)
    end
    
    -- Configurar botón cerrar
    if closeBtn then
        closeBtn.MouseButton1Click:Connect(removeToast)
    end
    
    -- Hover para pausar auto-close
    local hoverPaused = false
    toast.MouseEnter:Connect(function()
        hoverPaused = true
        if progressBar then
            -- Pausar animación de progreso
            local currentSize = progressBar.AbsoluteSize.X
            local totalSize = toast.AbsoluteSize.X
            local remainingRatio = currentSize / totalSize
            
            -- Detener tween actual
            game:GetService("TweenService"):Create(progressBar, TweenInfo.new(0), {}):Play()
        end
    end)
    
    toast.MouseLeave:Connect(function()
        hoverPaused = false
        if progressBar and not persistent then
            -- Reanudar animación de progreso
            local currentSize = progressBar.AbsoluteSize.X
            local totalSize = toast.AbsoluteSize.X
            local remainingRatio = currentSize / totalSize
            local remainingTime = duration * remainingRatio
            
            if remainingTime > 0 then
                local resumeTween = game:GetService("TweenService"):Create(progressBar,
                    TweenInfo.new(remainingTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
                    {Size = UDim2.new(0, 0, 0, 2)}
                )
                resumeTween:Play()
            end
        end
    end)
    
    -- Añadir a lista activa
    table.insert(activeToasts, toast)
    
    -- API del toast individual
    toast.Remove = removeToast
    toast.UpdateText = function(newText)
        label.Text = newText
    end
    
    return toast
end

-- Funciones de conveniencia
function Toast.Success(text, duration, callback)
    return Toast.Create({
        Text = text,
        Type = "success",
        Duration = duration,
        Callback = callback
    })
end

function Toast.Error(text, duration, callback)
    return Toast.Create({
        Text = text,
        Type = "error",
        Duration = duration,
        Callback = callback
    })
end

function Toast.Warning(text, duration, callback)
    return Toast.Create({
        Text = text,
        Type = "warning",
        Duration = duration,
        Callback = callback
    })
end

function Toast.Info(text, duration, callback)
    return Toast.Create({
        Text = text,
        Type = "info",
        Duration = duration,
        Callback = callback
    })
end

-- Funciones de gestión global
function Toast.Remove(toastFrame)
    if toastFrame and toastFrame.Remove then
        toastFrame.Remove()
    end
end

function Toast.RemoveAll()
    for i = #activeToasts, 1, -1 do
        local toast = activeToasts[i]
        if toast and toast.Parent then
            Toast.Remove(toast)
        end
    end
    activeToasts = {}
end

function Toast.SetConfig(newConfig)
    for key, value in pairs(newConfig) do
        if ToastConfig[key] ~= nil then
            ToastConfig[key] = value
        end
    end
    
    -- Reposicionar container si cambió la posición
    if toastContainer and newConfig.Position then
        if ToastConfig.Position == "TopRight" then
            toastContainer.Position = UDim2.new(1, -420, 0, 20)
        elseif ToastConfig.Position == "TopLeft" then
            toastContainer.Position = UDim2.new(0, 20, 0, 20)
        elseif ToastConfig.Position == "BottomRight" then
            toastContainer.Position = UDim2.new(1, -420, 1, -100)
        elseif ToastConfig.Position == "BottomLeft" then
            toastContainer.Position = UDim2.new(0, 20, 1, -100)
        else -- Center
            toastContainer.Position = UDim2.new(0.5, -200, 0.5, -50)
        end
    end
end

function Toast.GetConfig()
    return ToastConfig
end

function Toast.GetActiveToasts()
    return activeToasts
end

return Toast