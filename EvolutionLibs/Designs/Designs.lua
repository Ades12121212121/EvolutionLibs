-- Designs/Designs.lua - Sistema de temas, efectos y componentes

local BASE_URL = "https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/main/EvolutionLibs/"
_G.EvoLibsCache = _G.EvoLibsCache or {}
local function getUtils()
    if not _G.EvoLibsCache.Utils then _G.EvoLibsCache.Utils = loadstring(game:HttpGet(BASE_URL .. "Utils/Utils.lua"))() end
    return _G.EvoLibsCache.Utils
end

local Designs = {}

-- Sistema de configuración avanzado
local Config = {
    DefaultTheme = "Dark",
    AnimationSpeed = 0.3,
    EnableParticles = true,
    EnableSounds = false,
    EnableGradients = true,
    EnableGlow = true,
    EnableBlur = false,
    GlobalScale = 1.0,
    BorderRadius = 8,
    ShadowIntensity = 0.3
}

-- Temas base expandidos
Designs.Themes = {
    Dark = {
        -- Colores básicos
        Background = Color3.fromRGB(18, 18, 24),
        Surface = Color3.fromRGB(28, 28, 36),
        Primary = Color3.fromRGB(88, 166, 255),
        Secondary = Color3.fromRGB(45, 45, 55),
        Accent = Color3.fromRGB(255, 107, 129),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 190),
        Border = Color3.fromRGB(60, 60, 70),
        
        -- Estados
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
        Info = Color3.fromRGB(59, 130, 246),
        
        -- Interacciones
        Hover = Color3.fromRGB(255, 255, 255),
        Active = Color3.fromRGB(168, 85, 247),
        Disabled = Color3.fromRGB(107, 114, 128),
        Focus = Color3.fromRGB(147, 197, 253),
        
        -- Gradientes
        PrimaryGradient = getUtils().createGradient(Color3.fromRGB(88, 166, 255), Color3.fromRGB(168, 85, 247), 45),
        AccentGradient = getUtils().createGradient(Color3.fromRGB(255, 107, 129), Color3.fromRGB(255, 154, 0), 90),
        BackgroundGradient = getUtils().createGradient(Color3.fromRGB(18, 18, 24), Color3.fromRGB(28, 28, 36), 180),
        
        -- Efectos
        Shadow = Color3.fromRGB(0, 0, 0),
        Glow = Color3.fromRGB(88, 166, 255),
        Particle = Color3.fromRGB(168, 85, 247),
        
        -- Transparencias
        Transparency = {
            Light = 0.1,
            Medium = 0.3,
            Heavy = 0.6,
            Glass = 0.8
        },
        
        -- Configuración específica
        BorderRadius = 12,
        ShadowOffset = Vector2.new(0, 4),
        GlowIntensity = 0.5,
        AnimationSpeed = 0.25
    },
    
    Light = {
        Background = Color3.fromRGB(255, 255, 255),
        Surface = Color3.fromRGB(248, 250, 252),
        Primary = Color3.fromRGB(59, 130, 246),
        Secondary = Color3.fromRGB(226, 232, 240),
        Accent = Color3.fromRGB(236, 72, 153),
        Text = Color3.fromRGB(15, 23, 42),
        TextSecondary = Color3.fromRGB(100, 116, 139),
        Border = Color3.fromRGB(203, 213, 225),
        
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(245, 158, 11),
        Error = Color3.fromRGB(239, 68, 68),
        Info = Color3.fromRGB(14, 165, 233),
        
        Hover = Color3.fromRGB(15, 23, 42),
        Active = Color3.fromRGB(147, 51, 234),
        Disabled = Color3.fromRGB(148, 163, 184),
        Focus = Color3.fromRGB(96, 165, 250),
        
        PrimaryGradient = getUtils().createGradient(Color3.fromRGB(59, 130, 246), Color3.fromRGB(147, 51, 234), 45),
        AccentGradient = getUtils().createGradient(Color3.fromRGB(236, 72, 153), Color3.fromRGB(251, 146, 60), 90),
        BackgroundGradient = getUtils().createGradient(Color3.fromRGB(255, 255, 255), Color3.fromRGB(248, 250, 252), 180),
        
        Shadow = Color3.fromRGB(15, 23, 42),
        Glow = Color3.fromRGB(59, 130, 246),
        Particle = Color3.fromRGB(147, 51, 234),
        
        Transparency = {
            Light = 0.05,
            Medium = 0.15,
            Heavy = 0.4,
            Glass = 0.7
        },
        
        BorderRadius = 8,
        ShadowOffset = Vector2.new(0, 2),
        GlowIntensity = 0.3,
        AnimationSpeed = 0.2
    },
    
    Cyberpunk = {
        Background = Color3.fromRGB(10, 10, 15),
        Surface = Color3.fromRGB(20, 20, 30),
        Primary = Color3.fromRGB(0, 255, 255),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(255, 0, 128),
        Text = Color3.fromRGB(0, 255, 255),
        TextSecondary = Color3.fromRGB(128, 255, 255),
        Border = Color3.fromRGB(0, 255, 255),
        
        Success = Color3.fromRGB(0, 255, 127),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 20, 147),
        Info = Color3.fromRGB(173, 216, 230),
        
        Hover = Color3.fromRGB(0, 255, 255),
        Active = Color3.fromRGB(255, 0, 255),
        Disabled = Color3.fromRGB(64, 64, 80),
        Focus = Color3.fromRGB(255, 255, 255),
        
        PrimaryGradient = getUtils().createGradient(Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 0, 255), 45),
        AccentGradient = getUtils().createGradient(Color3.fromRGB(255, 0, 128), Color3.fromRGB(255, 20, 147), 90),
        BackgroundGradient = getUtils().createGradient(Color3.fromRGB(10, 10, 15), Color3.fromRGB(20, 20, 30), 180),
        
        Shadow = Color3.fromRGB(0, 0, 0),
        Glow = Color3.fromRGB(0, 255, 255),
        Particle = Color3.fromRGB(255, 0, 255),
        
        Transparency = {
            Light = 0.2,
            Medium = 0.4,
            Heavy = 0.7,
            Glass = 0.9
        },
        
        BorderRadius = 2,
        ShadowOffset = Vector2.new(0, 0),
        GlowIntensity = 1.0,
        AnimationSpeed = 0.15
    },
    
    Nature = {
        Background = Color3.fromRGB(20, 30, 25),
        Surface = Color3.fromRGB(35, 50, 40),
        Primary = Color3.fromRGB(76, 175, 80),
        Secondary = Color3.fromRGB(50, 70, 55),
        Accent = Color3.fromRGB(255, 193, 7),
        Text = Color3.fromRGB(200, 230, 201),
        TextSecondary = Color3.fromRGB(165, 214, 167),
        Border = Color3.fromRGB(102, 187, 106),
        
        Success = Color3.fromRGB(139, 195, 74),
        Warning = Color3.fromRGB(255, 235, 59),
        Error = Color3.fromRGB(244, 67, 54),
        Info = Color3.fromRGB(79, 195, 247),
        
        Hover = Color3.fromRGB(165, 214, 167),
        Active = Color3.fromRGB(129, 199, 132),
        Disabled = Color3.fromRGB(120, 144, 156),
        Focus = Color3.fromRGB(174, 213, 129),
        
        PrimaryGradient = getUtils().createGradient(Color3.fromRGB(76, 175, 80), Color3.fromRGB(139, 195, 74), 45),
        AccentGradient = getUtils().createGradient(Color3.fromRGB(255, 193, 7), Color3.fromRGB(255, 235, 59), 90),
        BackgroundGradient = getUtils().createGradient(Color3.fromRGB(20, 30, 25), Color3.fromRGB(35, 50, 40), 180),
        
        Shadow = Color3.fromRGB(0, 20, 10),
        Glow = Color3.fromRGB(76, 175, 80),
        Particle = Color3.fromRGB(139, 195, 74),
        
        Transparency = {
            Light = 0.1,
            Medium = 0.25,
            Heavy = 0.5,
            Glass = 0.75
        },
        
        BorderRadius = 16,
        ShadowOffset = Vector2.new(0, 3),
        GlowIntensity = 0.4,
        AnimationSpeed = 0.35
    },
    
    Ocean = {
        Background = Color3.fromRGB(15, 25, 35),
        Surface = Color3.fromRGB(25, 40, 55),
        Primary = Color3.fromRGB(3, 169, 244),
        Secondary = Color3.fromRGB(40, 58, 75),
        Accent = Color3.fromRGB(0, 188, 212),
        Text = Color3.fromRGB(224, 247, 250),
        TextSecondary = Color3.fromRGB(178, 223, 219),
        Border = Color3.fromRGB(77, 182, 172),
        
        Success = Color3.fromRGB(38, 166, 154),
        Warning = Color3.fromRGB(255, 202, 40),
        Error = Color3.fromRGB(244, 81, 30),
        Info = Color3.fromRGB(130, 177, 255),
        
        Hover = Color3.fromRGB(178, 223, 219),
        Active = Color3.fromRGB(77, 208, 225),
        Disabled = Color3.fromRGB(120, 144, 156),
        Focus = Color3.fromRGB(129, 212, 250),
        
        PrimaryGradient = getUtils().createGradient(Color3.fromRGB(3, 169, 244), Color3.fromRGB(0, 188, 212), 45),
        AccentGradient = getUtils().createGradient(Color3.fromRGB(0, 188, 212), Color3.fromRGB(38, 166, 154), 90),
        BackgroundGradient = getUtils().createGradient(Color3.fromRGB(15, 25, 35), Color3.fromRGB(25, 40, 55), 180),
        
        Shadow = Color3.fromRGB(0, 10, 20),
        Glow = Color3.fromRGB(3, 169, 244),
        Particle = Color3.fromRGB(0, 188, 212),
        
        Transparency = {
            Light = 0.15,
            Medium = 0.3,
            Heavy = 0.6,
            Glass = 0.8
        },
        
        BorderRadius = 20,
        ShadowOffset = Vector2.new(0, 6),
        GlowIntensity = 0.6,
        AnimationSpeed = 0.4
    }
}

