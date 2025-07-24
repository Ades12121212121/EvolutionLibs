-- Sidebar/Sidebar.lua - Sistema de sidebar y navegación lateral

local BASE_URL = "https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/main/EvolutionLibs/"
_G.EvoLibsCache = _G.EvoLibsCache or {}
local function getUtils()
    if not _G.EvoLibsCache.Utils then _G.EvoLibsCache.Utils = loadstring(game:HttpGet(BASE_URL .. "Utils/Utils.lua"))() end
    return _G.EvoLibsCache.Utils
end
local function getDesigns()
    if not _G.EvoLibsCache.Designs then _G.EvoLibsCache.Designs = loadstring(game:HttpGet(BASE_URL .. "Designs/Designs.lua"))() end
    return _G.EvoLibsCache.Designs
end

local Sidebar = {}

-- Crear sidebar principal
function Sidebar.Create(parent, config)
    config = config or {}
    local Designs = getDesigns()
    local theme = config.Theme or Designs.Themes.Dark
    local width = config.Width or 250
    local collapsible = config.Collapsible ~= false
    
    -- Container principal
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, width, 1, 0)
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.BackgroundColor3 = theme.Surface
    sidebar.BorderSizePixel = 0
    sidebar.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, theme.BorderRadius)
    corner.Parent = sidebar
    
    -- Efectos visuales
    Designs.Effects.CreateShadow(sidebar, theme, 0.2)
    if collapsible then
        Designs.Effects.CreateGlow(sidebar, theme, 0.1)
    end
    
    -- Header del sidebar
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 60)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = theme.Primary
    header.BorderSizePixel = 0
    header.Parent = sidebar
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, theme.BorderRadius)
    headerCorner.Parent = header
    
    -- Logo/Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "Menu"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Botón de colapso
    local collapseBtn
    if collapsible then
        collapseBtn = Instance.new("TextButton")
        collapseBtn.Name = "CollapseButton"
        collapseBtn.Size = UDim2.new(0, 40, 0, 40)
        collapseBtn.Position = UDim2.new(1, -50, 0.5, -20)
        collapseBtn.BackgroundColor3 = theme.Background
        collapseBtn.BorderSizePixel = 0
        collapseBtn.Text = "<<"
        collapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        collapseBtn.Font = Enum.Font.GothamBold
        collapseBtn.TextSize = 14
        collapseBtn.Parent = header
        
        local collapseBtnCorner = Instance.new("UICorner")
        collapseBtnCorner.CornerRadius = UDim.new(0, 20)
        collapseBtnCorner.Parent = collapseBtn
        
        Designs.Effects.CreateRipple(collapseBtn, theme.Hover, 0.3)
    end
    
    -- Container de navegación
    local navigation = Instance.new("ScrollingFrame")
    navigation.Name = "Navigation"
    navigation.Size = UDim2.new(1, 0, 1, -60)
    navigation.Position = UDim2.new(0, 0, 0, 60)
    navigation.BackgroundTransparency = 1
    navigation.BorderSizePixel = 0
    navigation.ScrollBarThickness = 6
    navigation.ScrollBarImageColor3 = theme.Primary
    navigation.ScrollBarImageTransparency = 0.5
    navigation.Parent = sidebar
    
    local navLayout = Instance.new("UIListLayout")
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Padding = UDim.new(0, 5)
    navLayout.Parent = navigation
    
    local navPadding = Instance.new("UIPadding")
    navPadding.PaddingTop = UDim.new(0, 10)
    navPadding.PaddingBottom = UDim.new(0, 10)
    navPadding.PaddingLeft = UDim.new(0, 10)
    navPadding.PaddingRight = UDim.new(0, 10)
    navPadding.Parent = navigation
    
    -- Auto-resize del contenido
    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        navigation.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Estado del sidebar
    local collapsed = false
    local originalWidth = width
    
    -- Función de colapso
    local function toggleCollapse()
        collapsed = not collapsed
        local targetWidth = collapsed and 70 or originalWidth
        local targetText = collapsed and ">>" or "<<"
        
        -- Animar sidebar
        local sidebarTween = game:GetService("TweenService"):Create(sidebar,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, targetWidth, 1, 0)}
        )
        sidebarTween:Play()
        
        -- Animar botón
        if collapseBtn then
            local btnTween = game:GetService("TweenService"):Create(collapseBtn,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Text = targetText}
            )
            btnTween:Play()
        end
        
        -- Ocultar/mostrar texto
        for _, child in pairs(navigation:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChild("Label") then
                local label = child:FindFirstChild("Label")
                local targetTransparency = collapsed and 1 or 0
                
                local textTween = game:GetService("TweenService"):Create(label,
                    TweenInfo.new(collapsed and 0.1 or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextTransparency = targetTransparency}
                )
                textTween:Play()
            end
        end
        
        -- Ocultar título
        local titleTween = game:GetService("TweenService"):Create(title,
            TweenInfo.new(collapsed and 0.1 or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {TextTransparency = collapsed and 1 or 0}
        )
        titleTween:Play()
    end
    
    if collapseBtn then
        collapseBtn.MouseButton1Click:Connect(toggleCollapse)
    end
    
    -- API del sidebar
    sidebar.AddItem = function(text, icon, callback)
        local item = Instance.new("Frame")
        item.Name = "NavigationItem"
        item.Size = UDim2.new(1, 0, 0, 45)
        item.BackgroundColor3 = theme.Background
        item.BackgroundTransparency = 0.5
        item.BorderSizePixel = 0
        item.LayoutOrder = #navigation:GetChildren()
        item.Parent = navigation
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, theme.BorderRadius)
        itemCorner.Parent = item
        
        -- Botón clickeable
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.Parent = item
        
        -- Icono (opcional)
        local iconLabel
        if icon then
            iconLabel = Instance.new("TextLabel")
            iconLabel.Name = "Icon"
            iconLabel.Size = UDim2.new(0, 30, 0, 30)
            iconLabel.Position = UDim2.new(0, 15, 0.5, -15)
            iconLabel.BackgroundTransparency = 1
            iconLabel.Text = icon
            iconLabel.TextColor3 = theme.TextSecondary
            iconLabel.Font = Enum.Font.GothamBold
            iconLabel.TextSize = 16
            iconLabel.Parent = item
        end
        
        -- Label del texto
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, iconLabel and -60 or -30, 1, 0)
        label.Position = UDim2.new(0, iconLabel and 55 or 15, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = theme.Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = item
        
        -- Efectos de hover
        local originalColor = item.BackgroundColor3
        local originalTransparency = item.BackgroundTransparency
        
        button.MouseEnter:Connect(function()
            local tween = game:GetService("TweenService"):Create(item,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    BackgroundColor3 = theme.Primary,
                    BackgroundTransparency = 0.1
                }
            )
            tween:Play()
            
            if iconLabel then
                local iconTween = game:GetService("TweenService"):Create(iconLabel,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextColor3 = Color3.fromRGB(255, 255, 255)}
                )
                iconTween:Play()
            end
        end)
        
        button.MouseLeave:Connect(function()
            local tween = game:GetService("TweenService"):Create(item,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    BackgroundColor3 = originalColor,
                    BackgroundTransparency = originalTransparency
                }
            )
            tween:Play()
            
            if iconLabel then
                local iconTween = game:GetService("TweenService"):Create(iconLabel,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextColor3 = theme.TextSecondary}
                )
                iconTween:Play()
            end
        end)
        
        -- Efecto de click
        button.MouseButton1Click:Connect(function()
            -- Animación de click
            local clickTween = game:GetService("TweenService"):Create(item,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {Size = UDim2.new(0.95, 0, 0, 42)}
            )
            clickTween:Play()
            
            clickTween.Completed:Connect(function()
                local returnTween = game:GetService("TweenService"):Create(item,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {Size = UDim2.new(1, 0, 0, 45)}
                )
                returnTween:Play()
            end)
            
            -- Ripple effect
            Designs.Effects.CreateRipple(button, theme.Hover, 0.4)
            
            if callback then callback() end
        end)
        
        return item
    end
    
    sidebar.AddSeparator = function(text)
        local separator = Instance.new("Frame")
        separator.Name = "Separator"
        separator.Size = UDim2.new(1, 0, 0, text and 35 or 15)
        separator.BackgroundTransparency = 1
        separator.LayoutOrder = #navigation:GetChildren()
        separator.Parent = navigation
        
        if text then
            local separatorText = Instance.new("TextLabel")
            separatorText.Name = "SeparatorText"
            separatorText.Size = UDim2.new(1, -20, 1, 0)
            separatorText.Position = UDim2.new(0, 10, 0, 0)
            separatorText.BackgroundTransparency = 1
            separatorText.Text = text:upper()
            separatorText.TextColor3 = theme.TextSecondary
            separatorText.Font = Enum.Font.GothamBold
            separatorText.TextSize = 12
            separatorText.TextXAlignment = Enum.TextXAlignment.Left
            separatorText.Parent = separator
        else
            local line = Instance.new("Frame")
            line.Name = "Line"
            line.Size = UDim2.new(1, -20, 0, 1)
            line.Position = UDim2.new(0, 10, 0.5, 0)
            line.BackgroundColor3 = theme.Border
            line.BorderSizePixel = 0
            line.Parent = separator
        end
        
        return separator
    end
    
    sidebar.SetActiveItem = function(itemText)
        for _, child in pairs(navigation:GetChildren()) do
            if child:IsA("Frame") and child.Name == "NavigationItem" then
                local label = child:FindFirstChild("Label")
                if label and label.Text == itemText then
                    -- Activar este item
                    child.BackgroundColor3 = theme.Primary
                    child.BackgroundTransparency = 0.2
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    
                    local icon = child:FindFirstChild("Icon")
                    if icon then
                        icon.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                else
                    -- Desactivar otros items
                    child.BackgroundColor3 = theme.Background
                    child.BackgroundTransparency = 0.5
                    label.TextColor3 = theme.Text
                    
                    local icon = child:FindFirstChild("Icon")
                    if icon then
                        icon.TextColor3 = theme.TextSecondary
                    end
                end
            end
        end
    end
    
    sidebar.Toggle = function()
        if collapsible then
            toggleCollapse()
        end
    end
    
    sidebar.IsCollapsed = function()
        return collapsed
    end
    
    -- (1) Asegura que Sidebar.Create retorna la API, nunca el Frame directo
    local api = {}
    api.Main = sidebar
    api.AddItem = sidebar.AddItem
    api.AddSeparator = sidebar.AddSeparator
    api.SetActiveItem = sidebar.SetActiveItem
    api.Toggle = sidebar.Toggle
    api.IsCollapsed = sidebar.IsCollapsed
    return api, navigation
