-- Utils.lua - Advanced utility functions for EvolutionLibs GUI
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Utils = {
    _version = "2.0.0",
    _cache = {},
    _config = {
        DEBUG = false
    }
}

-- Error Handling
function Utils.try(fn, ...)
    local success, result = pcall(fn, ...)
    if not success and Utils._config.DEBUG then
        warn("[EvolutionLibs] Error:", result)
    end
    return success, result
end

function Utils.assertType(value, expectedType, paramName)
    if type(value) ~= expectedType then
        error(string.format("[EvolutionLibs] Expected %s to be %s, got %s", paramName, expectedType, type(value)), 2)
    end
end

function Utils.assertInstance(value, className, paramName)
    if not (typeof(value) == "Instance" and value:IsA(className)) then
        error(string.format("[EvolutionLibs] Expected %s to be Instance of %s", paramName, className), 2)
    end
end

-- Cache Management
function Utils.getCached(key)
    return Utils._cache[key]
end

function Utils.setCached(key, value)
    Utils._cache[key] = value
    return value
end

function Utils.clearCache()
    Utils._cache = {}
end

-- Easing Functions
function Utils.easeInQuad(t)
    Utils.assertType(t, "number", "t")
    return t * t
end

function Utils.easeOutQuad(t)
    Utils.assertType(t, "number", "t")
    return 1 - (1 - t) * (1 - t)
end

function Utils.easeInOutQuad(t)
    Utils.assertType(t, "number", "t")
    return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
end

function Utils.easeInCubic(t)
    Utils.assertType(t, "number", "t")
    return t * t * t
end

function Utils.easeOutCubic(t)
    Utils.assertType(t, "number", "t")
    return 1 - math.pow(1 - t, 3)
end

function Utils.easeInOutCubic(t)
    Utils.assertType(t, "number", "t")
    return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2
end

function Utils.easeOutBack(t)
    Utils.assertType(t, "number", "t")
    local c1 = 1.70158
    local c3 = c1 + 1
    return 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2)
end

function Utils.easeInElastic(t)
    Utils.assertType(t, "number", "t")
    local c4 = (2 * math.pi) / 3
    return t == 0 and 0 or t == 1 and 1 or -math.pow(2, 10 * t - 10) * math.sin((t * 10 - 10.75) * c4)
end

function Utils.easeOutElastic(t)
    Utils.assertType(t, "number", "t")
    local c4 = (2 * math.pi) / 3
    return t == 0 and 0 or t == 1 and 1 or math.pow(2, -10 * t) * math.sin((t * 10 - 0.75) * c4) + 1
end

-- Linear Interpolation
function Utils.lerp(a, b, t)
    Utils.assertType(a, "number", "a")
    Utils.assertType(b, "number", "b")
    Utils.assertType(t, "number", "t")
    return a + (b - a) * t
end

-- Color Utilities
function Utils.lerpColor(color1, color2, t)
    if typeof(color1) ~= "Color3" or typeof(color2) ~= "Color3" then
        error("[EvolutionLibs] lerpColor requires Color3 arguments", 2)
    end
    if type(t) ~= "number" then
        error("[EvolutionLibs] lerpColor requires number for t", 2)
    end
    t = math.clamp(t, 0, 1)
    return Color3.new(
        color1.R + (color2.R - color1.R) * t,
        color1.G + (color2.G - color1.G) * t,
        color1.B + (color2.B - color1.B) * t
    )
end

-- Color Conversion
function Utils.rgbToHsv(r, g, b)
    Utils.assertType(r, "number", "r")
    Utils.assertType(g, "number", "g")
    Utils.assertType(b, "number", "b")
    r, g, b = r / 255, g / 255, b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v = 0, 0, max

    if max ~= min then
        local d = max - min
        s = max == 0 and 0 or d / max
        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        else
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, v
end

function Utils.hsvToRgb(h, s, v)
    Utils.assertType(h, "number", "h")
    Utils.assertType(s, "number", "s")
    Utils.assertType(v, "number", "v")
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    return Color3.new(r, g, b)
end

