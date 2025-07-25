-- Elements/Elements.lua - Componentes UI básicos

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

local Elements = {}

-- Sistema de utilidades de diseño
Elements.Utils = {
    -- Aplicar tema completo a elemento
    ApplyTheme = function(element, theme, style)
        style = style or "Default"
        
        if style == "Primary" then
            element.BackgroundColor3 = theme.Primary
            if element:IsA("TextLabel") or element:IsA("TextButton") then
                element.TextColor3 = theme.Text
            end
        elseif style == "Secondary" then
            element.BackgroundColor3 = theme.Secondary
            if element:IsA("TextLabel") or element:IsA("TextButton") then
                element.TextColor3 = theme.TextSecondary
            end
        elseif style == "Surface" then
            element.BackgroundColor3 = theme.Surface
            if element:IsA("TextLabel") or element:IsA("TextButton") then
                element.TextColor3 = theme.Text
            end
        end
        
        -- Agregar esquinas redondeadas
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, theme.BorderRadius)
        corner.Parent = element
        
        return element
    end,
    
    -- Aplicar efectos de hover
    AddHoverEffect = function(element, theme, style)
        local utils = getUtils()
        local designs = getDesigns()
        if not utils or not designs then
            warn("[EvolutionLibs] No se pudieron cargar los módulos necesarios para AddHoverEffect")
            return
        end

        style = style or "Subtle"
        local originalColor = element.BackgroundColor3
        local originalTransparency = element.BackgroundTransparency
        
        local hoverColor = theme.Hover
        local hoverTransparency = originalTransparency
        
        if style == "Glow" then
            hoverColor = theme.Primary
            designs.Effects.CreateGlow(element, theme, 0)
        elseif style == "Lift" then
            hoverTransparency = math.max(0, originalTransparency - 0.1)
        elseif style == "Pulse" then
            -- Se manejará con animación
        end
        
        element.MouseEnter:Connect(function()
            if style == "Pulse" then
                Elements.Animations.Pulse(element, 1.05, 0.3, false)
            else
                local tween = game:GetService("TweenService"):Create(element,
                    TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {
                        BackgroundColor3 = utils.lerpColor(originalColor, hoverColor, 0.2),
                        BackgroundTransparency = hoverTransparency
                    }
                )
                tween:Play()
            end
        end)
        
        element.MouseLeave:Connect(function()
            local tween = game:GetService("TweenService"):Create(element,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    BackgroundColor3 = originalColor,
                    BackgroundTransparency = originalTransparency
                }
            )
            tween:Play()
        end)
    end
}

-- Sistema de animaciones
Elements.Animations = {
    -- Animación de entrada
    FadeIn = function(element, duration, delay)
        duration = duration or 0.3
        delay = delay or 0
        
        element.BackgroundTransparency = 1
        if element:IsA("TextLabel") or element:IsA("TextButton") then
            element.TextTransparency = 1
        end
        
        wait(delay)
        
        local tween = game:GetService("TweenService"):Create(element,
            TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                BackgroundTransparency = 0,
                TextTransparency = 0
            }
        )
        tween:Play()
        return tween
    end,
    
    -- Animación de rebote
    Bounce = function(element, intensity, duration)
        intensity = intensity or 1.2
        duration = duration or 0.2
        
        local originalSize = element.Size
        
        local scaleUp = game:GetService("TweenService"):Create(element,
            TweenInfo.new(duration / 2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = UDim2.new(originalSize.X.Scale * intensity, originalSize.X.Offset, 
                             originalSize.Y.Scale * intensity, originalSize.Y.Offset)}
        )
        
        scaleUp:Play()
        scaleUp.Completed:Connect(function()
            local scaleDown = game:GetService("TweenService"):Create(element,
                TweenInfo.new(duration / 2, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Size = originalSize}
            )
            scaleDown:Play()
        end)
        
        return scaleUp
    end,
    
    -- Animación de pulso
    Pulse = function(element, intensity, duration, infinite)
        intensity = intensity or 1.1
        duration = duration or 1.0
        infinite = infinite or false
        
        local originalSize = element.Size
        local targetSize = UDim2.new(originalSize.X.Scale * intensity, originalSize.X.Offset,
                                   originalSize.Y.Scale * intensity, originalSize.Y.Offset)
        
        local tween = game:GetService("TweenService"):Create(element,
            TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 
                         infinite and -1 or 0, true),
            {Size = targetSize}
        )
        tween:Play()
        
        return tween
    end
}