-- Sistema de efectos visuales
Designs.Effects = {
    -- Crear sombra
    CreateShadow = function(element, theme, intensity)
        intensity = intensity or theme.Transparency.Medium
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Size = UDim2.new(1, 8, 1, 8)
        shadow.Position = UDim2.new(0, theme.ShadowOffset.X, 0, theme.ShadowOffset.Y)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        shadow.ImageColor3 = theme.Shadow
        shadow.ImageTransparency = intensity
        shadow.ZIndex = element.ZIndex - 1
        shadow.Parent = element.Parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, theme.BorderRadius)
        corner.Parent = shadow
        
        return shadow
    end,
    
    -- Crear efecto de brillo
    CreateGlow = function(element, theme, intensity)
        if not Config.EnableGlow then return end
        
        intensity = intensity or theme.GlowIntensity
        local glow = Instance.new("ImageLabel")
        glow.Name = "Glow"
        glow.Size = UDim2.new(1, 20, 1, 20)
        glow.Position = UDim2.new(0, -10, 0, -10)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        glow.ImageColor3 = theme.Glow
        glow.ImageTransparency = 1 - intensity
        glow.ZIndex = element.ZIndex - 1
        glow.Parent = element.Parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, theme.BorderRadius + 10)
        corner.Parent = glow
        
        return glow
    end,
    
    -- Aplicar gradiente
    ApplyGradient = function(element, gradient, direction)
        if not Config.EnableGradients then return end
        
        direction = direction or "Vertical"
        local gradientObj = Instance.new("UIGradient")
        gradientObj.Color = gradient.ColorSequence
        gradientObj.Rotation = gradient.Rotation or 0
        gradientObj.Parent = element
        
        return gradientObj
    end,
    
    -- Crear efecto de ondas (ripple)
    CreateRipple = function(element, color, duration)
        duration = duration or 0.6
        color = color or Color3.fromRGB(255, 255, 255)
        
        element.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local ripple = Instance.new("Frame")
                ripple.Name = "Ripple"
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.BackgroundColor3 = color
                ripple.BackgroundTransparency = 0.5
                ripple.BorderSizePixel = 0
                ripple.ZIndex = element.ZIndex + 10
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = ripple
                ripple.Parent = element
                
                local mouse = game:GetService("UserInputService"):GetMouseLocation()
                local elementPos = element.AbsolutePosition
                local elementSize = element.AbsoluteSize
                local relativeX = mouse.X - elementPos.X
                local relativeY = mouse.Y - elementPos.Y
                
                ripple.Position = UDim2.new(0, relativeX, 0, relativeY)
                
                local maxSize = math.max(elementSize.X, elementSize.Y) * 2.5
                local tween = game:GetService("TweenService"):Create(ripple,
                    TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {
                        Size = UDim2.new(0, maxSize, 0, maxSize),
                        Position = UDim2.new(0, relativeX - maxSize/2, 0, relativeY - maxSize/2),
                        BackgroundTransparency = 1
                    }
                )
                tween:Play()
                tween.Completed:Connect(function()
                    ripple:Destroy()
                end)
            end
        end)
    end,
    
    -- Sistema de partículas
    CreateParticles = function(element, theme, count)
        if not Config.EnableParticles then return end
        
        count = count or 20
        local particles = {}
        
        for i = 1, count do
            local particle = Instance.new("Frame")
            particle.Name = "Particle"
            particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
            particle.BackgroundColor3 = theme.Particle
            particle.BackgroundTransparency = math.random(30, 80) / 100
            particle.BorderSizePixel = 0
            particle.ZIndex = element.ZIndex + 5
            particle.Parent = element
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = particle
            
            -- Animación de partículas
            local startPos = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
            local endPos = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
            particle.Position = startPos
            
            local tween = game:GetService("TweenService"):Create(particle,
                TweenInfo.new(math.random(2, 5), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true),
                {Position = endPos}
            )
            tween:Play()
            
            table.insert(particles, {element = particle, tween = tween})
        end
        
        return particles
    end
}