end

-- Crear mini sidebar (solo iconos)
function Sidebar.CreateMini(parent, config)
    config = config or {}
    local Designs = getDesigns()
    local theme = config.Theme or Designs.Themes.Dark
    local width = config.Width or 60
    
    local miniSidebar = Instance.new("Frame")
    miniSidebar.Name = "MiniSidebar"
    miniSidebar.Size = UDim2.new(0, width, 1, 0)
    miniSidebar.Position = UDim2.new(0, 0, 0, 0)
    miniSidebar.BackgroundColor3 = theme.Surface
    miniSidebar.BorderSizePixel = 0
    miniSidebar.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, theme.BorderRadius)
    corner.Parent = miniSidebar
    
    -- Efectos visuales
    Designs.Effects.CreateShadow(miniSidebar, theme, 0.3)
    Designs.Effects.CreateGlow(miniSidebar, theme, 0.1)
    
    -- Container de iconos
    local iconContainer = Instance.new("Frame")
    iconContainer.Name = "IconContainer"
    iconContainer.Size = UDim2.new(1, 0, 1, 0)
    iconContainer.BackgroundTransparency = 1
    iconContainer.Parent = miniSidebar
    
    local iconLayout = Instance.new("UIListLayout")
    iconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    iconLayout.Padding = UDim.new(0, 10)
    iconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    iconLayout.Parent = iconContainer
    
    local iconPadding = Instance.new("UIPadding")
    iconPadding.PaddingTop = UDim.new(0, 15)
    iconPadding.PaddingBottom = UDim.new(0, 15)
    iconPadding.Parent = iconContainer
    
    -- API del mini sidebar
    miniSidebar.AddIcon = function(icon, tooltip, callback)
        local iconBtn = Instance.new("TextButton")
        iconBtn.Name = "IconButton"
        iconBtn.Size = UDim2.new(0, 40, 0, 40)
        iconBtn.BackgroundColor3 = theme.Background
        iconBtn.BorderSizePixel = 0
        iconBtn.Text = icon
        iconBtn.TextColor3 = theme.TextSecondary
        iconBtn.Font = Enum.Font.GothamBold
        iconBtn.TextSize = 18
        iconBtn.LayoutOrder = #iconContainer:GetChildren()
        iconBtn.Parent = iconContainer
        
        local iconCorner = Instance.new("UICorner")
        iconCorner.CornerRadius = UDim.new(0, 20)
        iconCorner.Parent = iconBtn
        
        -- Efectos de hover
        iconBtn.MouseEnter:Connect(function()
            local tween = game:GetService("TweenService"):Create(iconBtn,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    BackgroundColor3 = theme.Primary,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 45, 0, 45)
                }
            )
            tween:Play()
            
            -- Mostrar tooltip si existe
            if tooltip then
                -- Crear tooltip temporal
                local tooltipFrame = Instance.new("Frame")
                tooltipFrame.Name = "Tooltip"
                tooltipFrame.Size = UDim2.new(0, #tooltip * 8 + 20, 0, 30)
                tooltipFrame.Position = UDim2.new(1, 10, 0, iconBtn.AbsolutePosition.Y - miniSidebar.AbsolutePosition.Y - 5)
                tooltipFrame.BackgroundColor3 = theme.Background
                tooltipFrame.BorderSizePixel = 0
                tooltipFrame.ZIndex = 10
                tooltipFrame.Parent = miniSidebar
                
                local tooltipCorner = Instance.new("UICorner")
                tooltipCorner.CornerRadius = UDim.new(0, 6)
                tooltipCorner.Parent = tooltipFrame
                
                local tooltipText = Instance.new("TextLabel")
                tooltipText.Size = UDim2.new(1, 0, 1, 0)
                tooltipText.BackgroundTransparency = 1
                tooltipText.Text = tooltip
                tooltipText.TextColor3 = theme.Text
                tooltipText.Font = Enum.Font.Gotham
                tooltipText.TextSize = 12
                tooltipText.Parent = tooltipFrame
                
                Designs.Effects.CreateShadow(tooltipFrame, theme, 0.4)
                
                -- Animar entrada del tooltip
                tooltipFrame.BackgroundTransparency = 1
                tooltipText.TextTransparency = 1
                
                local tooltipTween = game:GetService("TweenService"):Create(tooltipFrame,
                    TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundTransparency = 0}
                )
                local textTween = game:GetService("TweenService"):Create(tooltipText,
                    TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextTransparency = 0}
                )
                
                tooltipTween:Play()
                textTween:Play()
                
                iconBtn.MouseLeave:Connect(function()
                    local fadeOut = game:GetService("TweenService"):Create(tooltipFrame,
                        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                        {BackgroundTransparency = 1}
                    )
                    local textFadeOut = game:GetService("TweenService"):Create(tooltipText,
                        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                        {TextTransparency = 1}
                    )
                    
                    fadeOut:Play()
                    textFadeOut:Play()
                    
                    fadeOut.Completed:Connect(function()
                        tooltipFrame:Destroy()
                    end)
                end)
            end
        end)
        
        iconBtn.MouseLeave:Connect(function()
            local tween = game:GetService("TweenService"):Create(iconBtn,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    BackgroundColor3 = theme.Background,
                    TextColor3 = theme.TextSecondary,
                    Size = UDim2.new(0, 40, 0, 40)
                }
            )
            tween:Play()
        end)
        
        iconBtn.MouseButton1Click:Connect(function()
            Designs.Effects.CreateRipple(iconBtn, theme.Hover, 0.3)
            if callback then callback() end
        end)
        
        return iconBtn
    end
    
    miniSidebar.SetActiveIcon = function(iconText)
        for _, child in pairs(iconContainer:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Text == iconText then
                    child.BackgroundColor3 = theme.Primary
                    child.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    child.BackgroundColor3 = theme.Background
                    child.TextColor3 = theme.TextSecondary
                end
            end
        end
    end
    
    return miniSidebar
end

Sidebar.new = Sidebar.Create

return Sidebar