-- Sistema de presets de componentes
Elements.Presets = {
    -- Botón moderno
    ModernButton = function(parent, text, theme, style)
        local designs = getDesigns()
        if not designs then
            warn("[EvolutionLibs] No se pudo cargar el módulo Designs para ModernButton")
            return nil
        end

        style = style or "Primary"
        
        local button = Instance.new("TextButton")
        button.Name = "ModernButton"
        button.Size = UDim2.new(0, 200, 0, 45)
        button.BackgroundColor3 = style == "Primary" and theme.Primary or theme.Secondary
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 16
        button.Parent = parent
        
        -- Efectos visuales
        Elements.Utils.ApplyTheme(button, theme, style)
        designs.Effects.CreateRipple(button, theme.Hover, 0.5)
        Elements.Utils.AddHoverEffect(button, theme, "Glow")
        
        -- Animación de entrada
        Elements.Animations.FadeIn(button, 0.3, 0)
        
        return button
    end,
    
    -- Card elegante
    ElegantCard = function(parent, theme, gradient)
        local designs = getDesigns()
        if not designs then
            warn("[EvolutionLibs] No se pudo cargar el módulo Designs para ElegantCard")
            return nil
        end

        gradient = gradient or false
        
        local card = Instance.new("Frame")
        card.Name = "ElegantCard"
        card.Size = UDim2.new(0, 300, 0, 200)
        card.BackgroundColor3 = theme.Surface
        card.BorderSizePixel = 0
        card.Parent = parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, theme.BorderRadius * 1.5)
        corner.Parent = card
        
        -- Aplicar gradiente si se solicita
        if gradient then
            designs.Effects.ApplyGradient(card, theme.BackgroundGradient)
        end
        
        -- Efectos visuales
        designs.Effects.CreateShadow(card, theme, 0.2)
        designs.Effects.CreateGlow(card, theme, 0.1)
        
        -- Padding interno
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 20)
        padding.PaddingBottom = UDim.new(0, 20)
        padding.PaddingLeft = UDim.new(0, 20)
        padding.PaddingRight = UDim.new(0, 20)
        padding.Parent = card
        
        -- Hover effect
        Elements.Utils.AddHoverEffect(card, theme, "Lift")
        
        return card
    end,
    
    -- Toggle switch avanzado
    AdvancedToggle = function(parent, text, default, callback, theme)
        local designs = getDesigns()
        if not designs then
            warn("[EvolutionLibs] No se pudo cargar el módulo Designs para AdvancedToggle")
            return nil
        end

        local container = Instance.new("Frame")
        container.Name = "AdvancedToggle"
        container.Size = UDim2.new(1, -40, 0, 50)
        container.BackgroundColor3 = theme.Surface
        container.BorderSizePixel = 0
        container.Parent = parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, theme.BorderRadius)
        corner.Parent = container
        
        -- Label
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -80, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = theme.Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        -- Switch container
        local switchContainer = Instance.new("Frame")
        switchContainer.Name = "SwitchContainer"
        switchContainer.Size = UDim2.new(0, 60, 0, 30)
        switchContainer.Position = UDim2.new(1, -75, 0.5, -15)
        switchContainer.BackgroundColor3 = default and theme.Success or theme.Secondary
        switchContainer.BorderSizePixel = 0
        switchContainer.Parent = container
        
        local switchCorner = Instance.new("UICorner")
        switchCorner.CornerRadius = UDim.new(0, 15)
        switchCorner.Parent = switchContainer
        
        -- Switch circle
        local circle = Instance.new("Frame")
        circle.Name = "Circle"
        circle.Size = UDim2.new(0, 24, 0, 24)
        circle.Position = default and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.BorderSizePixel = 0
        circle.Parent = switchContainer
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(0, 12)
        circleCorner.Parent = circle
        
        -- Efectos
        designs.Effects.CreateShadow(circle, theme, 0.4)
        designs.Effects.CreateGlow(switchContainer, theme, 0.3)
        
        -- Estado y lógica
        local toggled = default
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.Parent = container
        
        local function toggle()
            toggled = not toggled
            
            local circlePos = toggled and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
            local switchColor = toggled and theme.Success or theme.Secondary
            
            -- Animaciones suaves
            local circleTween = game:GetService("TweenService"):Create(circle,
                TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Position = circlePos}
            )
            
            local switchTween = game:GetService("TweenService"):Create(switchContainer,
                TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = switchColor}
            )
            
            circleTween:Play()
            switchTween:Play()
            
            -- Efecto de rebote
            Elements.Animations.Bounce(circle, 1.1, 0.15)
            
            if callback then callback(toggled) end
        end
        
        button.MouseButton1Click:Connect(toggle)
        designs.Effects.CreateRipple(button, theme.Hover, 0.4)
        
        return container
    end,
    
    -- Slider con estilo
    StyledSlider = function(parent, text, min, max, default, callback, theme)
        local designs = getDesigns()
        if not designs then
            warn("[EvolutionLibs] No se pudo cargar el módulo Designs para StyledSlider")
            return nil
        end

        local container = Instance.new("Frame")
        container.Name = "StyledSlider"
        container.Size = UDim2.new(1, -40, 0, 60)
        container.BackgroundColor3 = theme.Surface
        container.BorderSizePixel = 0
        container.Parent = parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, theme.BorderRadius)
        corner.Parent = container
        
        -- Label y valor
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(0.7, 0, 0, 25)
        label.Position = UDim2.new(0, 15, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = theme.Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "Value"
        valueLabel.Size = UDim2.new(0.3, -15, 0, 25)
        valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = theme.Primary
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 14
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = container
        
        -- Track del slider
        local track = Instance.new("Frame")
        track.Name = "Track"
        track.Size = UDim2.new(1, -30, 0, 6)
        track.Position = UDim2.new(0, 15, 1, -25)
        track.BackgroundColor3 = theme.Secondary
        track.BorderSizePixel = 0
        track.Parent = container
        
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(0, 3)
        trackCorner.Parent = track
        
        -- Fill del slider
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.Position = UDim2.new(0, 0, 0, 0)
        fill.BackgroundColor3 = theme.Primary
        fill.BorderSizePixel = 0
        fill.Parent = track
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 3)
        fillCorner.Parent = fill
        
        -- Aplicar gradiente al fill
        designs.Effects.ApplyGradient(fill, theme.PrimaryGradient)
        
        -- Handle del slider
        local handle = Instance.new("Frame")
        handle.Name = "Handle"
        handle.Size = UDim2.new(0, 18, 0, 18)
        handle.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
        handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        handle.BorderSizePixel = 0
        handle.Parent = track
        
        local handleCorner = Instance.new("UICorner")
        handleCorner.CornerRadius = UDim.new(0, 9)
        handleCorner.Parent = handle
        
        -- Efectos del handle
        designs.Effects.CreateShadow(handle, theme, 0.3)
        designs.Effects.CreateGlow(handle, theme, 0.2)
        
        -- Lógica del slider
        local dragging = false
        local currentValue = default
        
        local function updateSlider(inputPosition)
            local trackPosition = track.AbsolutePosition.X
            local trackSize = track.AbsoluteSize.X
            local relativePosition = math.clamp((inputPosition - trackPosition) / trackSize, 0, 1)
            
            currentValue = min + (max - min) * relativePosition
            currentValue = math.floor(currentValue * 100) / 100 -- Redondear a 2 decimales
            
            -- Actualizar UI
            valueLabel.Text = tostring(currentValue)
            
            local fillTween = game:GetService("TweenService"):Create(fill,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(relativePosition, 0, 1, 0)}
            )
            
            local handleTween = game:GetService("TweenService"):Create(handle,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(relativePosition, -9, 0.5, -9)}
            )
            
            fillTween:Play()
            handleTween:Play()
            
            if callback then callback(currentValue) end
        end
        
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                Elements.Animations.Bounce(handle, 1.2, 0.1)
            end
        end)
        
        handle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input.Position.X)
            end
        end)
        
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateSlider(input.Position.X)
            end
        end)
        
        return container
    end
}

