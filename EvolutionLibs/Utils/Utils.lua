-- Utils.lua - Advanced utility functions for EvolutionLibs GUI
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Utils = {}

local BASE_URL = "https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/main/EvolutionLibs/"

-- Easing Functions
function Utils.easeInQuad(t)
	return t * t
end

function Utils.easeOutQuad(t)
	return 1 - (1 - t) * (1 - t)
end

function Utils.easeInOutQuad(t)
	return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
end

function Utils.easeInCubic(t)
	return t * t * t
end

function Utils.easeOutCubic(t)
	return 1 - math.pow(1 - t, 3)
end

function Utils.easeInOutCubic(t)
	return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2
end

function Utils.easeOutBack(t)
	local c1 = 1.70158
	local c3 = c1 + 1
	return 1 + c3 * (t - 1)^3 + c1 * (t - 1)^2
end

function Utils.easeInElastic(t)
	local c4 = (2 * math.pi) / 3
	return t == 0 and 0 or t == 1 and 1 or -math.pow(2, 10 * t - 10) * math.sin((t * 10 - 10.75) * c4)
end

function Utils.easeOutElastic(t)
	local c4 = (2 * math.pi) / 3
	return t == 0 and 0 or t == 1 and 1 or math.pow(2, -10 * t) * math.sin((t * 10 - 0.75) * c4) + 1
end

-- Linear Interpolation
function Utils.lerp(a, b, t)
	return a + (b - a) * t
end

function Utils.lerpColor(color1, color2, t)
	return Color3.new(
		Utils.lerp(color1.R, color2.R, t),
		Utils.lerp(color1.G, color2.G, t),
		Utils.lerp(color1.B, color2.B, t)
	)
end

-- Color Conversion
function Utils.rgbToHsv(r, g, b)
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
	local r, g, b
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	
	i = i % 6
	if i == 0 then
		r, g, b = v, t, p
	elseif i == 1 then
		r, g, b = q, v, p
	elseif i == 2 then
		r, g, b = p, v, t
	elseif i == 3 then
		r, g, b = p, q, v
	elseif i == 4 then
		r, g, b = t, p, v
	elseif i == 5 then
		r, g, b = v, p, q
	end
	return Color3.new(r, g, b)
end

-- Gradient System
function Utils.createGradient(startColor, endColor, rotation, gradientType)
	gradientType = gradientType or "Linear"
	rotation = rotation or 0
	local gradient = Instance.new(gradientType == "Linear" and "UIGradient" or "UIRadialGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, startColor),
		ColorSequenceKeypoint.new(1, endColor)
	})
	gradient.Rotation = rotation
	return gradient
end

function Utils.createMultiPointGradient(colors, rotation)
	rotation = rotation or 0
	local keypoints = {}
	for i, color in ipairs(colors) do
		keypoints[i] = ColorSequenceKeypoint.new((i - 1) / (#colors - 1), color)
	end
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new(keypoints)
	gradient.Rotation = rotation
	return gradient
end

-- Color Palette Generation
function Utils.generateColorPalette(baseColor, variations)
	variations = variations or 5
	local palette = {}
	local baseH, baseS, baseV = Utils.rgbToHsv(baseColor.R * 255, baseColor.G * 255, baseColor.B * 255)
	
	for i = 1, variations do
		local offset = (i - 1) / (variations - 1)
		local newH = (baseH + offset * 0.15) % 1
		local newS = math.clamp(baseS - offset * 0.2, 0.3, 1)
		local newV = math.clamp(baseV + offset * 0.1, 0, 1)
		palette[i] = Utils.hsvToRgb(newH, newS, newV)
	end
	return palette
end

-- Animation Utilities
function Utils.tweenProperty(instance, property, target, duration, easingStyle, easingDirection)
	easingStyle = easingStyle or Enum.EasingStyle.Quad
	easingDirection = easingDirection or Enum.EasingDirection.Out
	local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
	local tween = TweenService:Create(instance, tweenInfo, {[property] = target})
	tween:Play()
	return tween
end

function Utils.tweenMultiple(instance, properties, duration, easingStyle, easingDirection)
	easingStyle = easingStyle or Enum.EasingStyle.Quad
	easingDirection = easingDirection or Enum.EasingDirection.Out
	local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	return tween
end

function Utils.addHoverEffect(instance, baseColor, hoverColor)
	instance.MouseEnter:Connect(function()
		Utils.tweenProperty(instance, "BackgroundColor3", hoverColor, 0.2)
	end)
	instance.MouseLeave:Connect(function()
		Utils.tweenProperty(instance, "BackgroundColor3", baseColor, 0.2)
	end)
end

-- Responsive Design
function Utils.getResponsiveScale(screenSize, baseSize)
	local scaleX = screenSize.X / 1920
	local scaleY = screenSize.Y / 1080
	return UDim2.new(0, baseSize[1] * scaleX, 0, baseSize[2] * scaleY)
end

function Utils.clampPosition(position, screenSize)
	local x = math.clamp(position.X.Offset, 0, screenSize.X - 100)
	local y = math.clamp(position.Y.Offset, 0, screenSize.Y - 100)
	return UDim2.new(0, x, 0, y)
end

-- Debugging Utilities
function Utils.logPerformance(label, callback)
	local startTime = tick()
	callback()
	local duration = tick() - startTime
	warn(string.format("[Performance] %s took %.4f seconds", label, duration))
end

function Utils.debounce(func, wait)
	local lastCall = 0
	return function(...)
		local now = tick()
		if now - lastCall >= wait then
			lastCall = now
			return func(...)
		end
	end
end

-- Animation Sequences
function Utils.createPulseAnimation(instance)
	local originalScale = instance.Size
	local pulse = coroutine.wrap(function()
		while true do
			Utils.tweenProperty(instance, "Size", UDim2.new(originalScale.X.Scale * 1.05, originalScale.X.Offset * 1.05, originalScale.Y.Scale * 1.05, originalScale.Y.Offset * 1.05), 0.5, Enum.EasingStyle.Sine)
			task.wait(0.5)
			Utils.tweenProperty(instance, "Size", originalScale, 0.5, Enum.EasingStyle.Sine)
			task.wait(0.5)
		end
	end)
	pulse()
	return pulse
end

-- Color Manipulation
function Utils.darkenColor(color, factor)
	local h, s, v = Utils.rgbToHsv(color.R * 255, color.G * 255, color.B * 255)
	v = math.clamp(v * (1 - factor), 0, 1)
	return Utils.hsvToRgb(h, s, v)
end

function Utils.lightenColor(color, factor)
	local h, s, v = Utils.rgbToHsv(color.R * 255, color.G * 255, color.B * 255)
	v = math.clamp(v + factor, 0, 1)
	return Utils.hsvToRgb(h, s, v)
end

-- Serialization for Theme Persistence
function Utils.serializeColor(color)
	return {R = color.R * 255, G = color.G * 255, B = color.B * 255}
end

function Utils.deserializeColor(data)
	return Color3.fromRGB(data.R, data.G, data.B)
end

return Utils