-- Gradient System
function Utils.createGradient(startColor, endColor, rotation, gradientType)
    if typeof(startColor) ~= "Color3" or typeof(endColor) ~= "Color3" then
        error("[EvolutionLibs] Expected startColor and endColor to be Color3", 2)
    end
    gradientType = gradientType or "Linear"
    rotation = rotation or 0
    
    local success, gradient = Utils.try(function()
        local grad = Instance.new(gradientType == "Linear" and "UIGradient" or "UIRadialGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, startColor),
            ColorSequenceKeypoint.new(1, endColor)
        })
        grad.Rotation = rotation
        return grad
    end)
    
    if not success then
        warn("[EvolutionLibs] Failed to create gradient:", gradient)
        return nil
    end
    return gradient
end

-- UI Effects
function Utils.addHoverEffect(button, normalColor, hoverColor)
    if not button or not button:IsA("GuiButton") then
        error("[EvolutionLibs] addHoverEffect requires a GuiButton", 2)
    end
    if typeof(normalColor) ~= "Color3" or typeof(hoverColor) ~= "Color3" then
        error("[EvolutionLibs] addHoverEffect requires Color3 arguments", 2)
    end

    -- Crear conexiones con manejo de errores
    local success, connections = pcall(function()
        local enterConn = button.MouseEnter:Connect(function()
            Utils.try(function()
                local tween = TweenService:Create(button, 
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad), 
                    {BackgroundColor3 = hoverColor}
                )
                tween:Play()
            end)
        end)

        local leaveConn = button.MouseLeave:Connect(function()
            Utils.try(function()
                local tween = TweenService:Create(button, 
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad), 
                    {BackgroundColor3 = normalColor}
                )
                tween:Play()
            end)
        end)

        return {enterConn, leaveConn}
    end)

    if not success then
        warn("[EvolutionLibs] Error al crear hover effect:", connections)
        -- Fallback simple
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = hoverColor
        end)
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = normalColor
        end)
    end
end

-- Animation Utilities
function Utils.tweenProperty(instance, property, value, duration, easingStyle, easingDirection)
    if not instance or not instance:IsA("Instance") then
        error("[EvolutionLibs] tweenProperty requires an Instance", 2)
    end
    
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    duration = duration or 0.3

    local success, tween = pcall(function()
        local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
        local tween = TweenService:Create(instance, tweenInfo, {[property] = value})
        tween:Play()
        return tween
    end)

    if not success then
        warn("[EvolutionLibs] Error al crear tween:", tween)
        -- Fallback: asignar valor directamente
        pcall(function()
            instance[property] = value
        end)
        return nil
    end

    return tween
end

-- Responsive Design
function Utils.getResponsiveScale(screenSize, baseSize)
    if typeof(screenSize) ~= "Vector2" then
        error("[EvolutionLibs] getResponsiveScale requires Vector2 for screenSize", 2)
    end
    if type(baseSize) ~= "table" or #baseSize ~= 2 then
        error("[EvolutionLibs] getResponsiveScale requires table {width, height} for baseSize", 2)
    end

    local scaleX = screenSize.X / 1920
    local scaleY = screenSize.Y / 1080
    return UDim2.new(0, baseSize[1] * scaleX, 0, baseSize[2] * scaleY)
end

function Utils.clampPosition(position, screenSize)
    if typeof(position) ~= "UDim2" then
        error("[EvolutionLibs] clampPosition requires UDim2 for position", 2)
    end
    if typeof(screenSize) ~= "Vector2" then
        error("[EvolutionLibs] clampPosition requires Vector2 for screenSize", 2)
    end

    local x = math.clamp(position.X.Offset, 0, screenSize.X - 100)
    local y = math.clamp(position.Y.Offset, 0, screenSize.Y - 100)
    return UDim2.new(0, x, 0, y)
end

-- Debug Mode
function Utils.setDebug(enabled)
    Utils._config.DEBUG = enabled
end

-- Instance Management
function Utils.safeDestroy(instance)
    if typeof(instance) == "Instance" and instance.Parent then
        instance:Destroy()
    end
end

function Utils.safeClear(instance)
    if typeof(instance) == "Instance" then
        for _, child in ipairs(instance:GetChildren()) do
            child:Destroy()
        end
    end
end

return Utils