-- API simplificada
Elements.Simple = {
    -- Crear componente rápido
    Create = function(componentType, parent, config)
        config = config or {}
        local designs = getDesigns()
        if not designs then
            warn("[EvolutionLibs] No se pudo cargar el módulo Designs para Create")
            return nil
        end

        local theme = designs.Themes[config.Theme or "Dark"]
        if componentType == "Button" then
            return Elements.Presets.ModernButton(parent, config.Text or "Button", theme, config.Style)
        elseif componentType == "Card" then
            return Elements.Presets.ElegantCard(parent, theme, config.Gradient)
        elseif componentType == "Toggle" then
            return Elements.Presets.AdvancedToggle(parent, config.Text or "Toggle", config.Default or false, config.Callback, theme)
        elseif componentType == "Slider" then
            return Elements.Presets.StyledSlider(parent, config.Text or "Slider", config.Min or 0, config.Max or 100, config.Default or 50, config.Callback, theme)
        end
    end
}

local function getNextLayoutOrder(parent)
    local maxOrder = 0
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("GuiObject") and child.LayoutOrder and child.LayoutOrder > maxOrder then
            maxOrder = child.LayoutOrder
        end
    end
    return maxOrder + 1
end

function Elements.Label(parent, text, config)
    config = config or {}
    local designs = getDesigns()
    if not designs then
        warn("[EvolutionLibs] No se pudo cargar el módulo Designs para Label")
        return nil
    end

    local theme = designs.Themes[config.Theme or "Dark"]
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = config.Size or UDim2.new(1, -20, 0, config.TextSize or 20)
    if config.Position then label.Position = config.Position end
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = config.Color or theme.Text
    label.Font = config.Bold and Enum.Font.GothamBold or Enum.Font.Gotham
    label.TextSize = config.TextSize or 16
    label.TextXAlignment = config.Alignment == "Center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
    if not (config.Size or config.Position) then
        label.LayoutOrder = getNextLayoutOrder(parent)
    end
    label.Parent = parent
    return label