-- API simplificada para usuarios
Designs.Simple = {
    -- Configuración rápida
    Setup = function(themeName, options)
        themeName = themeName or "Dark"
        options = options or {}
        
        Config.DefaultTheme = themeName
        for key, value in pairs(options) do
            if Config[key] ~= nil then
                Config[key] = value
            end
        end
        
        return Designs.Themes[themeName]
    end,
    
    -- Aplicar tema global
    ApplyGlobalTheme = function(themeName)
        Config.DefaultTheme = themeName
        return Designs.Themes[themeName]
    end,
    
    -- Generar tema personalizado
    CustomTheme = function(baseColor, name)
        name = name or "Custom"
        local palette = getUtils().generateColorPalette(baseColor, 8)
        
        local customTheme = {
            Background = palette[1],
            Surface = palette[2],
            Primary = baseColor,
            Secondary = palette[3],
            Accent = palette[4],
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(200, 200, 200),
            Border = palette[5],
            
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Error = Color3.fromRGB(239, 68, 68),
            Info = baseColor,
            
            Hover = Color3.fromRGB(255, 255, 255),
            Active = palette[6],
            Disabled = Color3.fromRGB(120, 120, 120),
            Focus = palette[7],
            
            PrimaryGradient = getUtils().createGradient(baseColor, palette[8], 45),
            AccentGradient = getUtils().createGradient(palette[4], palette[6], 90),
            BackgroundGradient = getUtils().createGradient(palette[1], palette[2], 180),
            
            Shadow = Color3.fromRGB(0, 0, 0),
            Glow = baseColor,
            Particle = palette[8],
            
            Transparency = {
                Light = 0.1,
                Medium = 0.3,
                Heavy = 0.6,
                Glass = 0.8
            },
            
            BorderRadius = 10,
            ShadowOffset = Vector2.new(0, 4),
            GlowIntensity = 0.5,
            AnimationSpeed = 0.3
        }
        
        Designs.Themes[name] = customTheme
        return customTheme
    end,
    
    -- Obtener configuración actual
    GetConfig = function()
        return Config
    end
}

return Designs
