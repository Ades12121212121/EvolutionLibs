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

-- Configuración del sistema de toast
local ToastConfig = {
    MaxToasts = 5,
    DefaultDuration = 3,
    Position = "TopRight", -- TopRight, TopLeft, BottomRight, BottomLeft, Center
    Spacing = 10,
    AnimationSpeed = 0.3
}

local toastContainer = nil
local activeToasts = {}

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
    if ToastConfig.Position == "TopRight" then
        toastContainer.Position = UDim2.new(1, -420, 0, 20)
    elseif ToastConfig.Position == "TopLeft" then
        toastContainer.Position = UDim2.new(0, 20, 0, 20)
    elseif ToastConfig.Position == "BottomRight" then
        toastContainer.Position = UDim2.new(1, -420, 1, -100)
    elseif ToastConfig.Position == "BottomLeft" then
        toastContainer.Position = UDim2.new(0, 20, 1, -100)
    else
        toastContainer.Position = UDim2.new(0.5, -200, 0.5, -50)
    end
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, ToastConfig.Spacing)
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = toastContainer
    return toastContainer
end

local function removeToast(toastFrame)
    for i, t in ipairs(activeToasts) do
        if t == toastFrame then
            table.remove(activeToasts, i)
            break
        end
    end
    if toastFrame and toastFrame.Parent then
        toastFrame:Destroy()
    end
end

local function removeAllToasts()
    for _, t in ipairs(activeToasts) do
        if t and t.Parent then t:Destroy() end
    end
    activeToasts = {}
end

local function createToast(config)
    config = config or {}
    local text = config.Text or "Notification"
    local type = config.Type or "info"
    local duration = config.Duration or ToastConfig.DefaultDuration
    local theme = config.Theme or getDesigns().Themes.Dark
    local callback = config.Callback
    local persistent = config.Persistent or false
    local container = initializeContainer()
    if #activeToasts >= ToastConfig.MaxToasts then
        local oldestToast = activeToasts[1]
        if oldestToast and oldestToast.Parent then
            removeToast(oldestToast)
        end
    end
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
    local iconText = "ℹ"
    if type == "success" then iconText = "✓"
    elseif type == "error" then iconText = "✕"
    elseif type == "warning" then iconText = "⚠" end
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
    local progressBar
    if not persistent and duration > 0 then
        progressBar = Instance.new("Frame")
        progressBar.Name = "ProgressBar"
        progressBar.Size = UDim2.new(1, 0, 0, 2)
        progressBar.Position = UDim2.new(0, 0, 1, -2)
        progressBar.BackgroundColor3 = theme.Accent
        progressBar.BorderSizePixel = 0
        progressBar.Parent = toast
        progressBar.BackgroundTransparency = 0.2
        getUtils().tweenProperty(progressBar, "Size", UDim2.new(0, 0, 0, 2), duration, Enum.EasingStyle.Linear)
    end
    table.insert(activeToasts, toast)
    if not persistent and duration > 0 then
        task.spawn(function()
            wait(duration)
            removeToast(toast)
        end)
    end
    if closeBtn then
        closeBtn.MouseButton1Click:Connect(function()
            removeToast(toast)
            if callback then callback() end
        end)
    end
    toast.MouseEnter:Connect(function()
        getUtils().tweenProperty(toast, "BackgroundTransparency", 0.05, 0.2)
    end)
    toast.MouseLeave:Connect(function()
        getUtils().tweenProperty(toast, "BackgroundTransparency", 0, 0.2)
    end)
    toast.Remove = function() removeToast(toast) end
    toast.UpdateText = function(newText) label.Text = newText end
    return toast
end

local function successToast(text, duration, callback)
    return createToast({Text = text, Type = "success", Duration = duration, Callback = callback})
end
local function errorToast(text, duration, callback)
    return createToast({Text = text, Type = "error", Duration = duration, Callback = callback})
end
local function warningToast(text, duration, callback)
    return createToast({Text = text, Type = "warning", Duration = duration, Callback = callback})
end
local function infoToast(text, duration, callback)
    return createToast({Text = text, Type = "info", Duration = duration, Callback = callback})
end
local function setConfig(newConfig)
    for k, v in pairs(newConfig) do ToastConfig[k] = v end
end
local function getConfig() return ToastConfig end
local function getActiveToasts() return activeToasts end

return {
    Create = createToast,
    Success = successToast,
    Error = errorToast,
    Warning = warningToast,
    Info = infoToast,
    Remove = removeToast,
    RemoveAll = removeAllToasts,
    SetConfig = setConfig,
    GetConfig = getConfig,
    GetActiveToasts = getActiveToasts
}