end

function Elements.Button(parent, text, callback, config)
    config = config or {}
    local designs = getDesigns()
    if not designs then
        warn("[EvolutionLibs] No se pudo cargar el módulo Designs para Button")
        return nil
    end

    local theme = designs.Themes[config.Theme or "Dark"]
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = config.Size or UDim2.new(1, -20, 0, config.Height or 40)
    if config.Position then button.Position = config.Position end
    button.BackgroundColor3 = theme.Primary
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = theme.Text
    button.Font = config.Bold and Enum.Font.GothamBold or Enum.Font.Gotham
    button.TextSize = config.TextSize or 16
    if not (config.Size or config.Position) then
        button.LayoutOrder = getNextLayoutOrder(parent)
    end
    button.Parent = parent

    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, theme.BorderRadius or 6)
    corner.Parent = button

    -- Efecto hover
    Elements.Utils.AddHoverEffect(button, theme, "Glow")

    -- Callback
    if callback then
        button.MouseButton1Click:Connect(callback)
    end

    return button
end

function Elements.Toggle(parent, text, default, callback, config)
    config = config or {}
    local designs = getDesigns()
    if not designs then
        warn("[EvolutionLibs] No se pudo cargar el módulo Designs para Toggle")
        return nil
    end

    local theme = designs.Themes[config.Theme or "Dark"]
    
    -- Contenedor principal
    local container = Instance.new("Frame")
    container.Name = "Toggle"
    container.Size = config.Size or UDim2.new(1, -20, 0, config.Height or 40)
    if config.Position then container.Position = config.Position end
    container.BackgroundColor3 = theme.Surface
    container.BackgroundTransparency = 0.5
    container.BorderSizePixel = 0
    if not (config.Size or config.Position) then
        container.LayoutOrder = getNextLayoutOrder(parent)
    end
    container.Parent = parent

    -- Esquinas redondeadas para el contenedor
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, theme.BorderRadius or 6)
    containerCorner.Parent = container

    -- Texto del toggle
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = theme.Text
    label.Font = config.Bold and Enum.Font.GothamBold or Enum.Font.Gotham
    label.TextSize = config.TextSize or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    -- Switch container
    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -50, 0.5, -10)
    switch.BackgroundColor3 = default and theme.Primary or theme.Secondary
    switch.BorderSizePixel = 0
    switch.Parent = container

    -- Esquinas redondeadas para el switch
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch

    -- Círculo del switch
    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(default and 1 or 0, default and -18 or 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = switch

    -- Esquinas redondeadas para el círculo
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    -- Estado y lógica
    local enabled = default
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function updateVisuals()
        local utils = getUtils()
        if not utils then return end

        -- Animar el círculo
        local circleTween = game:GetService("TweenService"):Create(circle, tweenInfo, {
            Position = UDim2.new(enabled and 1 or 0, enabled and -18 or 2, 0.5, -8)
        })
        circleTween:Play()

        -- Animar el color del switch
        local switchTween = game:GetService("TweenService"):Create(switch, tweenInfo, {
            BackgroundColor3 = enabled and theme.Primary or theme.Secondary
        })
        switchTween:Play()
    end

    -- Botón invisible para interacción
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = container

    -- Efecto hover en el contenedor
    Elements.Utils.AddHoverEffect(container, theme, "Subtle")

    -- Conectar eventos
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateVisuals()
        if callback then
            callback(enabled)
        end
    end)

    return container
end

return Elements